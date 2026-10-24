# Orbital Defense Command — Game Concept

Status: master design requirements updated after owner review of Prototype 5 on 24 October 2026. Implemented status, approved long-term requirements, and future proposals are distinguished below. Approval of this design direction is not authorization to implement further gameplay. The owner's governing principle is that every intelligence assessment and defensive decision involves uncertainty, even when an analyst expresses complete confidence. Documentation only: no gameplay, data, tests, artwork, settings, or checkpoint changes are authorized. The title and defending organization's name remain provisional.

## 1. Concept and fictional setting

Humanity is expanding into space. In this science-fiction setting, that expansion includes Elon Musk's plans to colonize Mars. Martians see the prospect as a threat to their planet, sovereignty, and future. From their perspective, resisting human expansion is planetary defense rather than unprovoked conquest.

Some Martian factions launch covert operations against valuable orbital data centers supporting human infrastructure. Their objectives include disrupting services, compromising important information, and causing fictional financial losses that make further expansion harder. Genuine attackers may conceal their intentions, but nationality, affiliation, or an unfamiliar trajectory does not establish hostility.

The wider orbital environment also includes:

- Peaceful civilian spacecraft and research probes.
- Objects belonging to neutral planetary organizations.
- Commercial and scientific traffic with legitimate reasons to approach orbital infrastructure.
- Unknown or unidentified objects whose identity or purpose is unresolved.
- Genuine Martian attackers disguising themselves as routine traffic.
- Signals unrelated to any nearby object or threat, including background communications that happen to look relevant.

Not every unidentified object is dangerous, and not every suspicious signal indicates hostile intent. Star Fink can misidentify a peaceful neutral contact as an attacker. Martians also have civilian interests and differing views of human expansion; their perspective as defenders of their planet should remain part of the fiction without making all Martian objects enemies.

The player works at a remote defense command station operated by **Star Fink**, a temporary working name for a fictional defending organization. Neither that name nor the game's title is a finalized brand. The command station must protect several orbital data centers while distinguishing actual threats from ordinary activity.

The central challenge is deciding **what deserves attention, what the evidence supports, and whether to deploy a defense, investigate further, or hold fire**. Motion can convey urgency, but uncertainty governs every assessment and decision. Intelligence and SIGINT supply imperfect information; defensive action and restraint can both have consequences.

## 2. Educational purpose and player experience

The proposed learning objective combines cybersecurity concepts with reasoning under uncertainty. Players should practice separating observation from interpretation, updating a hypothesis when evidence changes, considering harmless explanations, and distinguishing a plausible diagnosis from an effective response. Extremely confident analysts can still be wrong; a favorable outcome does not prove the preceding reasoning was sound, and an unfavorable outcome does not automatically make a reasonable decision irrational.

The intended experience is a command role, not an automatic shoot-everything exercise. Many moving objects may be harmless. Spending a scarce defense on a harmless object or watching one suspicious contact too long could leave a more valuable target exposed. Refusing to attack can be the correct decision. A useful debrief should explain the information available at decision time without automatically revealing hidden identity, intentions, or capabilities; any later disclosure needs its own evidence or an explicitly approved debrief policy.

Audience, technical depth, and the balance between education, narrative, and strategy require owner approval. Cybersecurity descriptions, attack-to-defense relationships, and explanations need content review before they become instructional material. Fictional effects and probabilities are game rules, not claims of real defensive effectiveness.

## 3. Implemented baseline, approved requirements, and future concepts

**Implemented** means present in the reviewed prototype. **Approved design requirement** means an owner-directed long-term obligation, not code already built or permission to implement it now. **Future proposal/open decision** means a suggested mechanism or delivery step requiring a separate specification and approval.

Prototypes 1-4 remain accepted history. Prototype 4's checkpoint is `16dc097421e4f2b1159ab3f5095db408e115b11e`, tag `planetary-prototype4-stationary-panel-hover-freeze-v1`. The owner considers the latest Prototype 5 improvements satisfactory for this stage; this does not create a new Git checkpoint. Prototype 5 work remains uncommitted on `feature/prototype5-intelligence-defense`.

| Area | Implemented through latest Prototype 5 | Approved requirement or future work, not implemented |
| --- | --- | --- |
| Tactical environment | One DATA asset with display-only `$1,000,000`, three rings, exactly three moving contacts. | Network of centers, strategic overview and focused tactical navigation (Section 14). |
| Motion/input | Speeds 0.49/0.63/0.77 radians/second; full revolutions, discrete inward jumps, continuing inner-ring motion; enlarged invisible hit areas and exclusive highlights. | Scalable contact population and navigation policy; no speed or geometry redesign is authorized. |
| Contact knowledge | Stable C-001/C-002/C-003 identifiers; one unidentified active encounter on C-001; two selectable background contacts. No floating hover-description popups. | Central registry, separate evolving assessments, triage and applicable per-contact deadlines. Unknown never means automatically hostile. |
| Evidence/decisions | Stationary intelligence, SIGINT and capability estimates; one authored follow-up; deterministic Deploy defense / Hold fire / expiry and replay. H, N and N100 fixtures separate private truth from public reports; N100 remains peaceful despite 100% hostile confidence. | Real intelligence production, assignments and standardized report lifecycle (Section 15). |
| Time | Configurable 300-second active-simulation decision budget derived from actual angular travel; prominent countdown and ring/orbit/window progress. Expiry differs from explicit hold fire. Replay restores only the active contact's initial progression. | Collection/report/command deadline coordination across centers; no strategic clock or multi-contact timing system exists. |
| Modes | Learning Mode enables explicit Read reports (pause); Active Challenge disables that reading pause. Hover holds only the hovered object and resumes exactly in either mode. | Optional concept learning through four providers and explicit multi-contact pause policy (Sections 16-17). |
| Data/resources | Six-field attack JSON validated outside moving objects; separate local authored scenario fixtures and deterministic resolver. Static demonstration staff/workload/analysis ETA. | Real staffing/resource allocation, database-backed concept mapping, provider adapters and certification tracking. No database technology selected. |

The attack abbreviations VM ESC / ROOTKIT / FILELESS remain externally configured records, not verified player-facing identities. Severity metadata is not hostility probability or time urgency. The DATA value is not an operating balance. No scoring, damage calculations, diplomacy, staffing scheduler, strategic threat registry, educational-provider integration or mastery/certification tracking exists.

Implementation history, in order: [original report](Prototype_5_Completion_Report.md), [demonstration indicators](Prototype_5_Completion_Report_2026-10-24_111602_01.md), [initial orbital deadline](Prototype_5_Completion_Report_2026-10-24_115626_01.md), and [five-minute window and Learning Mode](Prototype_5_Completion_Report_2026-10-24_121306_01.md). Later reports supersede earlier timing/reset descriptions; earlier reports remain historical records. Latest reported regressions passed Prototype 3, Prototype 4 (13,040 checks), and Prototype 5 (992 checks). Those are prior implementation results, not tests rerun for this documentation task.

