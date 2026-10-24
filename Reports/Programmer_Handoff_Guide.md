# Programmer Handoff Guide

Status: onboarding to accepted Prototype 3. The accompanying Prototype 4 specification is proposed, not implemented. This handoff does not authorize gameplay changes, publication, or merging.

## Repository and baseline

- Local project: `C:\Users\azwam\Projects\planetary-attacker-defender`.
- Repository: `https://github.com/CumulusInsight/planetary-attacker-defender.git`.
- Accepted branch: `main`.
- Accepted Prototype 3 commit: `85424c035801bb50f5f894614d53ca2512123dbc`.
- Annotated tags: `planetary-prototype2-data-driven-attackers-v1` and `planetary-prototype3-json-attack-data-v1`.
- The branch and both tags were published and verified during the preceding handoff. This documentation task does not refetch or change them.

The game currently allows selection and reading while three threats move continuously. There is no defensive choice system. The new planning documents may initially be untracked; do not discard or accidentally include them in unrelated changes.

## Open and run Godot

Use the tested **Godot 4.7.2 stable Mono** build where available. `project.godot` declares Godot 4.7 / Forward Plus. Gameplay uses GDScript; compatibility with other versions/renderers has not been established.

1. Obtain the repository in your own workspace, or inspect Git status before touching the shared workspace.
2. In Godot's Project Manager, choose Import and select the root `project.godot`.
3. Let Godot import source assets into its local `.godot` cache. Do not commit the cache or copy someone else's cache.
4. Open `scene/game.tscn`. Press **F6** for that scene or **F5** for the configured project main scene.
5. Expect three attackers around DATA. Hover for information, click to enlarge/select, then click another to transfer selection. All three keep moving.

Original workstation console executable:

```text
C:\Users\azwam\Projects\Godot_4.7\Godot_v4.7.2-stable_mono_win64\Godot_v4.7.2-stable_mono_win64_console.exe
```

Use your own installed path on another machine. PowerShell example:

```powershell
Set-Location 'C:\Users\azwam\Projects\planetary-attacker-defender'
$godotExe = 'C:\Users\azwam\Projects\Godot_4.7\Godot_v4.7.2-stable_mono_win64\Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path .
```

The tracked `new_projectV2/new_project_v2.exe` was not rebuilt for Prototype 2/3 completion. Use the Godot source, not that existing export, to review accepted behavior. No executable rebuild is part of this handoff.

## Source map

| Path | Responsibility |
| --- | --- |
| `project.godot` | Main scene, 1600 by 900 viewport, renderer configuration. |
| `scene/game.tscn` | Main Node2D, DataCenter, EnemyContainer, exactly three instances named Enemy, Enemy2, Enemy3. |
| `scene/enemy.tscn` | Sprite, AttackLabel, moving InfoPanel/InfoLabel, Area2D, circular collision shape, input/hover signal connections. |
| `scene/datacenter.tscn` | Fixed DATA visual and `$1,000,000` label. |
| `script/game.gd` | Validated initialization, selected/last-hovered IDs, exclusive highlighting, and ring drawing. |
| `script/attack_data_loader.gd` | Local JSON loading and complete-dataset validation, without visual side effects. |
| `script/enemy.gd` | Reusable Enemy class: configuration, movement, selection visuals, local panel, and input. |
| `data/attacks.json` | Three sample placeholder attack records. |
| `tests/prototype3_test.gd` | SceneTree regression runner for loading, failure handling, input, and motion. |
| `images/`, `fonts/` | Existing artwork/fonts. Preserve tracked source and import sidecars. |
| `Reports/` | Historical completion reports and current design, specification, and handoff documents. |

Keep generated `.gd.uid` files with scripts. `.godot/` is ignored generated state. The root README is minimal; the reports contain the detailed handoff.

## How JSON reaches attackers

1. During `game.gd._enter_tree()`, `attack_data_path` defaults to `res://data/attacks.json`.
2. The controller calls `AttackDataLoader.load_attacks(path, attackers.size())`.
3. The loader opens/parses the array, validates count, required fields, types/ranges, and unique IDs, then normalizes numbers. It returns `records` and `error`.
4. Only if the complete dataset validates does the controller assign six properties to each existing attacker, mapping array order to scene-child order.
5. It connects the attackers' selection/hover signals. Children subsequently run `_ready()` to initialize their labels, panels, textures, and configured rings.

Reusable fields: `attack_id`, `abbreviation`, `description`, `severity`, `move_speed`, `start_ring`. IDs and severity are non-negative 32-bit integers; IDs must be unique. Text must contain non-whitespace characters. Speed must be finite and positive. Ring must be 0–2. Numeric strings and booleans are not accepted as numbers. Additional keys are not passed to attacker properties.

