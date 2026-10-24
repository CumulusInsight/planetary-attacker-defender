# Prototype 4 Completion Report — Stationary Attack Information Panel

Status: Prototype 4 is accepted for checkpointing and publication. The user reviewed the stationary panel and hover-to-freeze behavior, accepted the tested 30% speed reduction for this checkpoint, and deferred further speed adjustments. Prototype 5 has not begun.

## Baseline and scope

Work was performed on `feature/prototype4-stationary-info-panel`, created from the accepted Prototype 3 tag `planetary-prototype3-json-attack-data-v1` at commit `85424c035801bb50f5f894614d53ca2512123dbc`.

The three pre-existing, untracked planning documents were preserved without editing: `Planetary_Attacker_Defender_Game_Design_Plan.md`, `Prototype_4_Implementation_Plan.md`, and `Programmer_Handoff_Guide.md` under `Reports/`. They are not new implementation files.

Information presentation, local hover freezing, deterministic mouse picking, and the final user-approved JSON speed adjustment were changed. Exactly three attackers, artwork, starting phases, orbit geometry, discrete inward jumps, DATA, and its `$1,000,000` display are preserved. The JSON schema and validation are unchanged; only the three `move_speed` values changed in the records. The Prototype 3 runner moves its simulated pointer away before asserting that selection alone allows all three attackers to move; its existing data and movement checks remain intact.

## Implemented behavior

- A stationary panel occupies `(1280, 64)` with size `300 × 772` in the existing 1600 × 900 playfield.
- Startup displays the exact text `Select an attacker`, without a default selection or invented attack values.
- Clicking an attacker displays its JSON abbreviation, attack ID, description, and numeric severity. Text updates on selection, not every movement frame.
- Clicking another transfers both exclusive highlight and fixed information. Selection alone never stops movement or pauses the scene tree.
- Hover on another attacker retains its existing local preview and signal without replacing the fixed selected record.
- Local previews now appear only during hover. Selecting an attacker does not keep its moving information panel open after pointer exit.
- Hover temporarily freezes only that attacker. Its angle, current ring, radius, accumulated orbit progress, and position stay unchanged while hovered. Exit resumes ordinary delta-time movement from that exact state, without spending frozen time or catching up. The two unhovered attackers keep moving normally.
- The invisible circular interaction radius increased from 40 to 48 pixels (20%). Artwork scale and the existing selection highlight are unchanged. The interaction circle continues to follow the existing selected-node scale.
- Overlapping circles resolve to one deterministic target. A hovered Area2D temporarily gains input priority, retaining ownership until pointer exit so passing attackers cannot steal its hover/click. Its priority resets on exit; this does not reorder the visible artwork. A click emits only one attack selection.
- Descriptions wrap within a 240-pixel-high ScrollContainer. Long descriptions scroll with the mouse wheel, and a new selection resets the previous scroll offset.
- An empty `FutureChoices` Control reserves layout space. It ignores input, has no children/buttons, and contains no defense logic.
- Invalid JSON retains the existing diagnostic and hidden/disabled attackers. The fixed panel displays `Attack information unavailable` without stale values. An unexpected selection ID produces a clear diagnostic, clears fixed details, and preserves the prior valid selection and running simulation.

No choices, defenses, correctness rules, questions/answers, weapons, shooting, scoring, damage, data-source changes, additional attackers, or other gameplay systems were introduced.

## Final speed adjustment

All three JSON orbital speeds were multiplied by 0.7, an exact 30% reduction. Relative speed ratios remain unchanged.

| Attack | Previous radians/second | Final radians/second | Approximate seconds/orbit |
| --- | --- | --- | --- |
| VM ESC | 0.70 | 0.49 | 12.82 |
| ROOTKIT | 0.90 | 0.63 | 9.97 |
| FILELESS | 1.10 | 0.77 | 8.16 |

This final refinement changes only `data/attacks.json`, the two regression runners' timing/expected-speed checks, and this report. All gameplay scripts, scenes, artwork, hover freezing/resume, hit areas, panel behavior, and unrelated work were preserved byte-for-byte from the beginning of the speed-adjustment task. No controller-side speed multiplier or schema change was introduced.