## 4. Proposed gameplay loop and command responsibilities

1. **Monitor:** Observe contacts around the monitored centers. Identify which assets and approaches merit attention without assuming every moving object is hostile.
2. **Investigate:** Task an intelligence unit to build or update a contact profile. Profile information could include reported origin, travel history, observed behavior, source reliability, and unresolved questions.
3. **Evaluate signals:** Ask a SIGINT unit to examine transmissions linked, tentatively linked, or unrelated to a contact. Routine traffic, ambiguous content, misleading clues, and attribution errors should be possible.
4. **Assess:** Form a judgment about hostility and likely capabilities. Keep observations, interpretations, source limitations, and confidence separate. Investigation can supply more evidence but is not guaranteed to settle the truth; costs in time or attention require approval.
5. **Prioritize:** Compare the urgency and importance of different assets and contacts. A nearby threat is not automatically the most consequential one; a valuable center is not automatically worth every available defense.
6. **Decide:** Deploy a defense, investigate further, or explicitly hold fire. A response must target the intended contact/asset; it is based on an assessment, not certain knowledge of identity. Defense effectiveness, readiness, costs, and timing are separate questions.
7. **Resolve and review:** Apply an approved outcome rule, then distinguish what was observed, believed, chosen, and actually happened. Report only the outcome information available to the player. Unresolved identity can remain unresolved; completing an interaction need not reveal the scenario's hidden answer.

Prototype 5 represents intelligence and SIGINT with authored local reports; the fuller units and production workflow are future game functions, not network services or real analysts. Their presentation could be panels, reports, or task queues. Whether the player requests every investigation, receives automatic reports, or combines both is undecided.

### Mistaken defensive action and deliberate restraint

Star Fink can cause harm by deploying a defense against an innocent object. The following are proposed consequences, not approved mechanics or implemented systems:

| Possible consequence | Design significance; details remain open |
| --- | --- |
| Damage to neutral property | A mistaken intervention may interfere with or damage peaceful spacecraft, probes, or cargo. Exact effects and representation need approval. |
| Diplomatic dispute | A neutral planetary organization may challenge Star Fink's action. No diplomacy meter, faction system, or negotiation rules are specified. |
| Financial cost | Compensation, disruption, or expended equipment could create fictional costs. No amounts, accounting system, or scoring formula are approved. |
| Reputational damage | Other organizations may question Star Fink's judgment. This is a possible narrative consequence, not an implemented reputation statistic. |
| Reduced defensive readiness | Capacity spent on an innocent contact may be unavailable for a genuine attack. Quantities, replenishment, and timing remain undecided. |

Delayed action against a genuine threat may also lead to service interruption or fictional loss, but uncertainty must not make deployment the automatic winning move. In a peaceful-contact scenario, holding fire may avoid needless harm and be appropriate. Investigation may support restraint without making it certain. An explicit **Hold fire** decision differs from deadline expiration. Prototype 5 records those separately; future strategic consequences still require their own rules.

Consequence magnitude, accounting, reversibility, and session effects remain open. The existing `$1,000,000` label must not silently become an operational balance, damage meter, or penalty. Prototype 5 should demonstrate explanatory outcomes without building these larger consequence systems.

## 5. Six distinct layers: hidden truth through actual outcome

These must remain separate concepts and data responsibilities:

| Concept | Meaning | Who should use it |
| --- | --- | --- |
| 1. Actual hidden identity and intentions | True identity/affiliation, peaceful or hostile intent, and actual objective. An innocent contact has no secretly required attack merely because it is unidentified. | Private scenario state and resolver. Never copy automatically into player-facing labels or reports. |
| 2. Intelligence officers' assessments | Officers' interpretations of history, affiliation, behavior, source reliability, and hostility. These can be incomplete, biased, misleading, or mistaken. | Player-facing reports, with attributed confidence and limitations rather than an omniscient classification. |
| 3. SIGINT observations and interpretations | What was actually observed, such as a burst or repeated pattern, versus an analyst's interpretation of its source and meaning. A transmission may be unrelated to the contact. | Signals report and evidence record. Store observation separately from attribution and inferred intent. |
| 4. Estimated attack capabilities | Hypotheses about what the object might do if hostile, including unknown possibilities and potentially incorrect profile estimates. | Assessment UI; do not substitute the actual hidden capability list. |
| 5. Player's defensive decision | Deploy, investigate, or hold fire, plus the intended target and any approved response details. | Command coordination. Choosing an action neither proves hostility nor changes the underlying hidden identity. |
| 6. Actual outcome | What occurs when predetermined scenario state and the chosen action are resolved. It may differ from expectations. | Resolver and an explanation of player-observable effects. Test/debug ground truth is not automatically part of the normal player display. |

A displayed label or suspicious signal must not overwrite scenario truth. Equally, the resolver must not treat the most confident hypothesis as the actual attack. The actual outcome and what the player can verify about that outcome may differ: observing disruption does not necessarily identify its author or prove intention.

### Analyst certainty is not independently verified fact

Even a displayed **100% confidence** report is an analyst's expressed certainty, not an infallibility flag or the scenario's objective probability of hostility. The analyst may be overconfident, miscalibrated, deceived, or drawing a conclusion from wrongly attributed evidence. The game must be able to represent that report being wrong without changing the hidden scenario to match it.

If numeric confidence is used, label whose confidence it is and what claim it concerns. For example, `Intelligence officer: 100% confident this contact is hostile — assessment, identity not independently verified` conveys a different status from an observed fact. Whether that wording, a warning, or another confidence display is best remains a UI decision for owner review; the principle that complete reported confidence can be wrong is settled.

Independently verified facts must have an explicit scope and provenance. Verifying that a transmission occurred at a certain time does not verify that the nearby object sent it, and verifying a registry entry does not prove current intentions. More reports, especially reports sharing one source, do not automatically provide independent corroboration. Additional investigation can leave uncertainty unresolved.

No normal selection, confidence threshold, action button, or completed encounter should automatically reveal actual hidden identity or capabilities. Any disclosure requires a separately approved verification/debrief rule; internal fixture inspection may establish ground truth for tests without exposing it to players.

### Limited attack profiles

Initially, each hostile object should have an assigned profile containing **three possible attack capabilities**, drawn from a broader future catalog. It must not receive every catalog capability. These three capabilities belong to that object's scenario configuration; they are distinct from the complete set the player may eventually learn about.

For the first small encounter, hostility is predetermined privately, not assumed. In the hostile scenario only, an authored fixture can assign a three-capability profile and one attempted attack. In the peaceful neutral scenario, no hostile attack is attempted; the player may nevertheless receive mistaken estimates of three possible capabilities. Peaceful objects do not need an attack loadout to fit the model. Whether later hostile contacts switch, chain, or attempt multiple attacks requires approval.

