# Prototype 8 Git Checkpoint Report

Created: 2026-10-24T15:49:43-07:00 - America/Los_Angeles, Pacific Daylight Time, UTC offset -0700.

Full path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_8_Git_Checkpoint_Report_2026-10-24_154943_01.md`

## Repository, baseline and authorization

Repository: `C:\Users\azwam\Projects\planetary-attacker-defender`.
Origin: `https://github.com/CumulusInsight/planetary-attacker-defender.git`.
Branch: `feature/prototype8-orbital-intelligence`.
Starting HEAD/direct parent checkpoint: `4af29a9c2f73bcd0830b1dfea364138deb02f1f7` (accepted Prototype 7).
Owner accepted Prototype 8 and authorized one commit, one annotated tag and normal branch/tag publication. This assignment made no gameplay, scenario, scoring, interface, artwork or test-assertion changes.

Fetch succeeded. Local HEAD and origin's Prototype 7 branch agree; no unexpected divergence or unclear file ownership was found. Prototype 8 branch/tag are absent remotely and the proposed tag is absent locally. Local and remote main are `16dc097421e4f2b1159ab3f5095db408e115b11e`.

## Verified source manifest

These 19 files comprise the complete intended checkpoint, including this newly prepared report. Explicit staging only; no blind add-all operation:

- `Reports/Orbital_Defense_Command_Game_Concept.md`
- `Reports/Prototype_7_Git_Checkpoint_Report_2026-10-24_150305_01.md`
- `project.godot`
- `script/attack_info_panel.gd`
- `script/command_center.gd`
- `script/game.gd`
- `script/strategic_registry.gd`
- `Reports/Prototype_8_Completion_Report_2026-10-24_152158_01.md`
- `data/orbital_intelligence.json`
- `scene/orbital_command.tscn`
- `script/intelligence_data_loader.gd`
- `script/intelligence_data_loader.gd.uid`
- `script/intelligence_session.gd`
- `script/intelligence_session.gd.uid`
- `script/surveillance_contact.gd`
- `script/surveillance_contact.gd.uid`
- `tests/prototype8_test.gd`
- `tests/prototype8_test.gd.uid`
- `Reports/Prototype_8_Git_Checkpoint_Report_2026-10-24_154943_01.md`

The existing Prototype 7 checkpoint report's known local post-publication addendum was reviewed against Git references and preserved intact. Its verified SHA256 before staging is `9473f6a8be373baaa64bac0a45ac32b446054dede6815d6e03acb3784f92b28c`. The completed report is included, not silently excluded. Historical implementation/completion reports are preserved unchanged.

Protected files match the accepted Prototype 7 Git blobs: enemy movement/input, orbital deadline, encounter session, original attack/scenario/strategic JSON, mission JSON/loader/ledger/UI, existing tactical/enemy/console scenes, and every Prototype 3-7 regression script. Four new script/test UID files are included alongside their sources.

## Verification commands and actual results

Godot 4.7.2 stable Mono on Windows; rendered Vulkan Forward+ / NVIDIA GeForce RTX 2070. Suites use the documented rendered invocation for viewport mouse tests.

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --path . --script res://tests/prototype6_test.gd
& $godotExe --path . --script res://tests/prototype7_test.gd
& $godotExe --path . --script res://tests/prototype8_test.gd
& $godotExe --headless --editor --path . --quit
& $godotExe --headless --path . --quit-after 4
& $godotExe --headless --path . res://scene/game.tscn --quit-after 4
git diff --check
git fetch origin
git ls-remote origin refs/heads/main refs/heads/feature/prototype6-strategic-overview refs/heads/feature/prototype7-command-mission-scoring refs/heads/feature/prototype8-orbital-intelligence 'refs/tags/*'
```

| Verification | Actual result |
| --- | --- |
| Prototype 3 | PASS, 0 failures, exit 0 |
| Prototype 4 | PASS, 13,040 checks, 0 failures, exit 0 |
| Prototype 5 | PASS, 992 checks, 0 failures, exit 0 |
| Prototype 6 | PASS, 229 checks, 0 failures, exit 0 |
| Prototype 7 | PASS, 241 checks, 0 failures, exit 0 |
| Prototype 8 | PASS, 1,748 checks, 0 failures, exit 0 |
| Editor import | PASS, exit 0, no import/script errors |
| Project main and standalone tactical startup | Both exit 0, no startup/script errors |
| Whitespace check | PASS; normal CRLF-to-LF notices only |
| Reviewed candidate credential-pattern scan | Clear; explicit source/report manifest |

Expected missing/invalid-data diagnostics occurred in negative tests. All final suite assertions passed; no application code or accepted test assertion was changed to achieve this result. Prototype 4 check totals vary with sampled frame count.

F5's configured entry is `res://scene/orbital_command.tscn`. It inherits the accepted reusable command center and enables the eighteen-contact extension. Prototype 8 integration verified three centers with six contacts each, eighteen unique IDs, exactly three active deadlines/scoring participants, deterministic ellipse configuration/bounds, hover/click including overlapping hit areas, no catch-up, source validation/delivery, revision/history, false positive/negative and confidently incorrect assessments, public/private separation, strategic pause/Challenge/offscreen delivery, passive command rejection, navigation and official replay isolation. The standalone tactical scene retains its accepted three-contact scope.