Both suites now derive orbital observation duration from the slowest loaded speed: two full orbits plus one second, approximately 26.65 seconds for 0.49 radians/second. Every existing full-orbit, two-jump, innermost-motion, selection, freeze/resume, and overlap assertion is retained. The near-orbit-boundary resume test now waits for the remaining 0.2 radians at the configured speed plus a 0.15-second margin; it still requires exactly one inward jump. Prototype 3 explicitly verifies the three approved speed values. The deliberately invalid string `"0.9"` in schema tests remains a type-error fixture, not an expected speed.

Restart a running game to load the new JSON values; data is loaded once on scene entry.

## Architecture

`game.gd` continues to load validated JSON before child initialization and to own exclusive selection. Its selection handler looks up the selected record by `attack_id` in validated `attack_records`, without assuming that IDs are sequential or match array indices. It passes that record to the panel's presentation-only `show_attack()` method.

`attack_info_panel.gd` manages labels and empty/unavailable states. It does not load JSON, choose identities, move attackers, or evaluate responses. It is instanced under a CanvasLayer, independently of attacker transforms. The panel uses the existing routed-gothic font and a restrained frame matching the orbit colors; no artwork was replaced.

Only the panel itself occupies an input-consuming rectangle. There is no full-screen Control overlay to intercept attacker clicks. Child labels and the future-choice container ignore mouse input; scrolling is confined to the description area.

`enemy.gd` returns from its movement update while hovered, without changing or accumulating any orbital state. The original delta-time orbit/ring calculations run normally when unhovered. Selection scaling and the reusable configuration/signals are retained. Hover entry/exit also manage local preview visibility and invisible Area2D input priority.

The controller enables sorted, first-object-only viewport picking while this scene is active and restores the viewport's previous settings when the scene exits. This prevents overlapping Areas from freezing multiple attackers or emitting multiple selection events for one click. It does not alter project settings or pause processing. See the official [Viewport picking documentation](https://docs.godotengine.org/en/stable/classes/class_viewport.html#class-viewport-property-physics-object-picking-first-only).

## Affected files

| File | Change |
| --- | --- |
| `scene/game.tscn` | Added HUD CanvasLayer and fixed-panel instance; existing gameplay nodes/transforms retained. |
| `data/attacks.json` | Final speed-only adjustment: VM ESC 0.49, ROOTKIT 0.63, FILELESS 0.77 radians/second. Other fields and schema unchanged. |
| `script/game.gd` | Initializes unavailable presentation, resolves selected records by ID, updates fixed information, diagnoses unknown IDs, and enables/restores deterministic single-target viewport picking. |
| `script/enemy.gd` | Hover-only local previews and movement freeze; exact orbital state retained, normal movement resumed on exit; temporary invisible input priority while hovered. |
| `scene/enemy.tscn` | Enlarged only the invisible CircleShape2D radius from 40 to 48 pixels; artwork, label, and scene transforms unchanged. |
| `scene/attack_info_panel.tscn` | New fixed layout, existing font theme, bounded description scroll, numeric severity, and empty future-choice area. |
| `script/attack_info_panel.gd` | New presentation methods for selected record, startup prompt, and unavailable state. |
| `script/attack_info_panel.gd.uid` | Godot-generated script UID. |
| `tests/prototype4_test.gd` | Panel and hover/freeze/resume regressions, exact orbital-state preservation, enlarged-hit-area, selection-only motion, and overlap checks. Uses a rendered, isolated SubViewport. Observation and near-boundary resume waits now derive from configured speeds. |
| `tests/prototype4_test.gd.uid` | Godot-generated test-script UID. |
| `tests/prototype3_test.gd` | Pointer exit distinguishes hover freeze from selection; explicitly verifies final speeds and derives a longer two-orbit observation. Existing assertions retained. |
| `Reports/Prototype_4_Completion_Report.md` | This implementation and review handoff. |

Unchanged: JSON validator/schema and all non-speed JSON fields, DATA scene, artwork/fonts, project settings, historical reports, pre-existing planning documents, and tracked standalone executable.

## Test environment and results

Godot: `4.7.2.stable.mono.official.ed1daf0bf`. Rendered tests: Vulkan / Forward+, NVIDIA GeForce RTX 2070. Tested viewport: 1600 × 900.