The player's candidate list need not equal the object's true profile. Investigation may suggest some capabilities, suggest an incorrect one, or leave the profile unresolved. Report capability estimates as estimates; do not reveal a confirmed profile by default. Three listed possibilities are not necessarily equally likely, exhaustive, or possessed by the contact. An assessed capability does not establish hostile intent.

## 6. Identification probability is not defense success probability

**Attack-identification probability** is a model-relative belief about the hidden attack given evidence: for example, a 60% estimated chance of capability B, conditional on hostility. It is distinct from an officer's certainty claim, and may be poorly calibrated if the model or evidence is wrong. **Defense-effectiveness probability** concerns whether a chosen response works against a particular actual attack under stated conditions. Correct identification does not guarantee effective execution. Neither an optimistic effectiveness estimate nor a successful defense proves the initial identity assessment correct.

For a simplified hostile contact that attempts exactly one of three attacks, let:

- `p_i = P(attack i | evidence, hostile)` be the assessed probability of each attack; these sum to 1 within the defined three-attack model.
- `q_i = P(defense succeeds | attack i, chosen defense, timing, readiness, scenario conditions)` be that defense's conditional effectiveness.

Then estimated defense success against that hostile contact is `sum(p_i × q_i)`, within the assumptions of that model. This is a conceptual explanation, not a currently implemented formula or a requirement for Prototype 5. It cannot convert a subjective `100% confident` report into verified fact. If a possibility lies outside the assumed profile, do not silently renormalize it away: retain an unknown/other state or explicitly approve a closed-world simplification.

A one-in-three blind guess succeeds with probability **1/3 only when the three attacks are equally likely, the chosen response perfectly defeats its matching attack, it fails against the other two, and it is deployed in time with the required resources**. Unequal priors, ineffective execution, defenses covering several capabilities, or a late response change the result.

Keep hostility probability separate. If most contacts are harmless, the frequency of benign traffic matters when deciding whether to spend a defense. Do not call `P(hostile | evidence)`, `P(attack B | hostile, evidence)`, and `P(defense succeeds | actual attack)` the same confidence value. Severity and financial value are not substitutes. A peaceful contact is a meaningful possibility, not a fourth attack that the player must counter.

### Analytical example — not a Prototype 5 random-resolution design

For this hypothetical calculation only, an author's hidden scenario notes say a contact is hostile with profile A/B/C and attempts B. The player starts with an unidentified contact, not those facts. The peaceful scenario in Section 10 is equally important and is now represented by Prototype 5 fixtures.

1. Intelligence reports an unusual approach history, but its origin attribution is uncertain. SIGINT links a burst to the contact with moderate reliability; another intercepted message is ordinary maintenance chatter and provides no useful evidence. The signals are not automatically independent clues.
2. The player-facing assessment estimates a 70% chance that the contact is hostile. Conditional on hostility, it estimates A/B/C at 20%/60%/20%. These are scenario-authored example estimates, not measured cybersecurity probabilities.
3. The player selects defense D-B. In this toy model, it is 80% effective against B and ineffective against A/C, provided it is ready and arrives in time.
4. Estimated success conditional on a hostile contact is `0.20×0 + 0.60×0.80 + 0.20×0 = 0.48`, or 48%. This differs from the 60% identification estimate. Multiplying by the estimated 70% hostility gives 33.6% for the specific event of preventing an actual hostile attempt across both hostile/benign possibilities; it is not the overall probability of a favorable session or of DATA remaining intact.
5. In a future probabilistic model, an actual B attempt would face the assumed 80% conditional effectiveness rather than the player's 60% identification estimate. For Prototype 5, do not make an 80% random roll: choose an authored deterministic result for each fixture/action path. Even confident but wrong assessments can be demonstrated through fixed scenarios without randomness.
6. An explanation compares evidence, belief, action, and observable outcome without automatically disclosing the hidden profile. If the contact were peaceful, deploying D-B could cause unintended interference instead of preventing an attack. Financial, diplomatic, reputation, and readiness consequences require their own approval.

This example distinguishes types of probability; it is not a final defense table, an objective calibration guarantee, or an instruction to add a probability engine. Uncertainty for the player does not require random hidden state or random outcomes in the first prototype.

## 7. Game views and navigation

| View | Proposed content and player purpose |
| --- | --- |
| Strategic command overview | Several center markers, contacts/tracks, and assessed alerts. Distinguish unidentified contacts, analyst judgments, and narrowly verified observations; no marker automatically reveals peaceful/hostile scenario truth. |
| Intelligence analysis | Attributed officer assessments, investigation history, sources, reliability, alternative explanations, and unresolved questions. Label complete reported confidence as an assessment, not proof. |
| Signals intelligence | Observed transmissions with timing, separate source-attribution/meaning interpretations, and their uncertainty. Include unrelated signals and misleading correlations; a signal is not necessarily from the nearby object or evidence of hostile intent. |
| Tactical data-center zoom | Focus on one center and nearby activity, while preserving contact identities, selection context, and the approved strategic timeline. Make navigation back to overview clear. |
| Decision and outcome | Present Deploy a defense, Investigate further, and Hold fire for the implemented first encounter; strategic expansion remains future work. Show the intended target and relevant uncertainty before action. Explain observable effects and assessment/response limitations afterward without automatically exposing hidden identity or capabilities. |

Views may be tabs or contextual panels rather than separate scenes; that is an implementation decision for a later approved specification. Changing views must not duplicate a threat, recreate its state, or secretly give a new random outcome. Whether off-screen centers keep advancing and how urgent events are announced must be explicitly decided and tested.

### Reusing the three-ring tactical view

Prototype 4 provides an existing tactical foundation: a central DATA asset, three readable tracks, moving objects, selection and hover interaction, and a stationary information panel. It can represent a selected data center without discarding working code or artwork.

The existing discrete inward jump can remain a clear abstraction of threat progression. The rings are not a physically accurate orbital simulation or functional security layers today. Prototype 5 now derives a decision deadline from cumulative travel, while future defense effects, layer meanings, and wider consequences require separate rules; do not reinterpret an innermost orbit as a loss event without approval.

Prototype 5 now uses the fixed panel for **assessed contact information** and its three deterministic actions, without displaying hidden identity. Exactly three moving contacts remain the implemented baseline: one active encounter and two background contacts. More traffic requires a separately approved implementation milestone.

Hover freeze presents an important future timing question. Today it deliberately holds one object's complete orbital state and resumes without catch-up. Prototype 5 holds that contact's deadline with its movement. With multiple centers, define the strategic pause scope explicitly as required in Section 17. Preserve accepted behavior until that change is authorized; do not silently let strategic time consume a supposedly frozen attack's progress.

