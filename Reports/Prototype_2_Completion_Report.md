# Prototype 2 Completion Report

## Acceptance and scope

The user visually reviewed and accepted Prototype 2 before requesting this local Git checkpoint. No further movement or selection changes were requested or made during checkpoint preparation. Prototype 3 has not begun.

The objective was to test continuous motion, urgency, visual tracking, and interaction using one fixed DATA target, three concentric orbital paths, and exactly three attackers. The existing project, artwork, scene instances, and discrete inward-jump concept were retained.

## Implemented features

- Three independent attackers with slow, medium, and fast orbital speeds.
- Three visible concentric paths with radii 160, 280, and 400 pixels.
- A complete orbit triggers an immediate inward jump by one ring; attackers continue orbiting indefinitely on the innermost path.
- Clicking highlights one attacker by enlarging it. Clicking another transfers selection; the previous attacker returns to normal scale.
- All attackers keep moving during selection. No scene-tree pause is used.
- Hover displays externally supplied placeholder information; selected attackers retain their information panel after hover ends.
- Typed `attacker_selected(attack_id)` and `attacker_hovered(attack_id)` signals.
- Fixed central DATA target with a display-only `$1,000,000` value.

## Files and changes

| File | Prototype 2 changes |
| --- | --- |
| `script/enemy.gd` | Added six exported configuration properties and selection/hover signals. Replaced sibling-dependent movement gating with independent full-orbit progress and discrete ring transitions. Removed hard-coded attack names, static shared selection, and pause/resume logic. Kept responsibility limited to movement, visual presentation, and input. Added hover presentation, selection scaling, and panel positioning within the playfield. |
| `script/game.gd` | Added the main controller. Supplies sample configuration before child `_ready()` callbacks, connects attacker signals, owns exclusive selection and the last hovered ID, and draws the three orbital paths. |
| `script/game.gd.uid` | Godot-generated UID for the new controller script. The existing `enemy.gd.uid` is retained unchanged. |
| `scene/game.tscn` | Attached the controller to the existing main scene. Preserved exactly three attacker instances, their textures, and angular offsets. Removed obsolete scene speed/radius overrides in favor of controller configuration. Replaced the second attacker's direct imported-cache texture dependency with its source texture resource. |
| `scene/enemy.tscn` | Connected mouse-entered and mouse-exited signals, removed the Area2D's always-processing override, enabled description wrapping, widened the information panel, and made informational Controls ignore mouse input. Replaced the default direct imported-cache texture dependency with the source texture resource. |
| `scene/datacenter.tscn` | Preserved the original DATA sprite and label; added the placeholder value label. |
| `Reports/Prototype_2_Completion_Report.md` | Records scope, implementation, validation, limitations, and checkpoint details. |

## Configuration and architecture

The controller's `SAMPLE_ATTACKERS` dictionaries supply all six required properties to the existing scene instances in `_enter_tree()`. The attacker does not choose its own attack identity or coordinate with siblings.

| ID | Abbreviation | Placeholder description | Severity | Speed (radians/second) | Starting ring |
| --- | --- | --- | --- | --- | --- |
| 1 | VM ESC | Placeholder: virtual machine escape. | 1 | 0.7 | 2 |
| 2 | ROOTKIT | Placeholder: concealed system access. | 2 | 0.9 | 2 |
| 3 | FILELESS | Placeholder: memory-based activity. | 3 | 1.1 | 2 |

Ring indices are 0 for inner, 1 for middle, and 2 for outer. All sample attackers begin on the outer ring with distinct existing angular offsets. Each attacker accepts `attack_id`, `abbreviation`, `description`, `severity`, `move_speed`, and `start_ring` as exported properties. Severity is displayed sample metadata, without decision logic.

Configuration is data-driven within the controller; it is not backed by a database or external service. The controller maps the three sample dictionaries to scene children by order and coordinates selection by unique attack ID.

## Movement and interaction

Movement uses delta time and preserves each configured angular speed on every ring. Full-orbit progress is measured independently from the initial angular offset, so crossing angle zero alone does not cause an early first jump. Radius changes directly from 400 to 280 to 160 pixels, without interpolation or a spiral. Attackers neither wait for nor signal one another to advance.

