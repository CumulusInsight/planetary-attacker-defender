# Prototype 4 Implementation Plan — Stationary Attack Information Panel

Status: proposed specification for user review. This document does not authorize implementation. No Prototype 4 code or scenes were created during this planning task.

## Objective and scope

Clicking an attacker should show its validated JSON information in a fixed panel, readable while all three attackers continue moving. Clicking another should transfer the existing highlight and replace the fixed content with that attack's information.

Reserve layout space for future defensive choices, but do not implement defense decisions, functioning choice buttons, correctness rules, questions/answers, shooting, scoring, damage, databases, connections, additional attackers, or other gameplay. Do not rebuild the executable unless separately requested.

Preserve speeds, radii, angular offsets, complete-orbit counting, discrete inward jumps, innermost motion, DATA artwork, and `$1,000,000`. Never pause the scene tree for reading.

## Baseline and proposed behavior

| Situation | Accepted Prototype 3 | Proposed Prototype 4 |
| --- | --- | --- |
| Startup | No selection; moving panels appear on hover. | Fixed panel shows `Select an attacker`, without invented attack values. |
| Attacker clicked | Highlight and persistent moving information panel. | Same highlight; fixed panel shows that ID's JSON record. Suppress persistent selected information on the moving attacker to avoid duplicate detail panels. |
| Another attacker hovered | Its moving panel appears. | Preserve short local hover information; do not replace fixed selected content. Hover is not selection. |
| Pointer leaves selected attacker | Moving panel remains visible. | Fixed content persists; local hover information may close. Motion continues. |
| Another attacker clicked | Exclusive selection transfers. | Selection and fixed content transfer together, keyed by ID. |
| Selected attacker re-clicked / empty space clicked | Selection remains. | Preserve selected information; no new toggle or deselection. |
| Invalid JSON | Diagnostic; attacker container hidden/disabled. | Preserve handling and show a neutral unavailable state instead of stale information. No fallback identity. |

This selected-versus-hover policy is a recommendation requiring approval with the layout. It preserves hover information while moving persistent selected details into the fixed panel.

## Proposed UI layout

Keep the existing 1600 by 900 playfield and DATA at `(800, 450)`. Add a `CanvasLayer` HUD with a `PanelContainer` in the right-hand strip. Do not shrink, move, or rescale the orbital system.

Proposed bounds: x = 1280, y = 64, width = 300, height = 772. The outer path reaches x = 1200; the enlarged selected hit area reaches approximately x = 1260 at the rightmost point. Verify the proposed 20-pixel gap against actual sprites and fonts. Other viewport sizes are not automatically included.

Content order:

1. Heading: `Selected attack`.
2. JSON abbreviation and attack ID.
3. Wrapped JSON description in a bounded ScrollContainer.
4. Severity as its numeric JSON value, without invented risk categories.
5. Optional metadata: `move_speed` in radians/second and `start_ring`, labelled 0 inner / 1 middle / 2 outer. Starting ring must not be mistaken for current position.
6. An empty, non-interactive layout container for future choices. No sample choice text, enabled buttons, or evaluator in Prototype 4.

Use existing fonts/colors where practical. The full-screen HUD root must ignore input outside the panel. Labels ignore input; the scroll area may consume input inside its bounds. No invisible full-screen Control may block attacker input. Panel position must remain fixed through movement, inward jumps, and selection changes.

## Proposed architecture and flow

1. Keep JSON loading/validation in `attack_data_loader.gd` and preserve the six-field attacker interface.
2. Keep `selected_attack_id` and exclusive highlighting in `game.gd`.
3. On `attacker_selected(attack_id)`, resolve the validated record by ID from `attack_records`. Do not assume ID equals array index or derive identity from node names.
4. Pass a presentation-only record to a method such as `show_attack(record)`. The panel displays data; it never loads JSON, evaluates defenses, or moves attackers.
5. Update text on selection, not every frame. Data is static for the scene session.
6. For an unknown ID, report the ID and clear stale panel details without pausing movement or substituting the first record. This defensive check must not silently change the existing selection contract.
7. Make only the local presentation adjustment needed for the approved selected-versus-hover policy. Preserve the existing hover signal and local information, and keep `set_selected()` responsible for highlighting.

An ID-to-record dictionary is optional for three entries. Reserving choice space does not justify evaluator stubs, response schemas, or new service abstractions.

## Expected affected files — proposed only