## 8. Initial implementation strategy: 2D / 2.5D

Recommend building the first expanded interactions in Godot using the existing 2D scenes, controls, and scripts. Layered backgrounds, depth shading, parallax, lighting accents, and transitions can suggest a 2.5D orbital command setting without rebuilding the game as true 3D. Clarity of tracks, readable text, and reliable targeting should take priority over visual complexity.

Use schematic overview markers and reuse the tactical view before commissioning a large art set. This supports small reviewable changes and reduces the assets a remote programmer must exchange. It also keeps presentation work separable from evidence and outcome rules.

True 3D remains a possible later enhancement after the complete interaction loop and navigation are useful. A later review would need to justify cameras, picking, performance, artwork effort, and readability. Keep authoritative contact/scenario state independent of rendering so a visual change does not require redefining probabilities or encounter outcomes. No 3D conversion is proposed for immediate implementation.

## 9. Programmer artwork handoff

These are suggested asset categories, not an art commission or final specification. Agree on style, scale, export needs, and licensing/source ownership in project review. Do not assume mandatory pixel dimensions or final file formats.

| Suggested asset | Intended use | Initial approach |
| --- | --- | --- |
| Data-center marker and tactical center visual | Recognize an asset on overview and in tactical focus. | Reuse existing DATA artwork first; center labels distinguish A/B/C before unique illustrations. |
| Contact silhouette/marker set | Represent unresolved contacts and clearly labelled assessment statuses. | Use the same neutral marker where appropriate for peaceful/hostile fixtures; art, filenames presented to players, colors, or animations must not leak hidden identity. |
| Command background or orbital backdrop | Establish science-fiction context without competing with tracks/text. | One restrained, reusable layer; no large animated scene required. |
| Intelligence and SIGINT symbols | Identify analysis panels, source types, and incoming reports. | A few simple consistent symbols plus text labels. |
| Selection, assessed-status, and outcome marks | Separate focus, analyst opinion, scoped verification, and observed outcome. | Reuse existing highlight where possible; combine text/symbols with color. A confidence mark must not be an infallible enemy badge. |
| Defense symbols | Identify responses once their mechanics are approved. | Defer specialized art until the small response set is settled. |
| Martian/Star Fink narrative imagery | Briefings or story identity. | Optional later work; names and visual identity are provisional. |

### First-priority set for limited connectivity

Start with existing DATA/attacker artwork and fonts, one neutral reusable contact marker, one generic data-center overview marker, and simple intelligence/SIGINT symbols. Existing Godot-drawn rings, labels, and UI containers can carry most of the first interaction. Unique art for every threat, three distinct center paintings, video, and 3D models are unnecessary for the first milestone.

Provide a compact, versioned asset bundle with a short manifest: asset name, purpose, source/ownership, whether it is placeholder/final, and which version replaces it. Include a small annotated reference image showing how assets fit together. Keep optional source files separate from the small integration bundle, and agree how the programmer can obtain them. Send incremental changed assets rather than repeatedly requiring the entire collection.

Resolve visual sizes, transparency, pivot/anchor expectations, text baked into art, and usable file formats with the programmer before production. Suggested names in a manifest should describe roles; avoid turning a temporary name or dimension into a mandatory interface.

## 10. Proposed development increments and test gates

This is the retained incremental roadmap: milestone A is now implemented through Prototype 5; B-F remain proposals. Section 18 adds phased design/integration gates without assigning them automatically to Prototype 6 or renumbering checkpoints. Each needs a small implementation specification and owner approval.

| Increment | Small proposed deliverable | Test/review gate |
| --- | --- | --- |
| A — Implemented Prototype 5: one uncertain encounter | One data center, one unidentified approaching contact, one short intelligence report, one short SIGINT report, uncertain hostility/capability assessments, and Deploy a defense / Investigate further / Hold fire. Predetermine hidden state and outcome branches for hostile and peaceful neutral fixtures. | Player-visible assessment stays separate from truth; all three actions produce the specified deterministic branch; hold fire can be appropriate; a wrongly confident report cannot turn a peaceful fixture hostile. No random probability engine. |
| B — Three-center command overview | Show Centers A/B/C and their identities/statuses. Initially reuse one active interaction rather than introducing three simultaneous independent threat engines. | Correct asset selection, clear priorities, consistent status, and no accidental duplication of the active encounter. |
| C — Zoom navigation | Move between overview and a selected center's tactical presentation. | Selection, contact IDs, evidence, orbital progress, and defense commitments survive navigation; returning does not reset time/state. |
| D — Richer intelligence and SIGINT | Expand beyond Prototype 5's two short reports into investigation/report sequences, including unrelated traffic, uncertain attribution, and misleading clues. | Provenance and timestamps remain inspectable; assessment updates remain fallible; repeated/correlated sources are not independent proof. |
| E — Independent threats | Activate independent encounters across centers, with mixed harmless traffic and approved response contention. | Investigating, freezing, selecting, or resolving one contact cannot unintentionally stop/reset others; simultaneous events and resource allocation remain deterministic/testable under the chosen time policy. |
| F — Larger scenarios | Increase contact variety, scenario length, competing priorities, and debrief depth in measured steps. | Readability and input stay usable; workload and consequences are understandable; performance and learning feedback remain acceptable before adding more content. |

Keep each increment small enough to review without a major asset download. Retain current movement, selection, JSON-validation, and panel tests unless a specifically approved behavior change requires a documented update. Add scenario/evidence/outcome tests independently of rendering. These tactical increments do not themselves require online APIs, accounts or telemetry. The later educational mapping registry has a preferred database-backed direction (Section 16), without selecting a technology or authorizing integration now.

### Prototype 5 encounter specification and retained design intent

This specification replaced the earlier confirmed-hostile assumption and has now been implemented with one active contact among three moving objects. The following intent and fixture descriptions are retained; Section 3 and the latest completion report govern implemented timing, one-follow-up limits, replay and modes. Larger defense/cost systems remain future proposals.

The retained minimum encounter specification contains:

- One unidentified approaching object associated with one monitored center. Selection initially displays a contact identifier, not its actual hidden affiliation or attack.
- One short intelligence report with an attributed assessment and source limitations.
- One short SIGINT report distinguishing observed signal from interpreted source/meaning. The signal may be unrelated.
- A hostility assessment and estimated capabilities explicitly marked uncertain. Three candidate attack capabilities, if shown, are conditional hypotheses about a potentially hostile contact, not proof of possession or hostility.
- A privately predetermined scenario state: peaceful/hostile identity and intent, any actual hostile profile/attempt, and an authored result for each permitted action path.
- An explainable, deterministic outcome with a boundary between player-visible effects and private test truth.

The three initial player actions are:

