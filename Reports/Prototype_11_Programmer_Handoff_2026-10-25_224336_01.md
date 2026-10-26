# Prototype 11 - Programmer and Artwork Handoff

Created: 2026-10-25T22:43:36-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_11_Programmer_Handoff_2026-10-25_224336_01.md`.

## Accepted project and exact checkpoint

Orbital Defense Command is a Godot cybersecurity teaching game. Prototype 11 adds an isolated Analyze -> Report -> Decide learning workflow to the complete Prototype 10 command interface. The owner has accepted the current gameplay. The next programmer should concentrate on artwork and presentation. Changes to cybersecurity logic, scoring, deadlines, answer keys, question construction, firing semantics, or gameplay mechanics require owner approval.

- Engine: **Godot 4.7.2 stable Mono**.
- Repository: https://github.com/CumulusInsight/planetary-attacker-defender.git
- Feature branch: `feature/prototype11-simplified-cyber-game`.
- Accepted gameplay release tag: `planetary-prototype11-complete-v1` (annotated).
- Exact tagged gameplay commit: `27ef7e8995de8a4270a548086614fabf52a7e6e4`.
- Parent / preserved Prototype 10 checkpoint: `ee96eebb88d942d9302a9aa740e1414fb931eba1`, tag `planetary-prototype10-complete-v1`.

This handoff is published in a subsequent documentation-only commit on the same feature branch. The release tag stays on the gameplay commit above. The final checkpoint report records both commits; the branch tip may therefore be newer than the release tag without a gameplay difference. Main has not been merged or modified.

## Clone, open and launch

Install Git and Godot 4.7.2 Mono. Python 3 is needed for the separate catalog reproduction test, not for normal gameplay. Clone the feature branch:

```powershell
git clone --branch feature/prototype11-simplified-cyber-game https://github.com/CumulusInsight/planetary-attacker-defender.git
Set-Location planetary-attacker-defender
git status --short
git rev-parse 'planetary-prototype11-complete-v1^{commit}'
```

The final command must print `27ef7e8995de8a4270a548086614fabf52a7e6e4`. Import `project.godot` in Godot's Project Manager, allow its local `.godot` cache to rebuild, then press F5. The configured main scene is `scene/learning_command.tscn`. Do not replace it with the legacy executable. The project uses a 1600 x 900 reference viewport and Forward+ rendering.

Example console commands (set the executable path for your machine):

```powershell
$odcGodot = 'C:/path/to/Godot_v4.7.2-stable_mono_win64_console.exe'
& $odcGodot --headless --editor --path . --import
& $odcGodot --path .
# Reproducible learning session and center-count limit:
& $odcGodot --path . -- --odc-learning-seed=12345 --odc-learning-centers=3
# Independently runnable accepted detailed Prototype 10 interface:
& $odcGodot --path . res://scene/direct_command.tscn
# Independently runnable original tactical scene:
& $odcGodot --path . res://scene/game.tscn
```

Normal sessions use a fresh recorded seed. `--odc-learning-centers=1`, `2`, or `3` limits the learning presentation to that many participating centers. The current seed/plan record is generated in Godot's user-data directory, not in the repository. No database, network service or Python process is required to play.

## Quick gameplay review

1. **A - Analyze:** opens the existing YES/NO/Close question. YES analyzes the current public learning contacts and automatically opens Report. At a completed round, A -> YES starts the next unused round. NO and Close do not analyze.
2. **R - Report:** opens current or historical Report directly, without analyzing or advancing. Before initial analysis it asks the player to use A. Review the attack, timer and four actual catalog defense names. Choose answers for one or several contacts. Hovering shows catalog explanations without disclosing correctness. All nine headings sort ascending/descending; countdown labels update without continuously reordering rows.
3. **D - Decide:** FIRE NOW, or wait exactly 1/5/10 simulation minutes for the selected volley. A scheduled volley holds a snapshot of its targets and answers and can be canceled. Multiple projectiles launch together. Answers are evaluated at hit/miss, never on selection.
4. Correct answers visually neutralize only learning targets and display TIME 00:00. Incorrect answers leave targets visible, continue their learning clocks, and reveal the designated correct defense afterward. Learning visual destruction is an educational convention, not real cybersecurity behavior or a physical-combat result.
5. Correct/incorrect counts, percentage and elapsed simulation time accumulate across rounds of **5, 5 and 2** questions. Completed rounds remain read-only in the Report round selector. Restart learning session deliberately resets the learning session.

The original O/C/T/E/H/M/Alerts controls remain available for comparison with Prototype 10. Learning outcomes do not execute or rewrite its operational commands, hidden truths, official score or canonical event ledger.

## One-, two- and three-center display

Learning analysis and volleys show their participating centers in distinct labeled plots, never merging contacts across centers. For a one-center presentation, use **RESET TO ONE** while multiple plots are visible; it uses the explicitly selected center, defaulting to DC-01. The top center selector changes the displayed center in single-center learning mode. It retains its original Prototype 10 behavior outside learning presentation.

Two-center and three-center examples can be reproduced with the command-line center limit above and answers selected across those centers. A volley opens the appropriate participating plots. They remain visible after firing; there is **no automatic reset**. RESET TO ONE is visible only for two/three plots. A reset requested during flight/impact waits until every effect is finished, preserving results and scoring.

Flight takes **3.6 simulation seconds**. Correct-hit expansion lasts **1.95 seconds** and is three times the earlier effect radius. Its center stays at the captured impact position; enlarged geometry is confined to the associated display. Miss effects remain 0.65 seconds. Strategic pause holds learning flight/effect age and scheduled-shot time. Existing Prototype 10 background-traffic pause policy is preserved.

## Source and artwork map

| Location | Responsibility / artwork notes |
|---|---|
| `scene/learning_command.tscn` | Isolated P11 wrapper around existing `scene/direct_command.tscn`. Preserve child linkage. |
| `script/learning_game.gd` | A/R/D windows, report/metrics/history presentation, volley integration and visual target hiding. Styling edits require preserving button callbacks and state bindings. |
| `script/learning_orbital_display.gd` | Read-only projection of existing actors into 1/2/3 screen-space plots. Draws plot borders, ring/ellipse paths, DATA and labels; copies actor sprite artwork and creates neutral diamond markers. Candidate for approved presentation-only improvements. Preserve coordinate transforms, interaction callbacks and IDs. |
| `script/learning_projectile.gd` | Native trail, projectile head, homing visual, hit/miss impact artwork and effect clipping. Candidate for replacing visual drawing with approved original effects. Preserve timestamps, 3.6/1.95/0.65 durations, impact signal timing, hit/miss distinction and center association. |
| `images/enemy1.png`, `enemy2.png`, `enemy3.png` | Existing shared attacker artwork. Shared replacements also affect Prototype 10; prefer new P11-specific assets and an isolated presentation reference after approval. |
| `images/data.png`, `scene/datacenter.tscn` | Current DATA artwork and accepted target labels. Learning projection reads the original DATA Sprite2D texture. |
| `images/datacenter.png`, `images/icon.svg` | Additional existing project assets; inspect actual scene usage before replacing. |
| `scene/enemy.tscn`, `script/enemy.gd` | Shared visible sprite, enlarged interaction shape, hover/input and movement. Do not change gameplay or hit areas for an artwork task. |
| `fonts/` | Existing fonts. Add only properly licensed fonts and preserve readable sizing at 1600 x 900. |

Safer first contributions: new original PNG/SVG artwork in a distinct asset subfolder, a preview/mockup, palette or visual-effect proposals, and changes limited to approved rendering properties. Retain `.uid` and necessary resource import sidecars; do not hand-edit UID identities or publish `.godot` caches. Do not download or copy unlicensed images. Agree asset scale, file formats and dimensions with the owner before treating them as final constraints.

Do not change node names, signal connections, input hit boxes, marker contact IDs, center origins, selection behavior or orbit transforms while replacing art. Effects must not obscure controls or adjacent center displays. Keep neutral contact appearance independent of private hostile/neutral truth.

## Protected logic and data

- `script/learning_session.gd`: answer snapshots, idempotent impact evaluation, cumulative metrics, rounds/history and learning deadlines.
- `script/learning_question_loader.gd`: catalog/reference validation, seed plan, contact association and designated answer/distractor validation.
- `data/learning_question_bank.json`: 12 validated templates; `data/learning_questions.json`: original five-question compatibility fixture. Preserve questions, IDs, keys and mappings.
- `data/cyber_catalog.json`: authoritative validated export of v12 `cyber_defensev12/data/cyber.db`: 100 attacks, 185 defenses, 211 mappings. The SQLite original is read-only and not required in the game repository.
- Original command/scenario/scoring files, including `script/command_center.gd`, `game.gd`, `enemy.gd`, `surveillance_contact.gd`, `orbital_deadline.gd`, `mission_ledger.gd`, `operations_session.gd`, cyber evaluators, `data/cyber_scenarios.json`, `contact_operations.json` and intelligence fixtures: protected existing systems.
- Existing regression tests and assertions must not be weakened to accommodate artwork. Do not expose answer keys or private scenario truth in tooltips, labels or colors.

## Tests and actual checkpoint verification

All Prototype 3-11 suites, catalog reproduction, import, main/Prototype 10/standalone startup and Git diff checks passed before the gameplay checkpoint. The latest suites include manual reset/timer/sorting and A/R/projectile/effect checks. Rendered tests use a 1600 x 900 test viewport with injected input. They are not a claim of a manual desktop playthrough.

Run Godot suites sequentially, not concurrently:

```powershell
$odcSuites = @(
 'prototype3','prototype4','prototype5','prototype6','prototype7','prototype8','prototype9',
 'prototype9_corrections','prototype9_cyber','prototype9_decision',
 'prototype10_stage1','prototype10_stage2','prototype10_stage3','prototype10_stage4',
 'prototype11','prototype11_refinements','prototype11_multicenter','prototype11_continuity',
 'prototype11_manual_sort','prototype11_ar_effects'
)
foreach ($odcSuite in $odcSuites) {
  if ($odcSuite -eq 'prototype3') {
    & $odcGodot --path . --position 3000,2000 --script "res://tests/${odcSuite}_test.gd"
  } else {
    & $odcGodot --path . --script "res://tests/${odcSuite}_test.gd"
  }
  if ($LASTEXITCODE -ne 0) { throw "Failed: $odcSuite" }
}
git diff --check
```

Use rendered execution for mouse-input tests. Prototype 3's off-desktop position prevents the native pointer interfering with its existing viewport-input fixture. Confirm each suite reports PASS and no SCRIPT ERROR; an exit code alone is insufficient.

`python tests/cyber_catalog_test.py` independently re-exports the original read-only v12 database and compares the catalog and fingerprint. On a different computer, first obtain the exact approved database and arrange its existing expected path `C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db`; do not fabricate a substitute or change the catalog to satisfy this check. Godot learning validation itself works from committed JSON without that external file.

For artwork review, run at least the P11 suites plus import/startups, then perform full regression before requesting acceptance. Screenshots are written under Godot user data; keep generated review screenshots/logs outside Git. Historical reports under `Reports/` describe earlier intermediate states; the latest AR/Projectile/Explosion report and this accepted tag govern the current controls and effect timing.

## Safe contribution workflow

Start from the published feature branch with the handoff, inspect `git status`, then make a separate artwork branch:

```powershell
git fetch origin
git switch feature/prototype11-simplified-cyber-game
git status --short
git switch -c feature/prototype11-artwork-review
```

Use a new name if that branch already exists. Preserve any local work; do not reset, stash or overwrite it silently. Keep artwork changes separate from logic changes. Stage explicit reviewed paths, run `git diff --cached --check`, and provide before/after 1600 x 900 screenshots outside the repository. Submit the separate branch for owner review (a pull request can target the Prototype 11 feature branch); do not merge into main or move accepted tags. Only commit/push contributions under the owner's authorization. Explain any shared-asset impact on Prototype 10 before changing a shared texture or theme.

## Backup and handoff boundary

Independent accepted-source ZIP: `C:\Users\azwam\Projects\Backups\Orbital_Defense_Command_Prototype11_Accepted_2026-10-25_223430.zip`.
SHA-256: `f8ea7ece94e982951827be44676fb826bf7642bf78e6951767cea4768d0f6550`.

The ZIP also contains a verified portable Git history bundle for pre-checkpoint history and original uncommitted source. It excludes generated caches and the unchanged legacy executable. One extra EOF blank line in a P11 test was removed before staging, without changing assertions or executable content; the original is preserved in this backup. No gameplay or visual changes were made during checkpointing.

The next work should be original artwork and presentation proposals. Cybersecurity mechanics, scoring, deadlines, question bank and gameplay changes require separate approval.
