# Planetary Attacker/Defender — Game Design Plan

Status: proposal for user review. Prototypes 1–3 are accepted. All future mechanics described here require approval before implementation. This document does not authorize starting Prototype 4.

## 1. Concept and educational objective

The intended game is a visual cybersecurity learning exercise. Three attackers orbit a valuable DATA asset and advance inward, creating urgency. The player acts as a defender: observe threats, select an attacker, read its context, and eventually choose a reasoned defensive response.

The proposed educational objective is to practice recognizing attack characteristics and connecting them to an appropriate defensive approach. Future explanations should communicate why a response fits a particular scenario and its limitations. An abbreviation alone should not imply a universal correct answer. Audience, prerequisite knowledge, and learning assessment remain undecided.

Currently the project tests motion, tracking, interaction, and data loading. No defensive decision, correctness assessment, attack resolution, or learning assessment exists. Descriptions and severity values are placeholders, not a reviewed cybersecurity curriculum.

## 2. Implemented functionality: Prototypes 1–3

The user reports Prototypes 1–3 complete. Current source and completion reports establish the following baseline. A separate detailed Prototype 1 report or checkpoint was not identified during this review.

| Milestone | Implemented and accepted |
| --- | --- |
| Prototype 1 | Original circular movement foundation, retained and developed by later prototypes. Further historical details are not independently reconstructed here. |
| Prototype 2 | Exactly three attackers; independent slow/medium/fast motion; three drawn paths; discrete inward jumps after full orbits; continuous movement during exclusive selection; selection transfer; hover information; controller-owned configuration; fixed DATA target and `$1,000,000` label. |
| Prototype 3 | Configuration moved into local JSON, validated by a dedicated loader and passed through the reusable attacker interface. Invalid data produces clear diagnostics without substitute identities. |

Current sample attacks are VM ESC (ID 1, 0.7 radians/second), ROOTKIT (ID 2, 0.9), and FILELESS (ID 3, 1.1). All start on ring 2. Ring indices 2, 1, and 0 have radii 400, 280, and 160 pixels, centered at `(800, 450)` in a 1600 by 900 playfield. Each full revolution advances an attacker one ring inward. At ring 0 it orbits indefinitely. Travel is counted from its starting angle; merely crossing angle zero cannot trigger an early first jump.

Clicking enlarges one attacker to 1.5 times normal scale. Clicking another restores the previous attacker and highlights the new one. All three continue moving. Current information panels move with their attackers and remain visible while hovered or selected. No stationary panel exists yet.

There are no questions/answers, weapons, shooting, scoring, damage, levels, databases, server connections, or win/loss conditions. The monetary label is presentation only.

## 3. Intended experience and gameplay loop — proposed

The intended experience combines visual tracking with deliberate decisions. Motion provides pressure; a stable information area should make text readable without chasing an attacker. Selection must not pause simulation or imply successful defense.

1. Observe the three threats and their proximity to DATA.
2. Select one without interrupting movement.
3. Read its identity and scenario context in a fixed information panel.
4. Review contextual defensive choices, once separately approved.
5. Choose a response and receive an explanation of its relevance and limitations.
6. Observe an approved visual outcome and return attention to remaining threats.
7. Review a learning summary when an encounter/session ends, if an ending is approved.

Only steps 1–2 and moving information panels exist now. Step 3 is proposed Prototype 4. Steps 4–7 are future proposals. Timers, retries, consequences, and encounter endings remain open. Current inward motion is not a functional deadline.

## 4. Roles and visual meaning

| Element | Current role | Proposed future role |
| --- | --- | --- |
| Attacker objects | Display identity/artwork, move independently, count ring progress, emit click/hover IDs, and present selection/hover state. | Remain visual encounter representations; consume presentation commands without deciding defense correctness. |
| Defender/player | Observes, selects, and reads placeholders. No defender avatar or action system exists. | Makes responses through the fixed panel; shooting is not assumed. |
| Orbital paths | Geometric tracks and progression markers, without functional security controls. | Metaphor for protective layers or increasing proximity to DATA. Layer names and actual rules require approval. |
| DATA | Fixed central visual with a `$1,000,000` label. | Represents information worth protecting. Compromise behavior, damage, and monetary calculations are undecided. |
| Controller | Initializes validated data, connects input, coordinates selection, and draws rings. | Updates the panel and routes future response events between separate components. |

Ring transitions intentionally remain discrete. Ring position and severity are different: position indicates visual progression; severity is currently independent display metadata. Do not present the rings as real security boundaries without an approved educational model.

## 5. Worked encounter — illustrative future behavior

This is a fictional design scenario, not implemented behavior or real-world incident-response guidance. Scenario text and response mappings require content review before becoming learning material.

1. **Existing:** ROOTKIT starts on the outer ring at speed 0.9 while the other two attackers move independently. After a complete orbit it jumps to the middle ring.
2. **Proposed Prototype 4:** The player clicks ROOTKIT. Its highlight appears, and the fixed panel shows ID 2, ROOTKIT, severity 2, and the JSON text `Placeholder: concealed system access.` Other attackers continue moving. No defense action is available.
3. **Future content proposal:** Replace placeholder encounter text with a reviewed fictional scenario describing indicators and constraints. It might explicitly state that the learning goal is limiting a suspected host's access to protected information pending investigation.
4. **Future choice proposal:** Offer contextual responses such as temporarily isolating the affected host, changing an unrelated interface setting, or dismissing the indicator. These illustrative choices do not exist in the current JSON schema or UI.
5. **Future evaluation proposal:** A separate evaluator considers scenario and response IDs. For this authored scenario, feedback could explain why isolation supports its stated containment goal while noting that isolation alone does not establish eradication or recovery. Do not use ROOTKIT as a universal lookup for one correct action.
6. **Future visual proposal:** A labeled containment marker and explanation acknowledge the outcome. Whether the attacker is removed, changes motion, or remains moving requires user approval.
7. **Existing invariant:** Selecting FILELESS transfers focus without pausing the other attackers. In the present game, all attackers continue at the innermost ring with no consequence.