| Action | Implemented abstract interaction; larger mechanics remain open |
| --- | --- |
| **Deploy a defense** | Commit one abstract, authored response against this contact. Resolve through the fixture's deterministic branch. Do not build an arsenal, random hit roll, damage calculation, or final effectiveness matrix. |
| **Investigate further** | Request a short authored follow-up that may change or qualify the assessment without guaranteeing truth. Prototype 5 provides one follow-up, then permits defense or hold fire. Further repetition and any investigation costs remain future decisions. |
| **Hold fire** | Record deliberate restraint and resolve the scenario's authored no-deployment branch. It is a legitimate decision and can be appropriate for a peaceful contact, rather than an automatic failure or an unhandled timeout. |

Knowing the authored fixture's hidden state makes tests reproducible; it does not give the player that knowledge. For Prototype 5, prefer deterministic scenario outcomes over a probability engine: the same fixture, evidence state, and action sequence should return the same defined result. Numerical analyst confidence may still be displayed as authored, fallible information. No sampling, random enemy choice, learned confidence model, or RNG-based defense success is needed.

### Implemented test scenario H — concealed genuine hostile contact

Private author/test state: a genuine Martian attacker masks its purpose; it has the limited A/B/C capability profile and one predetermined attempted attack. Normal UI does not receive that truth by default.

Initial player information: an unidentified contact is approaching. Intelligence reports an irregular approach and suspects hostile purpose, but cannot independently establish origin or intent. SIGINT observes repeated bursts; attribution to this contact and the interpretation as attack preparation remain uncertain. Capability hypotheses are not a confirmed profile.

### Implemented test scenario N — peaceful neutral contact

Private author/test state: a peaceful scientific probe belongs to a neutral planetary organization and has no hostile objective or attempted attack. It may look unfamiliar and follow an unusual but legitimate route.

Initial player information: an unidentified contact is approaching. Intelligence interprets the route as potentially suspicious, with incomplete registry evidence. SIGINT observes intermittent signals nearby, but at least one is unrelated background traffic. Those observations can lead officers to a mistaken hostile/capability assessment.

Include a stress variant in which the intelligence officer reports **100% confidence that the contact is hostile**, while the predetermined contact remains peaceful. The confidence label must still identify an analyst opinion. This tests overconfidence and mistaken attribution; it must not change the scenario's identity or force the player to deploy.

### Authored deterministic branches and future consequence boundaries

Prototype 5 implements these abstract authored branches, not final defense, damage, financial or diplomacy rules. Expiration uses the no-intervention observation/result while retaining a separate expired decision; five-minute timing is described in Section 17. Player-visible text can describe observable effects without naming the private identity/profile. Larger consequences can remain explanatory narrative pending approval.

| Private fixture | Deploy a defense | Investigate further | Hold fire |
| --- | --- | --- | --- |
| H: genuine hostile | An authored response blocks the fixture's attempted interference; explain the observed interruption without automatically revealing identity or all capabilities. | An authored follow-up adds an uncertain connection between behavior and signals, then permits another decision. More evidence is not a guarantee. | The fixture reports the defined observable interference at the center. Exact operational effects or loss values remain unspecified. |
| N: peaceful neutral | The fixture reports unintended interference with the object's normal activity. Possible neutral-property/readiness consequences can be explained without implementing meters or penalties. | An authored follow-up suggests a legitimate research/registry explanation, with attribution limitations still shown. | The object completes its legitimate passage without a defensive intervention; no hostile attempt occurs. Restraint is the appropriate branch for this fixture. |

### Prototype 5 encounter checks and continuing constraints

1. Both fixtures begin as an unidentified contact with the two short reports and all three action choices; no normal UI field, icon, or report automatically reveals hidden state.
2. Intelligence assessment, SIGINT observation/interpretation, capability estimate, player action, and actual outcome remain separately inspectable in test state.
3. Each action dispatches to the correct target and predetermined branch. Identical fixture/action sequences reproduce identical results without random draws.
4. Investigation changes only authored evidence/assessment state, not actual identity; the investigator can remain wrong or uncertain. Prototype 5 permits one follow-up per replay; this does not settle future investigation cost or repeat policies.
5. In N, hold fire avoids unnecessary deployment; deploying may produce the scripted unintended effect. No rule silently marks every non-deployment as failure.
6. N's 100%-confidence variant preserves its peaceful hidden state and possible hold-fire outcome. Reported certainty is never copied into a verified-hostile flag.
7. H demonstrates that delaying or declining deployment can differ from an effective response, under the agreed fixture script. These outcomes do not establish a universal correct defense from an abbreviation or claim that confidence guarantees effectiveness.
8. The outcome view describes permitted observable effects and reasons, not an automatic identity/capability reveal. Ground-truth assertions are allowed in tests/debugging only, unless a separate disclosure policy is approved.
9. Prototype 5 implements the configurable movement-derived deadline and explicit modes in Section 17. Scoring, diplomacy, reputation, financial-loss calculations, damage models, random outcome engines and real intelligence production remain unimplemented. Prototype 3/4 movement/input regressions remain preservation gates.

Current timing, one-follow-up limit and abstract outcomes are implemented as documented in Section 3. Future timing policies, investigation costs, expanded defenses, scoring and diplomacy require new owner approval before implementation. The proposal deliberately demonstrates uncertainty with authored scenarios before attempting a general simulation.

## 11. Proposed architecture boundaries

- **Scenario truth:** Privately owns actual identity, intent, objective, any hostile capability subset/attempt, and authoritative progress. An assessment or confidence display must never overwrite it.
- **Contact presentation:** Godot views display permitted contact information and motion. Keep contact IDs stable across overview/zoom; do not store the only copy of threat state in a disposable view.
- **Evidence and assessment:** Preserve raw SIGINT observations separately from interpretation/attribution, and officer opinions separately from verified observations. Store claim, source, confidence, and limitations rather than a confidence-driven truth flag. Prototype 5 can use authored reports/follow-ups; a general inference engine is not required.
- **Decision and outcome resolution:** Consumes the explicit Deploy / Investigate / Hold fire action and private scenario state, not a guessed identity from UI text. Prototype 5 uses predetermined branches. Keep actual results separate from the limited effects/reasons permitted in player-facing output.
- **Command coordination:** Routes selection, navigation, investigation requests, and response commitments. Avoid embedding scenario correctness rules in `enemy.gd` or individual button callbacks.
- **Future learning review:** Uses decision-time evidence, expressed confidence, action, and observable outcomes to explain reasoning and restraint. Do not equate a lucky result with sound judgment or automatically disclose hidden state. Persistence, adaptation, and analytics require separate approval.

The existing six-field attack JSON is a reusable description/movement interface, not a schema for all these systems. Future contact instances, capability catalogs, evidence, and defense rules may need separate local definitions. Propose and validate that schema before implementation; do not add hidden truth to the current player-visible record and assume it remains concealed.

## 12. Open design decisions