Shipped data: VM ESC/ROOTKIT/FILELESS, IDs 1/2/3, speeds 0.7/0.9/1.1 radians per second, all starting on ring 2. Loading happens once per scene entry; restart to see file edits. Schema changes require loader/test review, not merely adding UI-specific keys.

Failure logs a path-specific error and hides/disables the attacker container. No partial configuration or replacement identity is supplied. Inspect the debugger/output or console; there is no error overlay. Attackers do not load JSON themselves.

## Selection, hover, and movement

`Area2D.input_event` detects a left-button press; the attacker emits `attacker_selected(attack_id)`. The controller stores `selected_attack_id` and calls `set_selected()` for every attacker. Only the matching ID is enlarged; others restore normal scale. Re-clicking the selected attacker leaves it selected. Empty-space clicks do not clear selection. Reading never pauses the scene tree.

`mouse_entered` opens local information and emits `attacker_hovered(attack_id)`. `mouse_exited` closes the panel unless selected. The controller's `hovered_attack_id` records the last hovered ID, not necessarily the currently hovered object; no hover-cleared interface exists. Hover does not transfer selection. Current panels are moving children of attackers, not a fixed HUD.

Movement advances angle using delta time while separately accumulating traveled radians. Every full orbit immediately reduces the ring by one, clamped at zero. Radii are 400 → 280 → 160 pixels around `(800, 450)`. Each attacker retains its configured speed on the inner ring. Do not replace jumps with a spiral or make progression depend on another attacker's signals.

## Run existing tests

From the project root with the console executable configured above:

```powershell
& $godotExe --path . --script res://tests/prototype3_test.gd
$LASTEXITCODE
```

Use this rendered invocation for validated viewport input/picking and visual checks. It takes about 20 seconds. Success ends with `PROTOTYPE 3 TEST: PASS (0 failures)` and exit code 0.

Coverage includes all three JSON identities/properties, hover descriptions, exclusive selection transfer, continuous movement during selection, full orbits before jumps, both inward jumps for each attacker, innermost motion, and DATA value. Loader tests cover invalid fields, syntax, duplicate IDs, and missing files. An alternate valid fixture verifies that changed JSON reaches the attacker interface.

Two `ERROR: Attack data ...` messages are intentional controller failure cases: missing file and malformed record. Read the final summary and exit code. Unexpected script errors, FAIL, or nonzero exit require investigation.

The runner writes/deletes `user://prototype3_validation_fixture.json` and saves `user://prototype3_test_viewport.png`. On the original Windows machine, `user://` is under `%APPDATA%\Godot\app_userdata\planetary-attacker-defender`. Run only one suite instance at a time because the fixture name is shared; do not use it for personal files. Tests do not edit shipped JSON.

Quick source startup check:

```powershell
& $godotExe --headless --path . --quit-after 120
```

This is not a substitute for rendered interaction tests. Accepted Prototype 3 passed previously; this documentation-only task did not rerun gameplay tests.

## Safe contribution workflow

Inspect first:

```powershell
git rev-parse --show-toplevel
git branch --show-current
git status --short --untracked-files=all
git log -3 --oneline --decorate
```

Do not overwrite, clean, automatically stash, or commit someone else's work. If the shared workspace contains unrelated uncommitted changes, coordinate with the owner or use your own clone. A branch alone does not isolate uncommitted files.

After an implementation task is approved, create a separate branch from the accepted source, for example:

```powershell
git switch -c feature/prototype4-stationary-info-panel planetary-prototype3-json-attack-data-v1
```

Run that only in an appropriate clean workspace after approval. It is future contribution guidance, not permission to start Prototype 4. Leave accepted `main` and checkpoint tags unchanged. Never move tags or force-push in routine development.

A proposal should state the observed issue, concrete before/after behavior, affected files, acceptance criteria, and evidence. Prefer a small patch to a redesign. Preserve three attackers, continuous independent motion, discrete jumps, JSON validation, and controller-owned selection unless an approved specification changes them.

Before review, inspect the full diff and `git diff --check`, run relevant regressions, visually inspect the changed flow, and report limitations. If a commit is authorized, stage explicit owned paths. Do not push or merge without authorization. Update test UI expectations only where approved behavior supersedes them; do not weaken data/movement checks just to obtain a pass.

## Immediate next review

Read [the game design plan](Planetary_Attacker_Defender_Game_Design_Plan.md) and [the Prototype 4 specification](Prototype_4_Implementation_Plan.md). Propose placement, fields, and hover policy on paper first. Defensive decisions, evaluation, shooting, scoring, damage, new data sources, and Prototype 5+ systems are outside Prototype 4.

The owner must approve implementation scope. Until then, this handoff ends at documentation and review.