| Check | Result |
| --- | --- |
| Headless source startup | PASS; no startup script errors. |
| Godot headless editor import | PASS; new script UID files generated and retained. |
| Rendered Prototype 3 suite with final speeds | `PROTOTYPE 3 TEST: PASS (0 failures)`, exit code 0. Includes exact speed checks and extended observation. |
| Extended rendered Prototype 4 suite with final speeds | `PROTOTYPE 4 TEST: PASS (0 failures; 13047 checks)`, exit code 0. Check count varies with rendered frame rate. |
| Startup / all three selected-state captures | Inspected; fixed information readable, original orbit/artwork/DATA preserved. |
| Long-description capture | Inspected after scrolling; content clips within its scroll area and fixed panel retains bounds. |
| Hover interaction captures | Before/after hold, frozen-click selection, and resumed-motion captures inspected to confirm the held attacker stays fixed while the other two move and the panel retains selected data. |
| Native desktop interaction | The prior Computer Use check was blocked by application approval; rendered viewport input and captures were used. The user subsequently visually tested and approved hover behavior before requesting the final speed adjustment. No native desktop automation was retried for this data-only refinement. |
| Diff and preservation review | Orbital geometry, JSON/validator, DATA, artwork, settings, and pre-existing planning documents preserved; whitespace checks pass. |

The Prototype 3 suite intentionally prints two data-load errors. The Prototype 4 suite intentionally prints three diagnostics: unknown ID 9999, missing JSON, and invalid JSON syntax. These are tested failure paths, not unexpected failures.

### Coverage against approved acceptance criteria

| Criteria | Evidence |
| --- | --- |
| P4-01 / P4-02 | Exact startup prompt, no initial selected ID, and all required displayed fields compared against each JSON record after viewport clicks. |
| P4-03 | Panel bounds checked throughout the two-slowest-orbits-plus-one-second observation (now roughly 26.65 seconds); long text wraps, scrolls, and cannot enlarge the panel. |
| P4-04 / P4-05 | Exclusive highlighting and content transfer for all three; re-click and empty-space persistence; hovering a different attacker does not replace fixed information. |
| P4-06 | Both suites verify independent movement outside the intentionally hovered attacker. Full-orbit travel precedes each of all six inward jumps; inner motion continues during panel interaction. New hover checks verify only one local freeze, exact orbital-state preservation, no catch-up, and selection-only movement. This supersedes the original blanket movement wording as requested by the usability refinement. |
| P4-07 | Local hover visibility/signals retained; pointer exit hides the selected moving panel while fixed content persists. |
| P4-08 | Real viewport clicks reach every attacker. Fixed rectangle does not intersect DATA sprite, DATA/value labels, or orbital paths. Attacker sprite/label bounds remain outside it throughout observed motion. |
| P4-09 | Non-sequential IDs 42/7/900 verify ID lookup; unknown ID and missing/invalid JSON verify diagnostics, cleared details, fixed error bounds, and no fallback record. |
| P4-10 | Future-choice area is empty and non-interactive; no button nodes or excluded systems introduced. |
| P4-11 | Both suites pass; developer visual inspection completed. User accepted Prototype 4 for checkpointing and publication. |

### Additional hover usability coverage

- Hover each of the three attackers, hold for 0.35 seconds, and compare exact angle/ring/radius/progress/position snapshots. Other attackers must remain unhovered and advance.
- Exercise the enlarged 44-pixel annulus, click the frozen attacker, and verify correct exclusive selection and stationary JSON details without orbital movement.
- Move away; verify a small normal movement increment, preserved progress/ring, no catch-up, and continued motion despite remaining selected.
- Hold immediately before an orbit completes for 0.5 seconds; verify no jump while frozen, then completion of the remaining real travel and exactly one inward jump after exit.
- Place the existing three attackers in overlapping starting phases in a test fixture. Verify one stable hovered target, moving neighbours, one signal per click, and selection transfer through an exposed portion of another target's hit area. Move a later-drawn neighbour over the current owner and verify it cannot steal the freeze or click.
- Assert SceneTree remains unpaused throughout. No global pause is used by the implementation.