1. Who is the target audience, and what cybersecurity knowledge should each encounter teach?
2. What are the final title, defending-organization name, visual style, and narrative tone? How much Martian perspective should briefings reveal?
3. How frequent is peaceful/neutral traffic, what sources are available, and how can observations support but fail to prove a claim about intent?
4. Are three capabilities fixed per object, revealed by investigation, or only partially knowable? Does one contact attempt one attack, switch, or chain capabilities?
5. Does the player enter likelihoods, read analyst estimates, or choose qualitative assessments? How should attributed 100% confidence be displayed without implying verified fact? The principle that such an analyst can be wrong is not open for reversal; wording, calibration explanations, priors, attribution uncertainty, correlation, and unknown-state presentation still need review.
6. How should the reviewed deterministic Prototype 5 scripts evolve, and what should a future abstract defense represent beyond current authored outcomes? Consider a probabilistic or mixed engine only as a separately approved later enhancement; do not build one for this first interaction.
7. Beyond Prototype 5's movement-derived window, how should strategic objectives and deadlines relate to tactical progress? Inner-ring arrival remains neither collision nor automatic loss.
8. How do hover freeze, off-screen simulation, navigation, and any reading/analysis mode affect time across centers?
9. Which consequences for false positives, delay, failed defenses, and wasted capacity should be narrative only? Any neutral-property damage, financial accounting, diplomacy, reputation, readiness, or scoring system needs explicit scope and rules before implementation.
10. What makes a center higher priority: asset value, service importance, evidence quality, proximity, or some combination? How is that shown without forcing one automatic policy?
11. What evidence could independently verify a narrowly scoped fact, and what may a debrief disclose? Default outcome/selection behavior must not automatically reveal actual identity or capabilities. How should a reasonable decision, mistaken certainty, and appropriate restraint be explained?
12. What ends an interaction, how do investigation repeats and explicit hold fire differ from timeout, what can be retried, and what evidence of learning is useful without unapproved tracking or accounts? Prototype 5's timing/reset policy is documented in Section 17; future strategic timing and any score remain undecided.

## 13. Proposed updates to existing planning documents

This revision updates only this existing concept document. No other planning documents were edited. Recommended changes for later authorization:

| Existing document | Proposed update |
| --- | --- |
| [Game Design Plan](Planetary_Attacker_Defender_Game_Design_Plan.md) | Add the uncertainty principle and legitimate hold-fire decisions alongside this science-fiction concept; update current-state sections through reviewed Prototype 5, including the five-minute deadline, explicit learning pause and deterministic encounter. Reconcile earlier Prototype 5–7 ideas with the deterministic unidentified-contact proposal, without treating any future feature as authorized. |
| [Programmer Handoff Guide](Programmer_Handoff_Guide.md) | Explain accepted Prototype 4 checkpoint versus reviewed uncommitted Prototype 5 work and current regressions; explain separate private truth, officer assessments, SIGINT observations/interpretations, capability estimates, decisions, and outcomes. Replace obsolete Prototype 4 preparation advice and avoid assuming confirmed-hostile first encounters. |
| [Prototype 4 Implementation Plan](Prototype_4_Implementation_Plan.md) | Preserve the approved plan as history; optionally add a cross-reference to its completion report and this new direction, rather than rewriting it to imply multi-center/intelligence features were part of Prototype 4. |
| Prototype completion reports | Retain historical test/checkpoint records. Link a future approved implementation report to this concept instead of revising old results or tags. |

The owner has reviewed the current Prototype 5 interaction satisfactorily. New strategic/educational implementation still requires its own reviewed specification and authorization. This document does not change the accepted baseline, start a new prototype, or authorize Git publication.

## 14. Strategic command-center requirements

**Approved long-term design requirements; not implemented.** Orbital Defense Command must support a network of orbital data centers, with an overview of the entire defended environment and a tactical view of one selected center. An illustrative operational scenario is **15 data centers**, about **three unidentified or potentially hostile contacts per center**, roughly **45 contacts under surveillance**. These are capacity examples, not fixed limits or a claim of 45 attackers. Scenarios must support fewer or more centers/contacts, including peaceful traffic and unknown objects with no applicable decision deadline.

The command system must provide:

- A centralized observed-contact registry with stable contact IDs, center associations, observation history, lifecycle/status, and separately versioned assessments. A contact seen from more than one center must not become duplicate independent threats merely because views change.
- A separate intelligence assessment for each contact: claim, provenance, evidence references, confidence, limitations, alternative explanations, assessed capabilities/severity, and update time/version. New intelligence may revise an assessment without changing hidden scenario truth or rewriting what the commander previously knew.
- Individual decision deadlines **where applicable**, with explicit unavailable/not-applicable states. Unknown contacts must not receive invented attack deadlines. Collection and report deadlines remain distinct (Section 15).
- A triage queue sortable by earliest applicable deadline, assessed severity, confidence, and other approved priorities, such as center importance, stale evidence or report readiness. Display sort direction, missing-value behavior, and ties; the detailed policy requires approval. High confidence must not automatically mean hostile or highest priority, and low confidence can itself warrant investigation.
- A visible distinction between **assessed severity** (possible impact of a hypothesized threat) and **time urgency** (time until an applicable opportunity/deadline). Neither is proof of hostility, a defense-effectiveness probability, or an automatic permission to deploy.
- Resource allocation across competing collection/analysis tasks, including readable assignment/workload/report states. This is a future operational capability, not the current demo numbers.
- Data-driven scenario sizes and reusable components. The current three-contact scene must not become a hardcoded limit in registry, assessment, triage or scheduling logic.

The strategic overview and tactical focus must read the same authoritative state. Navigation may change presentation, not create/restart encounters, replace IDs, extend deadlines or reveal private truth. An eventual time policy must explicitly cover off-screen centers and learning assistance. The existing three-ring view remains the tactical foundation; retain Godot 2D/2.5D initially, with true 3D optional later.

### Proposed state boundaries

| Responsibility | Conceptual records and boundaries; not a final schema |
| --- | --- |
| Scenario truth/resolution | Private identity, intentions, actual capability subset/attempt and outcomes; inaccessible to ordinary registry/learning presentation |
| Observation registry | contact_id, center_id associations, observed tracks and evidence IDs; observation is not an omniscient identity lookup |
| Intelligence assessment | assessment_id/version, contact_id, evidence references, claims, confidence, uncertainty, assessed severity and alternatives |
| Operational workflow | task/report IDs, assigned personnel, capacity, stage/status, relevant deadlines and estimated durations |
| Command decision | decision ID, target, selected response/restraint, decision-time evidence/assessment versions, timely/expired status |
| Views and learning | Public projections, selection/navigation context and authorized return state; no hidden outcome shortcut |

The existing separation among hidden truth, observed evidence, interpretation, assessed confidence/capabilities, player decision and actual outcome remains mandatory. An update to an analyst opinion cannot rewrite the actual contact identity, including the peaceful N100 case.

