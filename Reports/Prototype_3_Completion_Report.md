# Prototype 3 Completion Report

## Scope and implemented features

Prototype 3 replaces the controller's embedded sample attack dictionaries with a simple local JSON dataset. It adds loading, validation, and explicit failure diagnostics while preserving the accepted Prototype 2 gameplay and presentation.

- `data/attacks.json` contains exactly three records: VM ESC, ROOTKIT, and FILELESS.
- Every record supplies `attack_id`, `abbreviation`, `description`, `severity`, `move_speed`, and `start_ring`.
- The controller loads and validates the complete dataset before passing any properties to the existing attackers.
- Hover panels display JSON-supplied descriptions and identities.
- Independent orbital motion, full-orbit counting, discrete inward jumps, selection highlighting, and selection transfer remain unchanged.
- The central DATA target and its `$1,000,000` display remain unchanged.
- No SQLite, databases, API connections, questions, answers, weapons, shooting, scoring, levels, additional attackers, or other gameplay features were added. Prototype 4 has not begun.

## Files changed

| File | Change |
| --- | --- |
| `data/attacks.json` | New local array of three sample attack objects, carrying the same identities, placeholder descriptions, severities, speeds, and starting rings as Prototype 2. |
| `script/attack_data_loader.gd` | New dedicated loader that reads JSON, validates the full dataset, normalizes numeric fields, and returns either records or an actionable error with no partial records. |
| `script/attack_data_loader.gd.uid` | Godot-generated UID for the loader script. |
| `script/game.gd` | Replaced embedded sample dictionaries with a loader call and configurable local JSON path. Preserved existing signal connections, selection coordination, and orbit drawing. On failure, logs the diagnostic and hides/disables the attacker container. |
| `tests/prototype3_test.gd` | Reproducible Godot test runner covering malformed input, controller failure handling, alternate valid data, hover/click interaction, continuous movement, and full-orbit inward progression. |
| `tests/prototype3_test.gd.uid` | Godot-generated UID for the test script. |
| `Reports/Prototype_3_Completion_Report.md` | This implementation and handoff report. |

No changes were made to `script/enemy.gd`, any existing scene, existing artwork, project settings, or the tracked standalone executable. The Prototype 2 report remains unchanged.

## JSON data and validation contract

| ID | Abbreviation | Description | Severity | Speed (radians/second) | Starting ring |
| --- | --- | --- | --- | --- | --- |
| 1 | VM ESC | Placeholder: virtual machine escape. | 1 | 0.7 | 2 |
| 2 | ROOTKIT | Placeholder: concealed system access. | 2 | 0.9 | 2 |
| 3 | FILELESS | Placeholder: memory-based activity. | 3 | 1.1 | 2 |

The JSON root must be an array. The controller requires one record for each of the existing three attacker instances. Every record must be an object with all six required fields:

- `attack_id`: unique non-negative 32-bit integer.
- `abbreviation` and `description`: strings containing non-whitespace text.
- `severity`: non-negative 32-bit integer; display metadata only.
- `move_speed`: finite positive number.
- `start_ring`: integer 0, 1, or 2, corresponding to inner, middle, or outer ring.

JSON numeric values are explicitly normalized to the attacker's integer/float interface after validation. Numeric strings, booleans, nulls, and fractional integer fields are rejected. Additional object fields are ignored and are never assigned to attacker properties.

## Architecture and failure behavior

`game.gd` owns initialization and coordination. Its exported `attack_data_path` defaults to `res://data/attacks.json`. During `_enter_tree()`, before attacker `_ready()` callbacks, it calls the dedicated `RefCounted` loader. The loader uses Godot's local `FileAccess` and `JSON` parser; it returns a dictionary containing validated `records` and an `error` string.

All records must pass before any attacker receives configuration. Record order maps to the three existing scene children. On failure, the controller retains an empty configured-record list, emits `push_error()`, and hides/disables the attacker container. The DATA target and orbit paths remain visible. There is no fallback to hard-coded or unrelated identities, no partial attacker population, and no new error-dialog interface.

Diagnostics identify the source path and the failure reason; syntax failures include a line number, and record-validation failures identify the one-based record number and relevant field. Examples:

```text
Attack data 'user://prototype3_nonexistent/attacks.json': cannot open file (File not found). No attackers configured.
Attack data 'user://prototype3_validation_fixture.json': record 1 is missing required field 'abbreviation'. No attackers configured.
```