The suite's SubViewport isolates simulated input from the physical desktop pointer so sustained-hover checks cannot be cleared by unrelated native cursor coordinates. It still renders the real scene and uses Godot's GUI/physics picking and Area2D signals; the production scene has no added viewport or test input code. Initial harness failures exposed this pointer-state conflict and were corrected without weakening the freeze assertions.

### Reproduce

From the project root, replace the console executable path if needed:

```powershell
$godotExe = 'C:\Users\azwam\Projects\Godot_4.7\Godot_v4.7.2-stable_mono_win64\Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
```

Run suites sequentially. With the final slower speeds, Prototype 3 takes roughly 30 seconds and Prototype 4 roughly 35–45 seconds. Both exit with 0 on success. Prototype 4 writes/deletes its own `user://prototype4_test_fixture.json` without touching shipped data. It saves startup, selected-state, long-description, hover-hold before/after, frozen-click, and resumed-motion PNGs under `user://`, with the `prototype4_` prefix. On this workstation that directory is `%APPDATA%\Godot\app_userdata\planetary-attacker-defender`.

For user review, run normally or press F5. Hover an attacker and watch only that target stop, click it, then move onto the fixed panel: the selected attacker should resume while its information stays readable. Hover and click another to transfer selection. Try nearby attackers; the current hover target retains ownership until its interactive area is exited.

## Known limitations and design deviations

- The user-requested hover freeze intentionally supersedes the earlier requirement that every attacker move during hover. Selection alone still never stops motion. Optional speed/starting-ring metadata was omitted; the four requested JSON fields are shown.
- The supported layout remains the existing 1600 × 900 viewport. Responsive behavior and other platforms/resolutions were not added or verified.
- Short sample abbreviations and long descriptions were tested. Arbitrarily long identity strings are not a new supported content requirement; JSON text remains placeholder content.
- Attackers can still overlap visually. At initial overlap the frontmost pickable Area wins; once hovered, that target keeps input priority until exit. A fully occluded attacker cannot be clicked through the current hover owner's circle; move out and onto an exposed portion or allow separation. No cycling, collision avoidance, or new selection mechanic was added.
- Hover intentionally holds an attacker indefinitely while the pointer stays within its interaction area. Moving away resumes it; simply keeping it selected does not freeze it.
- Existing local preview positioning is retained. Depending on orbital position and selection scale, those temporary previews can cover orbital content or sit partly behind the fixed HUD. They ignore mouse input and close on exit; fixed selected information stays readable. Reworking preview layout was outside this refinement.
- Input and geometry were checked through runtime events, state/bounds assertions, and rendered visual captures. The separate native desktop check was blocked by application approval as described above. No claim of broader hardware or long-duration testing is made.
- No standalone export was rebuilt or tested. The existing executable remains unchanged and does not represent this working tree.

## Git and review handoff

Implementation branch: `feature/prototype4-stationary-info-panel`, based on accepted Prototype 3 commit `85424c035801bb50f5f894614d53ca2512123dbc`. The implementation was left uncommitted through the preceding visual-review stages. The user has now explicitly authorized a local commit, a normal merge into `main`, an annotated checkpoint tag, and publication to the existing GitHub origin.

- Source commit message: `Prototype 4: stationary attack panel and hover selection improvements`.
- Annotated tag on the final merged commit: `planetary-prototype4-stationary-panel-hover-freeze-v1`.
- Tag message: `Prototype 4 accepted: stationary information panel, hover freeze, and slower attacker speeds`.
- Origin: `https://github.com/CumulusInsight/planetary-attacker-defender.git`.
- Include the three unchanged planning documents in the checkpoint for programmer handoff. They describe the earlier baseline/proposal at their preparation time and do not supersede this accepted completion report.
- Verify the final checkpoint SHA with `git rev-parse planetary-prototype4-stationary-panel-hover-freeze-v1^{commit}`. The report is part of the checkpoint; its own final commit SHA is not embedded to avoid self-reference.
- Existing Prototype 2/3 tags and the executable must remain unchanged. No force-push, rebase, reset, or history rewriting is authorized.

No gameplay changes or speed adjustments were made during checkpoint preparation. The regression results above are from the already completed final-speed implementation; these suites were not rerun solely for Git publication. The final handoff verifies the merge, local/remote tag targets, included documents, and working-tree state. Stop after publication; do not begin Prototype 5.