## 15. Intelligence production workflow requirements

**Approved long-term design requirements; not implemented as a scheduler or pipeline.** Future intelligence operations must distinguish five functions even if an early interface combines their presentation:

| Function | Intended responsibility and output |
| --- | --- |
| 1. Intelligence collection | Capture observations and source metadata during available opportunities; preserve what was collected, when and with what limitations. Collection failure or absence is not proof of harmlessness or hostility. |
| 2. Signal identification, decoding and interpretation | Identify signal form, attempt decoding/decryption where possible, and distinguish raw transmission from tentative meaning/source attribution. Alien communication can include language, structured digital data, telemetry, encryption, or forms not yet understood. Unreadable content remains unknown; a decoded message need not be truthful or attributable to a nearby contact. |
| 3. Intelligence analysis | Combine evidence with source limitations and alternatives into fallible assessments. Record confidence about a specific claim, dependencies/correlated sources, and unresolved questions. A confidently wrong interpretation remains possible. |
| 4. Standardized report production/dissemination | Produce consistent reports with IDs/versions, contact references, author/source, observation versus interpretation, confidence/limitations, creation/update time, status, recipients and relevance/expiry. Deliver revised reports to command without erasing the decision-time record. Final templates/status vocabulary require review. |
| 5. Command assessment/decision | Review available reports, assessed severity and urgency; prioritize tasks and choose deployment, further investigation or restraint. Record what information supported the decision and what was observable afterward. |

The commander must eventually see personnel assigned and available, current assignments, occupied capacity, workload, report status and operational priorities. Assignment accounting must be consistent and avoid assigning the same capacity twice. Exact roles, skills, concurrency, interruption, reassignment and work-duration rules are open; this task specifies visibility and separation, not a staffing algorithm.

### Four different time concepts

| Time concept | Meaning | Must not be confused with |
| --- | --- | --- |
| Collection opportunity/deadline | Window in which a source/signal can be observed or obtained | Proof that an attack occurs when a signal is missed |
| Analyst report deadline | Time by which an analysis/report is requested or operationally useful | Guaranteed completion or command's final action deadline |
| Command decision deadline | Applicable last opportunity for a timely command action on a contact | A physical collision or automatically calculated financial loss |
| Estimated analysis duration/ETA | Uncertain estimate of work required or expected completion, with basis clearly stated | A guaranteed due date, a staffing calculation already implemented, or an automatic investigation completion |

Future task/report records should reference their own clock basis, affected contact/center, status and dependencies. How a missed collection/report deadline affects evidence, command options and late reports needs approval. Prototype 5 implements only one command window and static demonstration analysis ETA/workload; its authored follow-up is not this production pipeline.

## 16. Educational Learning Architecture

**Core approved long-term design requirement; provider integration is not implemented.** The game must be entertaining and educational through evidence, decisions and consequences, without requiring conventional multiple-choice questions during normal command gameplay. Learning assistance is optional in normal play; a separately designed assessment mode may restrict assistance. The optional targeted learning session may use questions or exercises, without turning every orbital decision into a quiz.

### Providers and reusable boundaries

Recognize **Smart Stack, Max IQ Ace, Smart Space, and Space Gurus** as potential learning providers. None is assumed to share another provider's interface, database, schema, content taxonomy, launch protocol or persistence model. The four existing projects must be examined before defining a concrete adapter contract or promising integration. No provider inspection, connectivity or certification coverage is claimed here.

The architecture must be modular and reusable across future games and subjects:

- A game requests learning by stable concept/decision IDs, not embedded provider-specific question sets.
- A shared mapping registry resolves concepts to eligible provider/content-set versions and learning objectives.
- A provider adapter, or equivalent reviewed interface, handles that provider's retrieval, targeted-session presentation/launch, completion/cancellation and safe return semantics.
- Game state/clock policy and authorization remain owned by the game/session coordinator. Providers must not control scenario truth or decide the encounter outcome.
- Practice history and optional proficiency estimates remain separate from fictional encounter correctness. A high practice score is not verification that a contact is hostile or a defense will succeed.

A **database-backed registry is the preferred architectural direction**, but no database technology, deployment topology, schema implementation or migration is chosen. A small local/offline mapping fixture may demonstrate the contract first if separately approved; the engine must depend on registry interfaces rather than one storage technology.

### Context-sensitive learning flow

1. At a meaningful decision, identify one or more relevant concepts from public decision context, without using the hidden correct branch to select a revealing lesson.
2. Resolve those concept IDs through the shared registry, including compatible content version, difficulty and optional objective mappings.
3. Offer suitable resources from one or more supported providers. The player may decline and continue normal gameplay.
4. Before opening an embedded or external session, capture/validate return context and apply the approved mode-specific pause policy.
5. Launch a short targeted session, initially around **five questions or exercises**, not an automatic 25- or 50-item session. The provider may have different exercise types; item-count/completion semantics need adapter review.
6. Return on completion, cancellation or failure to the original decision. Restore or reconcile contact selection, center/view, public evidence/assessment context, authoritative simulation state, decision status and applicable remaining time under the chosen policy. Do not blindly restore stale state over an encounter that legitimately progressed.
7. Optionally record concepts practiced and approved mastery/proficiency indicators, with content versions and clear limitations. Learning results do not resolve the fictional encounter.

A lesson teaches the underlying concept, for example command-and-control communications, without revealing the current object's hidden identity, attempted capability or correct action. Links, titles, content choice, query parameters, return payloads and debug fields must not encode private fixture answers.

### Proposed conceptual mapping model

Identifiers below are conceptual stable keys, not a final database schema or assumptions about existing provider records. Define namespace ownership, version semantics and validation after project inspection.

| Identifier/field | Proposed purpose |
| --- | --- |
| game_id | Consumer game namespace; reusable across future games |
| scenario_id | Stable scenario reference for mapping/context, not a public hidden H/N answer label |
| decision_point_id | Specific decision context independent of UI node paths |
| concept_id | Shared underlying knowledge concept; many concepts may apply to one decision |
| learning_provider_id | Smart Stack, Max IQ Ace, Smart Space or Space Gurus adapter identity |
| learning_content_set_id | Provider-specific targeted set reference, resolved through its adapter |
| difficulty_level | Reviewed difficulty metadata; provider scales require explicit translation |
| certification_id | Optional certification reference; absence allowed |
| exam_objective_id | Optional objective reference tied to an authoritative exam/version mapping |
| content_version | Exact content/mapping version needed for compatibility, audit and reproducible return |
| return_context | Opaque/validated continuation reference and state version; no private scenario truth in provider payloads |

Example only: decision `ODC-DEC-014` requires concept `CYBER-C2-001`. Registry entries map that concept to a reviewed Smart Space content set, and potentially alternatives in any of the other three providers. A reviewed adapter retrieves/presents about five relevant items and returns control to the same decision. These illustrative IDs do not assert that any existing provider already has such a set.