Left-click input emits an attack ID. The controller calls `set_selected()` on each attacker, leaving exactly one enlarged. Repeated clicks on the selected attacker leave it selected. Hover emits the attack ID and opens its information panel; mouse exit closes the panel unless that attacker remains selected. Information panels ignore mouse input so they do not block attacker interaction.

## Godot version and validation

- Project feature declaration: Godot 4.7, Forward Plus.
- Tested executable: `4.7.2.stable.mono.official.ed1daf0bf`.
- Rendered test: Vulkan / Forward+, NVIDIA GeForce RTX 2070.
- Godot headless source startup completed without script errors.
- Final rendered automated runtime test result: `PROTOTYPE 2 TEST: PASS (0 failures)`.
- Automated runtime checks exercised viewport mouse clicks and hover signals for all three attackers, exclusive selection transfer, absence of pause, and continued movement of every attacker during selection.
- The test checked every required configuration property against the controller's sample data, observed both inward jumps for each attacker during a roughly 19-second observation, checked ring radii throughout, and verified continued movement at the innermost ring and the DATA value label.
- Hover-panel visibility was checked when the hover signal fired: native mouse updates can end a synthetic hover before a later frame assertion. External placeholder text was also checked.
- The rendered viewport was visually inspected for the existing artwork, orbital paths, DATA value, and information panel. The user subsequently visually reviewed and accepted the implementation.
- `git diff --check` passed during implementation and checkpoint review.

The automated test script and captured viewport were temporary local validation artifacts outside the repository; they are not part of this checkpoint. The checkpoint does not claim broader platform, resolution, or long-duration testing. No gameplay tests were rerun solely for this documentation and Git operation.

## Known limitations and unfinished work

- No outstanding implementation work remains within the accepted Prototype 2 scope.
- Coordinates and panel bounds target the existing 1600 by 900 playfield; responsive layout and other viewport sizes are unverified.
- Sample IDs, configuration completeness, and scene-child order are trusted; there is no general-purpose content validation or dynamic population system.
- Attackers can overlap as they orbit; this prototype has no collision avoidance or label decluttering.
- The controller records the last hovered ID; it does not provide a separate hover-cleared interface.
- Descriptions, severity values, and the DATA value are placeholders. The target has no financial calculation, damage, or loss behavior.
- The tracked `new_projectV2/new_project_v2.exe` is unchanged and was not rebuilt. Run the Godot source to review this checkpoint; that existing export is not evidence of the current implementation.
- No databases, questions, answers, weapons, shooting, scoring, levels, advertisements, extra attackers, or cybersecurity decision systems were introduced.

## Recommendations for Prototype 3

Recommendations only; none are authorization or implementation:

1. Review whether observed speeds, ring spacing, overlap, and selection readability adequately test tracking and urgency before defining further scope.
2. Agree on explicit Prototype 3 objectives and acceptance tests with the user before adding gameplay systems.
3. Consider reproducible checked-in interaction tests, configuration validation, and viewport-size checks if the next approved scope requires them.
4. Preserve controller-owned configuration and coordination, and keep attacker objects focused on movement, display, and input.

## Git checkpoint

- Repository: `C:/Users/azwam/Projects/planetary-attacker-defender`
- Branch: `main`
- Parent commit: `c4f269f7ca86a5bdae22221674113a5d6acba3d6` (`first commit`).
- Initial checkpoint status: four modified Prototype 2 source files and two untracked controller files; no pre-existing staged changes or unrelated working-tree changes were found.
- Commit message: `Prototype 2: Data-driven attackers and continuous selection`
- Annotated tag: `planetary-prototype2-data-driven-attackers-v1`
- Staging scope: the six Godot source/UID files listed above plus this report. Existing assets, engine caches, project settings, and the exported executable are excluded.
- This report is included in the checkpoint commit. Its final SHA is resolved by the annotated tag rather than embedded here, avoiding a self-referential commit hash. After checkpoint creation, use `git rev-parse planetary-prototype2-data-driven-attackers-v1^{commit}` and `git show --no-patch planetary-prototype2-data-driven-attackers-v1` to inspect it.
- The commit and tag are local only. No push, merge, rebase, reset, or force-push is part of this handoff. No Prototype 3 implementation is included.