| File | Planned change |
| --- | --- |
| `scene/game.tscn` | Instance a fixed panel under a CanvasLayer, preserving gameplay nodes/transforms. |
| `script/game.gd` | Initialize empty/error presentation and update fixed details by selected ID; preserve loading and exclusive selection. |
| `scene/attack_info_panel.tscn` (suggested new name) | Panel layout, scrollable description, metadata, empty choice container. |
| `script/attack_info_panel.gd` (suggested new name) | Record/empty/unavailable display methods only; retain generated UID. |
| `script/enemy.gd` | Minimal presentation change if needed to stop selected moving details persisting; preserve local hover, highlight, movement, and properties. |
| `tests/prototype3_test.gd` | Retain all coverage; adjust only UI expectations actually superseded by approved presentation. Never weaken data/movement assertions. |
| `tests/prototype4_test.gd` (suggested new name) | Fixed-panel interaction/layout regressions; retain generated UID. |
| `Reports/Prototype_4_Completion_Report.md` (later) | Actual changes, results, limitations, and review status after implementation. |

No planned changes to JSON, its loader, DATA scene, artwork, settings, accepted tags, or historical completion reports. Other changes need a reason and scope review.

## Acceptance criteria

| ID | Criterion |
| --- | --- |
| P4-01 | Startup shows exactly three moving configured attackers and a fixed neutral prompt, with no default selection. |
| P4-02 | Clicking each displays its exact JSON ID, abbreviation, description, and severity; optional metadata has correct values/units. |
| P4-03 | Panel screen position/size stay unchanged through selected-attacker rotation and inward jumps. Long descriptions wrap and scroll within bounds. |
| P4-04 | Selection transfers across all three: old highlight clears, new highlight appears, panel matches the new ID. |
| P4-05 | Re-click, pointer exit, hover on another attacker, and empty-space click do not silently clear or replace fixed selected data. |
| P4-06 | All attackers move during selection and panel interaction. Each completes an orbit before each jump, advances one ring, and continues at ring 0 with unchanged speeds/radii. |
| P4-07 | Hover emits the correct ID and shows approved local information. It does not change fixed selection. No persistent moving selected detail duplicates the fixed panel. |
| P4-08 | HUD does not block attacker input or cover DATA, its value, orbital paths, or attacker sprites at the existing viewport. |
| P4-09 | Missing/invalid JSON retains clear diagnostics and hidden/disabled attackers, without stale details or actionable controls. Unknown IDs produce diagnostics without fallback identities or pause. |
| P4-10 | Choice extension area is non-interactive; no decisions, shooting, scoring, damage, data-source migration, or new gameplay exists. |
| P4-11 | Existing data/movement tests and new panel tests pass; user visually reviews the result before the next milestone. |

## Regression and manual tests

- Run the existing rendered suite with the installed console executable: `godot --path . --script res://tests/prototype3_test.gd`. Expected final result is `PROTOTYPE 3 TEST: PASS (0 failures)`; two deliberate invalid-data diagnostics are expected.
- Add a rendered Prototype 4 suite that clicks every attacker through viewport input, checks one selected ID/highlight, and compares panel fields with the selected JSON record.
- Record fixed panel bounds. Observe at least two slow-attacker orbits (roughly 18 seconds, with margin), confirming unchanged bounds, all six inward jumps, full revolutions before jumps, and continued inner motion.
- Hover B while A is selected: check B's hover interface and A's unchanged fixed content. Re-click A and click empty space to verify persistence.
- Use separate temporary fixtures for long descriptions, non-sequential IDs, and malformed JSON; never edit shipped data for a test. Verify ID lookup and neutral/error states without substitutions.
- Check scrolling, label input, panel boundaries, rightmost enlarged-attacker clearance, and absence of a full-screen input blocker.
- Visually inspect all three selections at 1600 by 900 near orbital extremities and with long text. Verify DATA and its value remain unchanged.
- Review the diff: movement functions, JSON contract, speeds, artwork, and project settings must not change to accommodate the panel.

These are planned tests, not new results. This documentation task did not run or alter gameplay.

## Review gate and implementation sequence

Approve placement, fields, hover policy, unavailable-state wording, and viewport scope first. Then work on a separate feature branch: add the panel, connect selected data, adjust only approved local presentation, add regressions, and submit a small reviewable change with evidence. Commit/tag/publication policy requires separate authorization. Do not move accepted tags or merge into `main` without approval.

## Related documents

[Game design plan](Planetary_Attacker_Defender_Game_Design_Plan.md) · [Programmer handoff](Programmer_Handoff_Guide.md) · [Prototype 3 completion](Prototype_3_Completion_Report.md)