Use many-to-many decision-to-concept and concept-to-provider-content mappings. Store provider-specific references behind adapters; never hardcode individual question sets into Orbital Defense Command. Certification/objective associations are optional, versioned metadata, not necessary to launch every lesson. A provider's content update should update mappings/compatibility data without changing the core Godot engine.

### Persistence, failure handling and integration gates

Future requirements include:

- Persist a resumable game continuation before leaving the command view, with stable contact/center IDs, selection, evidence/assessment versions, simulation/progression state, applicable deadlines and their pause policy, mode, decision status, and continuation version/token. The exact storage/serialization contract requires review.
- Scope time preservation explicitly (Section 17). Restoring a paused context must not add time, duplicate decisions or reset other contacts. If simulation continued, reconcile new evidence/deadline state and notify the player rather than reinstating an obsolete timer.
- Track which concepts were practiced, provider/content version and completion/cancellation. Optional mastery/proficiency indicators require an agreed model, retention policy and player consent/privacy design; avoid equating one short session with demonstrated certification mastery.
- Handle missing mappings, unavailable providers, incompatible versions, interrupted sessions and invalid/duplicate/stale return requests gracefully. Offer an eligible alternative or return safely to the game with a clear explanation. No invented content, hidden-truth reveal, progress wipe or punitive default for provider failure.
- Support local/offline content and cached versioned mappings where feasible, subject to provider capabilities, content rights and update rules. Do not require an online service merely to preserve the existing offline game.
- Examine all four projects' interfaces, storage, identifiers, content structure, question/exercise selection, licensing, offline support and state/return behavior before specifying the adapter. Capability differences should remain explicit; a provider without a needed feature must report that limitation.

Initial learning focus is **cybersecurity**. Future tracks may cover **intelligence analysis, project management/PMP-related concepts, risk management, communications and decision-making, and other certification or academic subjects**. Keep shared concept IDs and adapter boundaries broad enough for those subjects without pretending their content is already available.

Any certification mapping must be checked against the relevant **published exam objectives and their versions** before claiming coverage. Record source/version and review status; a related gameplay topic or an illustrative exam_objective_id is not evidence of certification alignment. No certification coverage claim is made by this design update.

## 17. Learning modes and simulation-time policy

### Implemented Prototype 5 behavior

- Learning Mode is the default mode setting. It permits the explicit **Read reports (pause)** control for the selected active C-001 encounter; merely selecting the mode/contact does not pause it.
- While that control is on, only the active contact's movement/progression and derived deadline hold. The two background contacts continue. Turning it off resumes exactly, with no catch-up. Selecting a background, resolving, replaying or switching to Active Challenge clears the reading pause.
- Active Challenge Mode disables reading pause and advances normally; hover-freeze remains available in both modes, including independent background hover. No SceneTree/global pause exists.
- The five-minute initial budget is `abs(angular_speed) * 300` radians; remaining seconds derive from remaining travel divided by speed. Selection does not extend it; investigation remains one authored follow-up, independent of static analysis ETA. Replay restores active initial progression only. No inner-ring collision or financial calculation follows.

### Future learning-session policy: must be specified before integration

Opening a provider session is not implemented by the current reading toggle. A future mode must explicitly define whether learning pauses **one contact**, **the selected tactical encounter/center**, or **the entire strategic simulation**, and whether other deadlines/evidence/tasks continue. These are different policies, not interchangeable UI labels. Pausing C-001 must never be assumed to pause the other 44 illustrative contacts.

For normal Learning Mode, specify how optional instruction remains usable while preserving/reconciling applicable time and context. For Active Challenge or future assessment modes, specify whether instruction is allowed and whether time continues. Before implementation, agree effects on collection windows, analyst report deadlines, command windows, background motion and off-screen centers; suspend/resume and cancellation rules must be deterministic and visible to the player. Avoid accidentally giving extra time through repeated launches/selection/returns. The scope decision remains open; this document selects no new global-clock mechanism.

## 18. Proposed phased requirements and proof-of-concept gates

These are planning proposals, not implementation authorization, Prototype 6 assignments or new checkpoints. Preserve the earlier B-F roadmap and limited-connectivity asset strategy; begin with small reviewable specifications and tests.

| Phase | Small proposed deliverable | Approval/test gate |
| --- | --- | --- |
| 1. Multi-contact registry and triage design | Define center/contact IDs, public observation registry, per-contact assessment history, applicable deadlines and triage sorting. Sketch overview/tactical navigation using a small dataset before illustrative 15/45 scale. | Mixed harmless/unknown/hostile author fixtures; no truth leakage, duplicate contacts or reset on navigation; severity distinct from urgency; deterministic sort/missing values; fewer/more contacts supported. |
| 2. Staffing and reporting requirements | Specify the five production functions, assignments/capacity, report states and all four time concepts. Demonstration values remain labeled until real mechanics are approved. | Consistent personnel totals, clear priorities/status, no double allocation, fallible/versioned reports; ETA differs from due date and command window. Approve scheduling and multi-contact pause policy before code. |
| 3. Learning registry and adapter specification | Inspect all four learning projects; inventory capabilities and define concept namespaces, many-to-many mapping, versioning, safe return contract and offline/failure behavior. | Review actual provider differences; no presumed identical schemas; choose storage technology only in a separate approved decision. Verify public-only lesson requests and validated continuations. |
| 4. One end-to-end learning proof of concept | After approval, connect one decision/concept to one compatible provider for roughly five questions/exercises, then return to the original decision. | Completion/cancel/unavailable/interrupted paths restore or reconcile selection, evidence and simulation/deadline state; deterministic pause policy, no answer leakage, no duplicate decision, optional assistance can be declined. |
| 5. Expand providers, subjects and objective mappings | Add adapters/content incrementally across Smart Stack, Max IQ Ace, Smart Space and Space Gurus; then reviewed learning tracks and optional proficiency. | Per-provider contract tests, version/update/offline checks, public-only context, content review and authoritative versioned exam-objective verification before coverage claims. |

### Additional open design decisions

Owner review is required for registry identity/lifecycle and cross-center association rules; triage default sort/ties/alerting; assessed severity scales; staffing roles, capacity, reassignment and report templates; collection/report deadline consequences; multi-contact learning pause scope and return reconciliation; future assessment-mode assistance restrictions; concept namespace ownership and difficulty translation; provider capability/rights discovery; database technology/topology and persistence/security; practice-history retention and optional mastery model; and certification authority/version-review process. The requirement for uncertainty and the prohibition on treating expressed confidence as truth remain settled.

This master update changes documentation only. It does not implement strategic traffic, scheduling, provider integration, database mappings or certification tracking, and does not authorize any gameplay or checkpoint change.