Attacker objects do not read files, parse JSON, or know their data source. Their six exported properties and `attacker_selected(attack_id)` / `attacker_hovered(attack_id)` signals are unchanged, preserving reuse with a future approved data source. Selection remains controller-owned and never pauses the scene tree.

## Testing and results

Environment: Godot `4.7.2.stable.mono.official.ed1daf0bf`, configured Godot 4.7 / Forward Plus; rendered test used Vulkan with an NVIDIA GeForce RTX 2070.

Completed checks:

1. Headless project startup: successful, without script or data-loading errors.
2. Headless editor import and script registration: successful; generated loader/test UID files were retained.
3. Rendered runtime regression suite: **`PROTOTYPE 3 TEST: PASS (0 failures)`**, exit code 0.
4. Valid local JSON: exactly three records load; all six values reach each attacker, correct abbreviations appear on labels, and JSON descriptions appear in information panels on hover.
5. Alternate valid JSON fixture: changing an ID, description, and starting ring changes the configured attacker, confirming the dataset is the source of truth.
6. Viewport mouse events: each attacker emits hover/selection signals; clicking transfers exclusive selection and all attackers continue moving while selected.
7. Roughly 19 seconds of frame-driven orbital observation: each attacker travels a complete orbit before each inward jump, moves one ring at a time, remains on one of the three radii, and continues moving at the inner ring.
8. Invalid-data cases: missing file, syntax error, wrong root type, wrong record count, non-object record, every required field missing, empty/wrong-type text, null/boolean/string/fractional/negative/out-of-range integer fields, invalid speed, out-of-range ring, and duplicate attack ID all produce clear diagnostics and no partial records.
9. Controller integration with missing and malformed JSON: intentionally logs two expected error diagnostics; the container stays hidden and disabled. These expected diagnostics are not test failures.
10. Rendered viewport capture: inspected for preserved artwork, paths, information panel, and DATA value. The DATA value is also checked by the test runner.
11. Git whitespace checks and scope review: completed before checkpointing. Existing attacker movement/input code and all scenes are unchanged from the accepted Prototype 2 checkpoint.

The test runner is checked in and can be invoked from the project root:

```powershell
& '<path-to-Godot-console.exe>' --path . --script res://tests/prototype3_test.gd
```

Run the rendered version above for the same interaction checks used in validation. It takes approximately 20 seconds, creates and removes its own `user://` JSON fixture, and saves `user://prototype3_test_viewport.png` for inspection. It intentionally prints two controller error diagnostics while verifying failure handling, then reports PASS/FAIL and exits accordingly. Tests never alter the shipped JSON dataset.

## Known limitations

- Sample descriptions and severity values remain placeholders; no cybersecurity decisions are implemented.
- Data is loaded once on scene entry; there is no live reload or runtime editing interface.
- The dataset count is tied to the existing three scene children, and array order determines the target instance. No attacker spawning or additional attacker support was added.
- Errors are available through the Godot debugger/console; no in-game diagnostic overlay was requested or added.
- Parsing follows Godot's JSON parser behavior; this is application schema validation, not a separate strict JSON-standard conformance layer.
- Existing Prototype 2 limitations remain, including a fixed 1600 by 900 layout and possible visual overlap during orbital motion.
- The tracked standalone executable was not rebuilt. Validation covered the Godot source on the current machine; packaged export and other platforms/resolutions remain unverified.

## Recommended next steps

1. Review and accept Prototype 3 before defining any Prototype 4 work.
2. Continue using the checked-in regression runner when changing content or initialization.
3. If distribution is later requested, verify packaged JSON inclusion and run an exported-build smoke test.
4. Agree on any future data/schema changes explicitly while preserving the reusable attacker interface and controller-owned selection.

These are recommendations only; no subsequent prototype work has been started.

## Local Git checkpoint

- Repository: `C:/Users/azwam/Projects/planetary-attacker-defender`
- Branch: `main`
- Parent checkpoint: `c9e0bfd93884dfc0c63a9e54655ced2b758db649`.
- Starting working tree: clean; no unrelated staged or uncommitted changes were present.
- Commit message: `Prototype 3: JSON-driven cybersecurity attack data`
- Annotated tag: `planetary-prototype3-json-attack-data-v1`
- Scope: only the seven Prototype 3 files listed above.
- This report is part of the checkpoint commit. Resolve its final SHA using `git rev-parse planetary-prototype3-json-attack-data-v1^{commit}`; embedding that commit's own SHA in its content would be self-referential.
- Commit and annotated-tag targets are verified after creation, and final Git status is reported in the handoff.
- Local checkpoint only: no push, merge, rebase, reset, or force-push.