Rendered suites exercised input and produced their existing review captures outside the repository under `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`. This checkpoint does not claim a new native manual GUI review; owner acceptance and the prior completion report document visual review.

## Excluded files and limitations

No unrelated changed/untracked files were found in the starting 18-file manifest. Generated screenshots, user-data validation fixtures, ignored `.godot` caches, executables/build outputs, credentials and the external temporary manifest are excluded. Existing tracked executables remain unchanged. No screenshot or cache is added to the checkpoint.

Accepted limitations remain: visual rather than gravitational ellipses, authored local finite reports, advisory-only passive responses, scrollable long histories, fixed 1600 x 900 layout, static demonstration staffing, in-memory histories/scoring, evidence-limited unassessed mission categories, and no database, external learning-provider integration or automatic truth disclosure. Directly launching the baseline command-center scene retains nine contacts for legacy tests; normal F5 launches eighteen. Background movement continues during strategic pause while intelligence delivery excludes that paused movement, as documented and tested.

## Preserved references recorded before publication

```text
4dccf04644a213932570923f655ea745407d8cba	refs/heads/feature/prototype6-strategic-overview
4af29a9c2f73bcd0830b1dfea364138deb02f1f7	refs/heads/feature/prototype7-command-mission-scoring
16dc097421e4f2b1159ab3f5095db408e115b11e	refs/heads/main
0c17496e620fdf2a326a520ee27ed66d15a9d47a	refs/tags/planetary-prototype2-data-driven-attackers-v1
c9e0bfd93884dfc0c63a9e54655ced2b758db649	refs/tags/planetary-prototype2-data-driven-attackers-v1^{}
8c9295c1c3bb0d921791b92dc7c799dcdd6f03b4	refs/tags/planetary-prototype3-json-attack-data-v1
85424c035801bb50f5f894614d53ca2512123dbc	refs/tags/planetary-prototype3-json-attack-data-v1^{}
26fb021dcc78fd64ab398d7d767a24e0b3ea539a	refs/tags/planetary-prototype4-stationary-panel-hover-freeze-v1
16dc097421e4f2b1159ab3f5095db408e115b11e	refs/tags/planetary-prototype4-stationary-panel-hover-freeze-v1^{}
8794458b611a426ffc43226ce4f468c8853398d0	refs/tags/planetary-prototype6-strategic-command-v1
4dccf04644a213932570923f655ea745407d8cba	refs/tags/planetary-prototype6-strategic-command-v1^{}
590661bd4d8857eb98f831aaaa262679873b5208	refs/tags/planetary-prototype7-command-scoring-v1
4af29a9c2f73bcd0830b1dfea364138deb02f1f7	refs/tags/planetary-prototype7-command-scoring-v1^{}
```

All listed annotated tag objects and peeled targets agree locally and remotely. Main and the Prototype 6/7 remote branches must remain unchanged during publication.

## Planned Git identifiers

One commit message: `Checkpoint: Prototype 8 elliptical traffic and fallible intelligence`.
One new annotated tag: `planetary-prototype8-orbital-intelligence-v1`, pointing to that new commit.
Normal push of `feature/prototype8-orbital-intelligence` and only this new tag; atomic push if supported. No main merge/push, force-push, deletion, amend or history rewrite.

The new commit SHA does not exist yet and is intentionally not invented here. Actual commit/tag/remote verification will be appended locally after publication, without amending or adding another commit solely to record its own SHA.