## 6. Defense choices and feedback — proposed after Prototype 4

A future panel could show a small set of text responses under the scenario. Each needs a stable identifier and explicit scenario context. Feedback should explain the response rather than merely display a correct/incorrect color.

Proposed feedback includes a text status, symbol or outline, and short rationale. Do not rely on color alone. Any audio, animation, attacker removal, ring change, or encounter completion needs a separately approved specification. Keep selection highlights distinct from defense outcomes.

Prototype 4 only reserves layout space. It must not implement functioning defense buttons, response mappings, evaluation, scoring, damage, or financial loss.

## 7. Proposed roadmap: Prototypes 4–7

Each milestone below is a proposal. Review results and obtain approval before starting the next one.

| Prototype | Proposed focus | Completion gate | Scope boundary |
| --- | --- | --- | --- |
| 4 | Stationary attack information panel. | Selected JSON data stays readable at a fixed position while all attackers move and selection transfers. | Information only; no choices or outcomes. See the separate specification. |
| 5 | Small, reviewed defense-choice experiment using existing encounters. | A choice targets the selected attack ID and a contextual scenario; a separate evaluator returns an explainable result. | Requires approved content, choice format, evaluation rules, and retry policy. No assumed score, weapons, new attackers, or database. |
| 6 | Approved encounter feedback and resolution. | Selection, submitted choice, and outcome are visibly distinct, with predictable and tested threat behavior. | Requires decisions on resolved-attacker motion and reaching the inner ring. Damage, rewards, loss, and session endings are not automatically included. |
| 7 | Learning review and usability validation. | A proposed local debrief connects decisions to learning objectives; usability findings guide reviewed refinements. | Audience, assessment, and session structure require agreement. No accounts, remote telemetry, persistence, or adaptive learning assumed. |

Preserve exactly three attackers and accepted movement through Prototype 4. Later changes to count, pace, geometry, or inward jumps require explicit review.

## 8. Architecture and responsibility boundaries

| Layer | Implemented components | Proposed additions and boundaries |
| --- | --- | --- |
| Godot visual mechanics | Three existing scenes and `script/enemy.gd`. | A fixed UI scene under a CanvasLayer. Movement, hit testing, and rendering stay independent of educational rules. |
| Attack data | `data/attacks.json`, `script/attack_data_loader.gd`. | Preserve the six-field schema for Prototype 4. Future scenarios/choices require an approved schema. Attackers never load files or query services. |
| Coordination | `script/game.gd` owns initialization and selection. | Resolve selected IDs to validated data and update the panel; later route responses to an evaluator. |
| Defensive decision logic | None. | Separate evaluator consumes explicit scenario/response identifiers and returns an outcome plus rationale. It must not move nodes or read UI globals. |
| Learning systems | None. | Optional future component consumes outcomes for a local debrief. Storage, adaptation, analytics, and networking are unapproved. |

Current flow: JSON → loader/validator → controller → six attacker properties. Input: attacker signal → controller → exclusive highlight. Prototype 4 would add controller → stationary panel. Later components should exchange explicit IDs/results rather than use sibling-node lookups. These are responsibility boundaries, not authorization to build unused future systems.

## 9. Areas for programmer proposals

Useful proposals include text readability, panel spacing, accessibility/keyboard options, overlap handling, error clarity, test quality, viewport adaptation, and stronger data-to-instance mapping. Present an observed problem, a small change, an acceptance test, and its effect on the baseline.

Content proposals should state the learning objective and context needed to judge a response. Architecture proposals should separate data, visuals, and evaluation. Do not silently change speed, progression, input, attacker count, or severity meaning to solve an unrelated issue.

## 10. Open decisions requiring user approval

- Audience, technical depth, prerequisite knowledge, and measurable educational objectives.
- Prototype 4 placement, displayed fields, and selected-versus-hover presentation.
- Whether keyboard support, accessibility, or responsive layout belongs in Prototype 4 or later.
- Layer names and whether they carry functional rules or remain a metaphor.
- Reviewed scenarios, choice content, evaluator inputs, and acceptable-response criteria.
- Time pressure, retries, and whether submitted choices can change.
- Resolved-attacker behavior and the meaning of reaching the inner ring.
- Session endings and any future success/failure, score, damage, or financial consequences.
- Debrief, assessment, persistence, and connectivity scope.

## References and baseline

Accepted Prototype 3: `85424c035801bb50f5f894614d53ca2512123dbc`, tag `planetary-prototype3-json-attack-data-v1`. Prototype 2 tag: `planetary-prototype2-data-driven-attackers-v1`.

See [Prototype 3 completion](Prototype_3_Completion_Report.md), [Prototype 4 plan](Prototype_4_Implementation_Plan.md), and [programmer handoff](Programmer_Handoff_Guide.md). Historical completion reports describe their checkpoint-time state; later GitHub publication did not change gameplay.
