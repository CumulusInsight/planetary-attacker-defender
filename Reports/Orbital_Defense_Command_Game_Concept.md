# Orbital Defense Command â€” Game Concept

Status: master design updated for owner-authorized Prototype 9 local implementation/testing. Accepted Prototype 8 remains at `a532946cfc2a22a503263eaf07cd2825590615c2`, tag `planetary-prototype8-orbital-intelligence-v1`. Prototype 9 is uncommitted on `feature/prototype9-contact-escalation`, awaiting owner review. No publication or Prototype 10 is authorized. Intelligence remains fallible; implemented requirements and future proposals remain distinct. Star Fink and the game title remain provisional.

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

Prototypes 1-4 remain accepted history. Prototype 4 is preserved at `16dc097421e4f2b1159ab3f5095db408e115b11e`, tag `planetary-prototype4-stationary-panel-hover-freeze-v1`. The accepted Prototype 5/6 implementation is now checkpointed at `4dccf04644a213932570923f655ea745407d8cba`, annotated tag `planetary-prototype6-strategic-command-v1`. Prototype 7 was subsequently accepted and published at `4af29a9c2f73bcd0830b1dfea364138deb02f1f7`, tag `planetary-prototype7-command-scoring-v1`. Prototype 8 was accepted and published at `a532946cfc2a22a503263eaf07cd2825590615c2`, tag `planetary-prototype8-orbital-intelligence-v1`; its local checkpoint-report addendum remains preserved. Prototype 9 adds Section 23 operational escalation without replacing these accepted systems.

| Area | Implemented baseline and current Prototype 9 addition | Future requirements, not implemented |
| --- | --- | --- |
| Environment and navigation | Three data centers, eighteen stable contacts in the Prototype 8 main scene (nine original circular contacts plus nine elliptical surveillance contacts), reusable strategic/tactical views, selectable registry and deadline/severity triage with scrolling. Standalone Prototype 5 tactical scene remains available. | Larger networks such as the illustrative 15/45 environment; general multi-encounter-per-center scheduling. |
| Motion/input | Speeds 0.49/0.63/0.77; full-revolution discrete inward jumps; continuous inner-ring motion; enlarged hit areas and exclusive visible selection. | No movement redesign is approved. |
| Encounter integrity | Three independent active encounters and fifteen background contacts (six original plus nine elliptical); the nine elliptical contacts now have explicit player-driven operational states, without fabricated deadlines or official mission scoring participation. H, N and N100 retain hidden truth separately from evidence/assessment/confidence; N100 remains peaceful despite its 100% hostile opinion. | Richer evidence production, verification and independent report histories. Unknown contacts must not become automatic enemies. |
| Timing/modes | Movement-derived five-minute default; explicit 6/4-minute demonstration overrides in DC-02/DC-03; strategic Learning pause holds all encounter hosts, backgrounds continue; Challenge advances offscreen; hover freezes only the tactical contact. | Learning-provider launch/return policy and larger-network timing specification. |
| Decisions | One follow-up, deterministic defense/hold-fire/expiry and isolated replay. Expiry is distinct from intentional restraint. | Defense catalogs, damage and financial models, diplomacy or random outcomes. |
| Command roles and mission | Prototype 7 adds Tactical Officer and Operations Commander presentations, five defender objectives, a configurable 1,000-point event-ledger model, public confirmed-performance displays and an evidence-limited final scorecard. See Sections 19-20. | Strategic Commander, staff delegation and playable attacker controls. |
| Operations and resources | Prototype 9 adds explicit watchlist/investigation/escalation/disposition, two-slot FIFO investigation scheduling, authored follow-ups and separate operational statistics. Static staffing demonstration remains distinct. Provider integration is absent. | Real staffing, database-backed concept mappings, learning-provider adapters, mastery/certification tracking. |

The attack abbreviations remain externally configured movement/description records, not verified identities. Assessed severity is not urgency, hostility probability or actual affiliation. DATA's `$1,000,000` remains a display-only placeholder. The new point ledger does not authorize unsupported health, damage, financial or personnel calculations.

Historical reports, retained unchanged: [original Prototype 5](Prototype_5_Completion_Report.md), [demo indicators](Prototype_5_Completion_Report_2026-10-24_111602_01.md), [initial deadline](Prototype_5_Completion_Report_2026-10-24_115626_01.md), [five-minute/reading refinement](Prototype_5_Completion_Report_2026-10-24_121306_01.md), and [Prototype 6](Prototype_6_Completion_Report_2026-10-24_131502_01.md). Earlier uncommitted/timing statements describe their historical stage, not the latest checkpoint. [Prototype 7 completion report](Prototype_7_Completion_Report_2026-10-24_144347_01.md) provides current test evidence and limitations.


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
| Financial cost | Compensation, disruption, or expended equipment could create fictional costs. No financial amounts, accounting system, or financial-cost scoring formula are approved. Prototype 7 scores only the evidence-limited categories in Section 20. |
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

If numeric confidence is used, label whose confidence it is and what claim it concerns. For example, `Intelligence officer: 100% confident this contact is hostile â€” assessment, identity not independently verified` conveys a different status from an observed fact. Whether that wording, a warning, or another confidence display is best remains a UI decision for owner review; the principle that complete reported confidence can be wrong is settled.

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

Then estimated defense success against that hostile contact is `sum(p_i Ã— q_i)`, within the assumptions of that model. This is a conceptual explanation, not a currently implemented formula or a requirement for Prototype 5. It cannot convert a subjective `100% confident` report into verified fact. If a possibility lies outside the assumed profile, do not silently renormalize it away: retain an unknown/other state or explicitly approve a closed-world simplification.

A one-in-three blind guess succeeds with probability **1/3 only when the three attacks are equally likely, the chosen response perfectly defeats its matching attack, it fails against the other two, and it is deployed in time with the required resources**. Unequal priors, ineffective execution, defenses covering several capabilities, or a late response change the result.

Keep hostility probability separate. If most contacts are harmless, the frequency of benign traffic matters when deciding whether to spend a defense. Do not call `P(hostile | evidence)`, `P(attack B | hostile, evidence)`, and `P(defense succeeds | actual attack)` the same confidence value. Severity and financial value are not substitutes. A peaceful contact is a meaningful possibility, not a fourth attack that the player must counter.

### Analytical example â€” not a Prototype 5 random-resolution design

For this hypothetical calculation only, an author's hidden scenario notes say a contact is hostile with profile A/B/C and attempts B. The player starts with an unidentified contact, not those facts. The peaceful scenario in Section 10 is equally important and is now represented by Prototype 5 fixtures.

1. Intelligence reports an unusual approach history, but its origin attribution is uncertain. SIGINT links a burst to the contact with moderate reliability; another intercepted message is ordinary maintenance chatter and provides no useful evidence. The signals are not automatically independent clues.
2. The player-facing assessment estimates a 70% chance that the contact is hostile. Conditional on hostility, it estimates A/B/C at 20%/60%/20%. These are scenario-authored example estimates, not measured cybersecurity probabilities.
3. The player selects defense D-B. In this toy model, it is 80% effective against B and ineffective against A/C, provided it is ready and arrives in time.
4. Estimated success conditional on a hostile contact is `0.20Ã—0 + 0.60Ã—0.80 + 0.20Ã—0 = 0.48`, or 48%. This differs from the 60% identification estimate. Multiplying by the estimated 70% hostility gives 33.6% for the specific event of preventing an actual hostile attempt across both hostile/benign possibilities; it is not the overall probability of a favorable session or of DATA remaining intact.
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

This is the retained incremental roadmap: A is implemented through Prototype 5; B/C and a three-encounter slice of E are implemented through Prototype 6. Richer D/E/F scope remains future work. Section 18 retains phased requirements without authorizing further implementation or renumbering checkpoints. Each needs a small implementation specification and owner approval.

| Increment | Small proposed deliverable | Test/review gate |
| --- | --- | --- |
| A â€” Implemented Prototype 5: one uncertain encounter | One data center, one unidentified approaching contact, one short intelligence report, one short SIGINT report, uncertain hostility/capability assessments, and Deploy a defense / Investigate further / Hold fire. Predetermine hidden state and outcome branches for hostile and peaceful neutral fixtures. | Player-visible assessment stays separate from truth; all three actions produce the specified deterministic branch; hold fire can be appropriate; a wrongly confident report cannot turn a peaceful fixture hostile. No random probability engine. |
| B â€” Three-center command overview | Show Centers A/B/C and their identities/statuses. Prototype 6 now retains three deterministic active encounters, one per center, using the same tactical component; broader concurrency remains future work. | Correct asset selection, clear priorities, consistent status, and no accidental duplication of the active encounter. |
| C â€” Zoom navigation | Move between overview and a selected center's tactical presentation. | Selection, contact IDs, evidence, orbital progress, and defense commitments survive navigation; returning does not reset time/state. |
| D â€” Richer intelligence and SIGINT | Expand beyond Prototype 5's two short reports into investigation/report sequences, including unrelated traffic, uncertain attribution, and misleading clues. | Provenance and timestamps remain inspectable; assessment updates remain fallible; repeated/correlated sources are not independent proof. |
| E â€” Independent threats | Activate independent encounters across centers, with mixed harmless traffic and approved response contention. | Investigating, freezing, selecting, or resolving one contact cannot unintentionally stop/reset others; simultaneous events and resource allocation remain deterministic/testable under the chosen time policy. |
| F â€” Larger scenarios | Increase contact variety, scenario length, competing priorities, and debrief depth in measured steps. | Readability and input stay usable; workload and consequences are understandable; performance and learning feedback remain acceptable before adding more content. |

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

### Implemented test scenario H â€” concealed genuine hostile contact

Private author/test state: a genuine Martian attacker masks its purpose; it has the limited A/B/C capability profile and one predetermined attempted attack. Normal UI does not receive that truth by default.

Initial player information: an unidentified contact is approaching. Intelligence reports an irregular approach and suspects hostile purpose, but cannot independently establish origin or intent. SIGINT observes repeated bursts; attribution to this contact and the interpretation as attack preparation remain uncertain. Capability hypotheses are not a confirmed profile.

### Implemented test scenario N â€” peaceful neutral contact

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
9. Prototype 5 implements the configurable movement-derived deadline and explicit modes in Section 17. Prototype 7 adds only the evidence-limited mission points in Section 20. Diplomacy, reputation, financial-loss calculations, damage models, random outcome engines and real intelligence production remain unimplemented. Prototype 3/4 movement/input regressions remain preservation gates.

Current timing, one-follow-up limit and abstract outcomes are implemented as documented in Section 3. Future timing policies, investigation costs, expanded defenses, scoring beyond Prototype 7's explicit ledger, and diplomacy require new owner approval. The proposal deliberately demonstrates uncertainty with authored scenarios before attempting a general simulation.

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
| [Game Design Plan](Planetary_Attacker_Defender_Game_Design_Plan.md) | Add the uncertainty principle and legitimate hold-fire decisions alongside this science-fiction concept; update current-state sections through reviewed Prototype 5, including the five-minute deadline, explicit learning pause and deterministic encounter. Reconcile earlier Prototype 5â€“7 ideas with the deterministic unidentified-contact proposal, without treating any future feature as authorized. |
| [Programmer Handoff Guide](Programmer_Handoff_Guide.md) | Explain accepted Prototype 4 checkpoint versus reviewed uncommitted Prototype 5 work and current regressions; explain separate private truth, officer assessments, SIGINT observations/interpretations, capability estimates, decisions, and outcomes. Replace obsolete Prototype 4 preparation advice and avoid assuming confirmed-hostile first encounters. |
| [Prototype 4 Implementation Plan](Prototype_4_Implementation_Plan.md) | Preserve the approved plan as history; optionally add a cross-reference to its completion report and this new direction, rather than rewriting it to imply multi-center/intelligence features were part of Prototype 4. |
| Prototype completion reports | Retain historical test/checkpoint records. Link a future approved implementation report to this concept instead of revising old results or tags. |

The owner has reviewed the current Prototype 5 interaction satisfactorily. New strategic/educational implementation still requires its own reviewed specification and authorization. This document does not change the accepted baseline, start a new prototype, or authorize Git publication.

## 14. Strategic command-center requirements

**Approved long-term design requirements; a three-center registry/triage/tactical slice is implemented in Prototype 6.** Orbital Defense Command must ultimately support a network of orbital data centers, with an overview of the entire defended environment and a tactical view of one selected center. An illustrative operational scenario is **15 data centers**, about **three unidentified or potentially hostile contacts per center**, roughly **45 contacts under surveillance**. These are capacity examples, not fixed limits or a claim of 45 attackers. Scenarios must support fewer or more centers/contacts, including peaceful traffic and unknown objects with no applicable decision deadline.

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

These remain planning proposals except for the explicitly implemented registry/triage slice summarized in Section 3; they do not authorize new gameplay, learning integration or checkpoints. Preserve the earlier B-F roadmap and limited-connectivity asset strategy; begin with small reviewable specifications and tests.

| Phase | Small proposed deliverable | Approval/test gate |
| --- | --- | --- |
| 1. Multi-contact registry and triage design | Define center/contact IDs, public observation registry, per-contact assessment history, applicable deadlines and triage sorting. Sketch overview/tactical navigation using a small dataset before illustrative 15/45 scale. | Mixed harmless/unknown/hostile author fixtures; no truth leakage, duplicate contacts or reset on navigation; severity distinct from urgency; deterministic sort/missing values; fewer/more contacts supported. |
| 2. Staffing and reporting requirements | Specify the five production functions, assignments/capacity, report states and all four time concepts. Demonstration values remain labeled until real mechanics are approved. | Consistent personnel totals, clear priorities/status, no double allocation, fallible/versioned reports; ETA differs from due date and command window. Approve scheduling and multi-contact pause policy before code. |
| 3. Learning registry and adapter specification | Inspect all four learning projects; inventory capabilities and define concept namespaces, many-to-many mapping, versioning, safe return contract and offline/failure behavior. | Review actual provider differences; no presumed identical schemas; choose storage technology only in a separate approved decision. Verify public-only lesson requests and validated continuations. |
| 4. One end-to-end learning proof of concept | After approval, connect one decision/concept to one compatible provider for roughly five questions/exercises, then return to the original decision. | Completion/cancel/unavailable/interrupted paths restore or reconcile selection, evidence and simulation/deadline state; deterministic pause policy, no answer leakage, no duplicate decision, optional assistance can be declined. |
| 5. Expand providers, subjects and objective mappings | Add adapters/content incrementally across Smart Stack, Max IQ Ace, Smart Space and Space Gurus; then reviewed learning tracks and optional proficiency. | Per-provider contract tests, version/update/offline checks, public-only context, content review and authoritative versioned exam-objective verification before coverage claims. |

### Additional open design decisions

Owner review is required for registry identity/lifecycle and cross-center association rules; triage default sort/ties/alerting; assessed severity scales; staffing roles, capacity, reassignment and report templates; collection/report deadline consequences; multi-contact learning pause scope and return reconciliation; future assessment-mode assistance restrictions; concept namespace ownership and difficulty translation; provider capability/rights discovery; database technology/topology and persistence/security; practice-history retention and optional mastery model; and certification authority/version-review process. The requirement for uncertainty and the prohibition on treating expressed confidence as truth remain settled.

The strategic and mission slices actually implemented are recorded in Sections 3 and 19-20. The remaining roadmap does not authorize scheduling, provider integration, database mappings, certification tracking or checkpoint changes.

## 19. Command hierarchy and mission objectives (Prototype 7)

**Implemented locally for owner review.** Command level changes responsibility and presentation, not scenario truth, difficulty, angular speed, deadline budget or resolver rules. The role selector has exactly two operational choices; navigation also sets the matching level.

| Tier | Responsibility and implementation status |
| --- | --- |
| Tactical Officer | Implemented: focus one data center; select contacts, read local intelligence/SIGINT and countdown, investigate, deploy or deliberately hold fire. A narrow local panel shows objectives, official disposition/timeliness and confirmed point contribution without entering the orbital click area. |
| Operations Commander | Implemented: network-level monitored/active/resolved/deadline status, confirmed performance, objective progress, three center cards and nine-contact triage. Prioritize by deadline or assessed severity, enter tactical focus and return without resetting simulation. |
| Strategic Commander | Future design only: coordinate broader missions/networks and high-level policy across a larger environment. No 15-center implementation, staff delegation, personnel management or third playable tier is included in Prototype 7. |

These are single-player command perspectives, not a new account/permission or multiplayer system. Shared Learning strategic pause and Active Challenge policies remain as accepted in Prototype 6. The standalone Prototype 5 scene retains its local reading-control behavior. Opening the detailed mission scorecard does not automatically pause time; Learning pause is an explicit prior action.

`data/mission.json` defines the defender mission and its objective IDs/text separately from scenario truth. The mission binds to the configured active contact at each center; backgrounds do not acquire objectives/deadlines. Primary defender goals are:

1. Protect operational data centers.
2. Correctly resolve active encounters.
3. Avoid unnecessary defensive engagements.
4. Make decisions before applicable deadlines.
5. Maintain operational effectiveness.

Objective status distinguishes official disposition from proven correctness, and monitored assets from independently verified operational health. Progress toward a goal must not become a hidden-identity oracle. Mission data is validated; missing/invalid data disables scoring clearly while preserving the existing tactical simulation.

## 20. Defender scoring and mission ledger (Prototype 7)

### Configurable weights and applicability

The proposed maximum is **1,000 points**, configured in mission data, not UI code. Points do not represent money, damage or personnel efficiency.

| Category | Maximum | Current public assessment policy |
| --- | --- | --- |
| Asset protection | 350 | Unassessed: existing fixtures do not provide complete operational-health/damage verification. Do not label all three centers operational or assign damage merely from a disturbance. |
| Threat resolution | 250 | Credit reviewed observable effects of official dispositions: observed block or deliberate passage without interference. Observed access disturbance earns zero resolution fraction. Uncertain/unreviewed effects remain unassessed. Expiry earns no timely-resolution credit even if passage looks favorable. |
| Decision quality | 200 | Unassessed publicly: identity, engagement necessity and epistemic reasoning quality are not independently verified. Effective effects alone do not establish a well-reasoned decision. Actual fixture adjudication stays private. |
| Resource management | 100 | Unassessed: no validated resource quantities/costs, allocation or personnel-efficiency model exists. No invented expenditure or reward for pressing fewer buttons. |
| Command effectiveness | 100 | Limited confirmed metric: timely actual disposition versus recorded expiry. Timeliness credit is explicitly not a correctness or successful-defense endorsement. |

For N official participants, an assessable outcome's contribution to a category of weight W is `W * fraction / N`. Threat-resolution fractions are 1 for an observed blocked attempt or deliberate quiet passage, 0 for observed disturbance or expiry, and null/unassessed for uncertain effects. Command-effectiveness fraction is 1 for an actual timely deploy/hold resolution and 0 for expiry. No resolution event means no assessed contribution yet, rather than an earned zero.

At category/network/local level, present **confirmed points**, **assessed capacity**, and **unassessed capacity** separately. Do not rescale a partly assessed mission to 1,000 or treat unavailable categories as earned zero. With all three official dispositions consisting of an observed block and two deliberate quiet passages, confirmed points are 350, assessed capacity 350, and the remaining 650 stays unassessed. A mission involving uncertain intervention effects has less assessed capacity, not fabricated certainty.

The evidence rules match existing player-visible observation text exactly and carry public explanations. Unreviewed observations remain unassessed. Public points depend only on those observable facts and the known disposition, not hidden identity, assessed severity/confidence, fixture key or private result code. Identical public observation/action/uncertainty must produce identical public score output despite different private adjudication.

### Private actual-outcome adjudication and penalties

The trusted resolver emits a resolution event containing the actual deterministic outcome plus the public observation. The ledger privately distinguishes appropriate response to the authored attempt, appropriate restraint, unsuccessful intervention/non-intervention, unintended probe interference and expiration. It never substitutes public severity for actual outcome.

A neutral unnecessary deployment records a **pending private decision-quality penalty** of `decision_quality_weight / N`, represented as lost provisional credit for that participant, not a second deduction from an already-zero contribution. It earns no confirmed threat-resolution/decision-quality bonus simply because intelligence was highly confident. Its public observation remains the existing uncertainty about stopped telemetry and possible unintended interference; the normal scorecard does not declare the object peaceful.

Private outcome-match/provisional-quality values are not independently justified reasoning grades and are never published by a normal UI control, tooltip, notification or final-card toggle. Because engagement necessity is unconfirmed in the current fixtures, the penalty remains withheld/unassessed publicly, even after mission completion. It must not become an identity-revealing score change. A future approved independent-verification policy is required before publishing identity-dependent penalties or correctness grades. No scenario truth or new verification fact is invented to make a full 1,000-point result available.

Intentional hold fire and expiration remain different event decisions. Quiet passage after expiry is a favorable effect without a timely deliberate decision, not a reason to award the same restraint credit. This separates supported performance from a lucky outcome without exposing actual affiliation.

### Event and replay policy

- Append an official event only when the deterministic resolver actually resolves a participant through deploy, hold fire or deadline expiration. Investigation, repeated clicks and navigation create no scored events.
- Each mission/center/contact slot accepts its **first resolution only** as official. Duplicate or replayed resolutions do not overwrite or add points. Before any official resolution, the accepted explicit replay reset can still restart local state, and its first eventual resolution becomes official; resetting itself earns nothing. After the first result, replays retain all accepted movement/evidence/decision behavior as practice, isolated from the official ledger and other centers.
- Mission completion means every official participant has one disposition; it does not assert that every decision was correct or every category assessable. The final mission scorecard explains all five categories, objectives and official observable outcomes. Later practice can still run without changing that final score.
- Current live-encounter counts reflect simulation (including practice) while official disposition counts reflect the immutable ledger. Label both to avoid confusing replay state with a second mission opportunity.
- Ledger state is in memory for this mission/application session. No save/load, player profile, database, restart-mission score exploit mechanism or new persistence service was added.

The architecture separates mission validation/configuration, deterministic session resolution events, private adjudication/official ledger, explicit public projection, and command/tactical presentation. Moving contact scripts do not score. Future evidence policies must keep actual truth separate from report interpretation and defender-visible confirmation.

## 21. Future attacker missions and scoring architecture

**Design/configuration only; not playable.** A separate `attacker_future` section defines prospective objectives: reconnaissance, disruption, unauthorized control, damage to a designated target, and resource preservation/stealth. These are general future mission types, not the current contacts' hidden objectives, and are not displayed in the defender interface.

| Future attacker category | Proposed maximum |
| --- | --- |
| Mission objectives achieved | 400 |
| Target impact or control | 250 |
| Stealth and deception | 150 |
| Resource efficiency | 100 |
| Operational coordination | 100 |
| Total | 1,000 |

Keep defender and attacker models, weight sets, role-specific evidence and public projections separate. The event-ledger pattern can be reused with a distinct attacker ledger/adjudicator and explicit mission/role/event namespaces; do not simply pass the defender's private records into an attacker UI or vice versa. Actor-authorized knowledge and observable effects define each projection. Future replay/idempotency and independent verification must be specified per mission/role.

Prototype 7 does not instantiate an attacker ledger, offer attacker command controls, simulate attacker personnel/resources, calculate target damage or implement Strategic Commander. Attacker scoring, broader delegation, new verification evidence, persistence, complete resource/health models, and publication of held quality penalties require separately reviewed scope. Current balancing weights, first-resolution policy and evidence-limited applicability are open for owner playtest review, without weakening the settled uncertainty/privacy principles.


## 22. Prototype 8 ? elliptical surveillance and fallible source reports

**Accepted Prototype 8 baseline**, checkpoint `a532946cfc2a22a503263eaf07cd2825590615c2`. Its entry is `scene/orbital_command.tscn`, a thin inherited instance of `scene/command_center.tscn` enabling the optional orbital-intelligence configuration. The same controller and reusable tactical scene serve all centers. The baseline command-center scene remains runnable with its accepted nine contacts so unchanged Prototype 6/7 regression assertions continue to exercise that baseline. The standalone Prototype 5 tactical scene remains unchanged in scope. Prototype 8's integration suite exercises the actual eighteen-contact main scene rather than weakening older population assertions.

### Surveillance traffic and geometry

DC-01 adds C-010..C-012, DC-02 adds C-013..C-015, DC-03 adds C-016..C-018. C-001..C-009 retain their original center assignments. Exactly C-001, C-004 and C-007 remain active mission participants. Passive status and public concern are separate: even a concerning assessed contact has no executable encounter unless explicitly configured in future work.

The new native diamond symbols are identical across private affiliations. A yellow outline indicates selection only. No downloaded artwork is used. Each center has the same three configurable but geometrically distinct trajectories, centered at the existing DATA location (800,450). With active movement time t, phase is `phi0 + direction * angular_rate * t`; position is `center + rotate(Vector2(horizontal_radius*cos(phase), vertical_radius*sin(phase)), orientation)`. Hover excludes elapsed time rather than accumulating catch-up. Radii, orientation, initial phase, direction and rate are JSON parameters. These are visual surveillance trajectories relative to DATA, **not physically validated gravitational orbits**. Original circular speeds, cumulative travel, full-orbit inward jumps, inner-ring motion and movement-derived deadlines are untouched.

The loader computes rotated ellipse extrema and rejects paths outside the usable tactical region, including a symbol/label/hit-area margin. Fine neutral trajectory lines distinguish geometry without assigning truth-based colors. Existing objective panel, right console and top controls retain their bounds. Native enlarged hover interaction applies independently to the new symbols; circular contacts retain their accepted hit areas.

### Source taxonomy and reusable data

`data/orbital_intelligence.json` contains public traffic metadata, ordered authored reports, and separate private passive-contact fixtures. `intelligence_data_loader.gd` validates the whole extension before it is installed. `intelligence_session.gd` owns release state/history and private fixtures. Movement objects read no JSON or report content. The console receives only an explicit public projection; private fixture metadata and unreleased reports are excluded.

Sources use readable native indicators: `[S] SIGINT`, `[P] Platform Profile`, `[T] Trajectory Assessment`, `[F] Follow-up Analysis`. Reports define stable report/contact IDs, source, text, release condition, public assessment and assessed severity. Confidence, suspected payload, recommendations and supersession reference are optional. Missing confidence/payload/options are explicitly shown as not supplied/reported, never invented. Supported assessment labels include Suspected hostile, Uncertain, Assessed nonhostile and Assessment revised. Confidence is confidence in an assessment, never an identity guarantee or defense-success probability.

Recommendations are text explicitly marked ADVISORY ONLY: surveillance, further investigation, preparation, existing deployment/restraint where an active encounter allows it. Passive contacts do not gain defense or replay buttons; unsupported response suggestions remain advisory. No weapons, ammunition, countermeasure or electronic-warfare engine is added.

### Revision and knowledge boundaries

Current assessment is derived from the latest released report; strategic severity and confidence use the same public record. Previous reports remain in oldest-first history, with source/text/rationale, prior/newer labels, and a supersedes reference. Selection does not rewrite reports. The latest report may itself be wrong. Reclassification does not mutate private affiliation, the player's recorded decision, the observed outcome, or the mission ledger.

The authored demonstration includes a supported hostile concern (C-010), an initially 100%-confident false positive revised toward a nonhostile explanation (C-011), an initially nonhostile assessment revised toward concern and then a later confidently wrong nonhostile assessment (C-012), and unresolved ambiguity (C-013 and other traffic). These are **developer fixture examples**, not secret labels disclosed in the interface. Normal UI never shows which assessment is actually correct. Identical public reports remain identical if private fixture truth is changed in a test.

### Deterministic delivery, pause and replay

Only two reliable triggers are implemented: contact-relative elapsed movement time and the existing one-use active-encounter investigation action. Time-based reports use accumulated actual angular travel divided by configured angular rate, with strategic-pause movement explicitly excluded. There is no separate wall clock. JSON order is authoritative within each contact; an unavailable earlier report blocks later reports for that contact. Most new traffic reports arrive at 0, 8, 16 and 30 seconds of eligible movement; C-012 has a further report at 45 seconds. Existing active encounters receive an additional source report after their existing investigation.

Learning strategic pause holds active contact motion/deadlines and **all new intelligence delivery**. Original and elliptical backgrounds keep moving as accepted; their movement accrued during that pause is removed from report-release progression, so no report catches up on resume. Tactical hover holds only that contact's movement-derived elapsed schedule; other contacts/centers continue. Challenge advances motion and delivery offscreen. Switching views, opening history/scorecard and selecting contacts do not reset schedules or deadlines. Existing authored Prototype 5 follow-up actions remain immediate even during explicit pause; the new source-feed entry waits for resume. This preserves accepted investigation behavior while preventing autonomous timed delivery during reading pause.

Replay restores the active encounter's movement/deadline and its own source history/release origin. Passive traffic/history and other centers are not reset. First official scoring results remain immutable; practice cannot farm points. Restarting the application begins a new authored surveillance session; persistent report archives are not implemented.

### Scoring integration and future art

`mission_ledger.gd`, `mission_data_loader.gd`, `mission_ui.gd`, mission weights, deterministic encounter fixtures and resolution rules are preserved unchanged. Reports, observations, passive selection and repeated investigation award no points. Only the original three session resolutions reach official scoring. Revised public assessments never replace evidence-based scoring rules or reveal hidden affiliation through points. Unsupported health/resource/identity-dependent categories remain unassessed as in Prototype 7. Future attacker scoring remains separate and disabled.

Future original art may replace generic contact glyphs, source markers and assessment text accents after review. Request neutral traffic silhouettes, source badges and selection/unread-report treatments that communicate knowledge state without encoding actual allegiance. Sizes/formats and license ownership remain review decisions; final artwork is not required by this prototype.

Open questions: whether passive surveillance should eventually support requested investigations, how authored report provenance/corroboration should be modeled, whether new report notifications need a dedicated unread badge, how longer histories should be filtered, whether changing modes should ever pause background trajectories, and when independent verification could permit more scoring categories. These remain proposals, not further implementation authorization.


## 23. Prototype 9 - contact escalation and command accountability

**Implemented locally for owner review; no new accepted checkpoint.** The initial P9 entry is `scene/operational_command.tscn`; the cyber refinement below now supplies the F5 entry. It is a thin inherited Prototype 8 command scene enabling the operations extension. Existing Prototype 8/6 command entries and standalone tactical scene retain their baseline behavior for unchanged regressions. Three centers, eighteen contacts, original three official mission participants, original deadlines, movement, hover and deterministic outcomes remain intact.

### Operational state is separate from assessment

Only C-010..C-018 have the new operational state model. All start MONITORED regardless of intelligence or private truth. A MONITORED contact may be suspected hostile, WATCHLIST may be assessed nonhostile, and ESCALATED is a commander designation, never proof of hostility. No report or hidden affiliation automatically escalates/de-escalates a contact.

`data/contact_operations.json` supplies investigation capacity/durations, the supported transition table, authored public follow-up reports and consequence descriptions. Schema validation pins supported action/state semantics and rejects incomplete/remapped transitions, duplicate/missing IDs, invalid durations/optional windows, malformed reports and incomplete consequences. Invalid configuration disables this extension with a readable diagnostic; accepted surveillance/encounters remain available.

| State | Accepted command/event | Result |
| --- | --- | --- |
| MONITORED | Add to Watchlist | WATCHLIST |
| MONITORED or WATCHLIST | Request Investigation, once per contact | INVESTIGATING; job active or queued |
| INVESTIGATING | Investigation completes | WATCHLIST; completed report awaits review |
| MONITORED, WATCHLIST or INVESTIGATING | Explicit confirmed escalation | ESCALATED |
| ESCALATED | Continue tracking, once per escalation episode | ESCALATED; command recorded |
| ESCALATED | Deliberate de-escalation | WATCHLIST; not a final disposition |
| ESCALATED | Deploy interceptor, Hold fire, Resolve release | RESOLVED; one final disposition |
| ESCALATED | Expiry, only if a window is configured | RESOLVED; distinct expired disposition |
| Any eligible completed unreviewed job | Mark reviewed | Same state; review acknowledged once |
| RESOLVED | Other commands | Rejected |

Completion/expiry are internal events, not player commands. A completion while already ESCALATED keeps that state; changed intelligence does not undo orders. Final resolution cancels unfinished investigation and releases its slot; de-escalation alone retains pending work. No return-to-MONITORED or operational replay/reset button is added. Restarting the application begins a new session.

### Investigation production and timing

Two configurable simultaneous slots are a small scheduling model **separate from static demonstration staffing**. Configured delays are 12/18/10 seconds, repeated across each center's three new contacts. Each has one authored follow-up, independent of hidden truth: C-010 increases concern, C-011 favors survey activity, C-012 is a confidently wrong nonhostile assessment, and other examples remain ambiguous. Accepted timed reports may later supersede these results.

One network session clock advances once per controller frame, independent of views. FIFO uses accepted request event order with contact-ID tie-breaking. Equal-time completions process in ascending contact ID, before expiry; freed slots start work at that exact timestamp. Large deltas are split at event boundaries, producing frame-partition-invariant scheduling. ETA includes queue wait plus work duration. Started-job queue delays, active/queued workload and completed/unreviewed reports are visible and audited. There are no charges or reading penalties.

Learning strategic pause holds investigation progress with no catch-up. Challenge advances it offscreen. Hover preserves accepted contact-specific movement freeze, but does not pause analyst work; this difference is labeled. Prototype 8's movement-derived report release behavior is untouched. Completed investigation reports append once to that same contact's history, referencing the latest released report as superseded. Existing text, chronology, confidence, payload and recommendations are retained, not rewritten. No per-panel timer exists.

### Escalation, responses and consequences

A blocking confirmation shows contact ID, public assessment/confidence, latest relevant report, defensive options and a required 3-300 character reason. Confirmation saves the displayed evidence snapshot and reason in the append-only event ledger. Reports arriving later do not rewrite that order. Cancel performs no transition. Contact appearance remains neutral.

Continue tracking is not final resolution. De-escalate returns to WATCHLIST. Resolve/release closes the case without engagement. Hold fire closes it with deliberate allowed departure. Intercept records authorization, immediate acknowledged **abstract deployment**, and an observation that effects, identity and condition remain unverified. It is not a confirmed kill, neutralization or damage result. Command-issued, action-executed and outcome-observed events remain separate even when timestamps coincide. No weapon physics, ammunition, combat outcomes inferred from hidden identity or diplomacy calculations are introduced.

No new deadline is shipped; the UI says **No confirmed deadline.** A validated optional operational review window is supported for explicit fixtures. It starts at first escalation, uses the network clock and cannot be extended through de-escalation/re-escalation. An overdue re-escalation expires atomically before another response is possible. Expiry differs from hold fire. This is an authored operational opportunity, not an inferred attack arrival/collision. Hover does not pause this independent window; strategic pause does. Original three movement-derived deadlines remain untouched.

### Interface and operational event ledger

The existing tactical intelligence console and mission objectives remain. A lower-left operational card shows state, investigation/ETA, optional window, disposition and command entry. The right status label identifies operational state; the inherited passive defense buttons remain disabled because the dedicated operations console supplies the new commands.

The dedicated operations view provides the nine-contact queue, state/awaiting-review filters, operational priority or ID sorting, contact-to-center navigation/highlight, network/per-center workload, current/source history, order-time evidence, consequences, audit history and enabled/disabled commands. The eighteen-contact strategic triage separately displays operational state without replacing public severity/urgency. Original command levels, mission scorecard and original encounter actions remain accessible by returning to command. Long histories scroll at readable font sizes; native text indicators do not encode affiliation.

The separate P9 operational-performance section reports unique investigated/escalated/de-escalated contacts, completed investigations, deployments, intentional hold fire, resolved/open cases, started-job queue delays and rejected commands. These are **statistics, not points or correctness grades**. Monotonic event IDs and command request tokens make delivery idempotent. Duplicate delivered tokens add no events; a distinct invalid command attempt adds only a rejection count. No UI refresh/navigation/report arrival can farm successful metrics. Each contact has at most one final disposition and authored investigation per session.

Prototype 7 mission weights, participants, event ledger and first-resolution-official replay policy are unchanged. New operations never emit original encounter resolution events or affect official points. Original tactical replay cannot reset operational records or their reports. Persistent save/replay of operational sessions is not implemented.

### Public/private boundaries and deferred work

Operations model/scheduler and UI never receive private fixture truth. They use explicit commands and authored public evidence. A peaceful contact may be escalated; a private hostile contact may remain monitored. No score or hidden outcome confirms whether the decision was right. Future modeled interception effects, independent verification, ammunition/costs, staffing allocation, report retries/cancellation controls, persistence, operational replay and possible scoring integration require separate approval. Future attacker architecture remains separate/inactive. Educational providers, databases and Prototype 10 are not implemented or authorized.


### Prototype 9 acceptance corrections - action receipts and strategic header sorting

The original three active encounters and newly escalated operations remain distinct. A controlled original-path probe confirmed that deployment just before the movement-derived deadline records one existing deterministic outcome; at zero or later expiry wins. This does not establish what happened in the owner's exact manual incident. Rejections previously had no visible acknowledgment, and outcomes shared long scrollable reports. Strategic pause could also replace the resolved clock caption with a pause notice.

Original encounter resolution signals now project into public in-session receipts, not additional scoring events. A fixed summary card, persistent banner and After-action history control show contact ID, acceptance/rejection, exact time remaining at acceptance, executed command, disposition and the existing observable outcome/limitations. The original report auto-scroll remains intact; visible feedback no longer depends on it. The closed positive countdown is labeled TIME AT ACCEPTANCE and retains Decision recorded even during strategic pause; actual expiry retains DEADLINE EXPIRED. Movement passing the deadline after a valid decision cannot generate a second contradictory resolution. Replay retains prior receipts with attempt identifiers while clearing stale current-result display. Identical repeated rejections are coalesced. Receipt history is per tactical center and lasts for the application session.

Prototype 9 operational feedback reuses its existing event ledger: command-issued/rejected events now include applicable configured time remaining. The immediate receipt explicitly says COMMAND ACCEPTED/REJECTED, shows contact/disposition and labels abstract response outcome UNVERIFIED. Existing command/execution/observation history remains available; no second operational scoring or resolution ledger is created. No new deadline, hidden-truth disclosure, neutralization claim or score rule is introduced.

The main Operations Commander contact table supports clickable header sorting for Contact, Center, Public intelligence assessment, Confidence, Severity, Time to act and Encounter/operational status. First click is ascending; another click on the same header reverses it. The active heading carries ^ or v plus an explicit direction label; the preset selector identifies header sorting. Choosing a preset restores its accepted ordering mode. Contact IDs, severity ordinal values, confidence and remaining seconds sort numerically; text uses case-insensitive ordering. Missing confidence/deadline values stay last in both directions. Equal keys use ascending numeric Contact ID regardless of direction. Only released public assessment/state and applicable configured deadlines are used, never private affiliation.

Existing TreeItem objects are reordered in place when the population is unchanged, preserving selected contact, native scroll offset and row navigation as intelligence updates arrive. All eighteen contacts remain scroll-accessible at the existing readable font size. The dedicated operations queue retains its previous filters/priority semantics; no opaque combined score is introduced.


## 24. Prototype 9 refinement ? cybersecurity defense integration

**Local implementation, pending owner acceptance.** F5 now opens `scene/cyber_command.tscn`, a thin inherited operations scene enabling the cyber controller. The original operational, orbital-command and standalone tactical entries remain runnable. This extends Prototype 9; it does not begin Prototype 10 or supersede accepted Git checkpoints.

### Authoritative catalog and schema

The owner selected `C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db` after comparison found older copies with the same counts but different content. The source is unchanged. `tools/export_cyber_catalog.py` opens SQLite in URI `mode=ro`, verifies integrity and relationships, and emits deterministic `data/cyber_catalog.json`. Godot needs no SQLite plugin or network connection. Re-export explicitly from the selected source after approved catalog changes; never maintain an independently invented attack/defense catalog.

The actual schema is:

| Table | Columns | Primary key |
| --- | --- | --- |
| attacks | ID INTEGER; attack_name TEXT NOT NULL; definition TEXT NOT NULL; difficulty TEXT NOT NULL; severity TEXT NOT NULL; priority_rank INTEGER NOT NULL | ID, autoincrement |
| defenses | ID INTEGER; defense_name TEXT NOT NULL; definition TEXT NOT NULL | ID, autoincrement |
| attack_defenses | ID INTEGER; attack_id INTEGER NOT NULL; defense_id INTEGER NOT NULL | ID, autoincrement |

There are 100 attacks, 185 defenses and 211 relationship rows. SQLite declares **no foreign keys** or unique attack/defense pair constraint. The exporter and Godot loader explicitly reject missing referenced IDs, duplicate IDs/pairs, unmapped attacks and empty definitions. Source SQL schema and SHA256 provenance accompany the export. Catalog severity/priority are catalog metadata, not verified contact intent or an official scoring input. A relationship records applicability, not guaranteed defense success.

### Five authored cyber encounters and reusable interfaces

`data/cyber_scenarios.json` assigns cyber capabilities to C-010 through C-014, using exact database attack IDs/names: 77 VIRUS, 64 WORM, 59 RANSOM, 2 ROOTKIT and 78 DDoS. C-015..C-018 retain their abstract operational responses. C-001/C-004/C-007 retain their accepted deterministic encounter rules, clocks and official mission scoring. No new countdown or official scoring participant is introduced.

A cyber capability does not rewrite P8 private affiliation or intentions. A peaceful probe can carry compromised software; observing containment does not prove deliberate hostile intent. Existing fallible reports, investigation follow-ups and supersession history remain intact. The cyber console distinguishes its initial cyber hypothesis and confidence from the latest released surveillance assessment. SIGINT, platform and trajectory observations are authored data; neither appearance nor investigation grants private truth.

Each validated scenario has stable scenario/contact IDs, a private attack ID, public assessment/confidence, three public source observations, authored environmental conditions, and three explicit response rules. Each rule references a real defense ID, the actual attack it applies against, required conditions, an observable result, finality and an educational explanation. `cyber_data.gd` validates references and schemas; `cyber_session.gd` evaluates private rules and returns an allowlisted public view. UI receives choice names/purposes from the exported defense entries, never hidden effectiveness or actual capability IDs.

Current outcomes are deterministic: contained, partial, ineffective, unverified/pending, or defensive disruption. These are fixture-specific results, not universal real-world product claims. Successful observed containment resolves the cyber operation; partial/failed/unverified/disruptive actions leave it escalated for further action. Each countermeasure can execute once per contact/session; redelivered request tokens return the same result. No random probability engine is implemented.

### Cyber defense versus kinetic interception

For the five cyber profiles, the tactical operations card opens three contextual database countermeasures and short purpose descriptions. Explicit operational escalation is required before execution. Continue monitoring and Hold fire remain separate decisions; operational confirmation/de-escalation remain available. The existing generic interceptor control routes to cyber choices for these profiles; direct attempts to use the wrong deployment channel are rejected and audited. Invalid cyber configuration produces an error rather than substituting generic catalog information.

Containment changes operational status visibly while the same spacecraft continues along the same path. It does not claim destruction, successful kinetic interception, physical damage or verified affiliation. Other abstract operational contacts retain the earlier authorization/execution/unverified-observation semantics. Original active encounters continue using their protected outcome model. Cyber actions generate operational records, **no official points**, and cannot change the original three first-resolution-official results.

### Timestamped accountability and stable identity

Existing session events remain authoritative. The operational event source captures a local ISO date-time with UTC offset and wall epoch, simulation elapsed time and public contact context at creation. A stable simulation-only event projection is retained for deterministic scheduling comparisons. The network history projects original public resolution receipts and canonical operational events once using source event IDs; screen refreshes do not emit actions.

History is accessible from both command levels and records contact, center, stable circular/elliptical path ID, assessment at decision, response, acceptance/rejection, disposition, observed outcome and remaining time when applicable. Wall decision time is distinct from paused simulation time. Original replay retains history and official scoring protections; new operational contacts remain session-final once resolved. Histories are in-session, not persistent save files.

Deadline synchronization still runs before original decisions: strictly positive remaining time permits an otherwise valid action; zero or negative expires first. Valid pre-expiry resolutions cannot subsequently become expiry outcomes. Closed clocks show time at acceptance. No new clock or orbital mechanics is introduced. Controlled tests preserve the same Node/contact/path across action and navigation; they do not reproduce the owner's original manual plane-change observation. Original discrete inward jumps remain intentional.

### Sorting, presentation and deferred work

The seven existing clickable strategic headers remain: contact ID, center, public assessment, confidence, ordinal severity, remaining deadline and operational state. First click ascending, second descending; missing confidence/deadlines last in either direction; ascending numeric ID breaks ties. Existing row objects retain selection/scroll/navigation. Sorting never uses hidden truth or catalog severity as a contact classification.

The 1600 ? 900 cyber detail view uses a scrollable evidence/history column and three readable purpose/response blocks, a prominent immediate receipt and separate operational controls. The orbit scene, mission panel, stationary console and DATA target are unchanged. A network history modal provides the audit record without crowding orbital input.

Deferred: balancing and expert review of authored efficacy, additional attack profiles, formal independent verification/disclosure policy, persistent event storage, cyber replay controls, real financial/resource/damage effects and any integration with official scoring. These require separate approval. No combat physics, ammunition system, staffing redesign, database technology choice for learning systems or educational-provider integration is implemented here.


## 25. Prototype 9 ? four command pages and multi-threat assessment

**Implemented locally for owner review, not checkpointed.** F5 now uses `scene/decision_command.tscn`, a thin inherited cyber-command scene with the four-page presentation enabled. Earlier command entries and the standalone tactical scene remain available for compatibility. Sections 23?24 describe the preceding P9 layers; this section supplies the current information architecture without changing their simulation rules.

### Command pages and navigation

1. **Command Overview** retains the original eighteen-contact table, seven clickable sort keys and stable row identity. A concise attention column distinguishes imminent deadline review, assessed concern and routine monitoring; it is not an opaque combined threat score. Selecting a row opens that contact's decision page. Center cards still open the orbiting tactical view.
2. **Threat Assessment & Response** is the principal decision page: physical-weapon suspicion, three separate cyber hypotheses, a public advisory recommendation, and fixed action controls. Detailed reports are not duplicated here. The selected hypothesis opens its applicable database defenses. Orbital view, existing operational escalation controls and detailed analysis remain accessible.
3. **Intelligence Analysis** retains complete source text, initial encounter/cyber briefs, follow-ups, confidence, payload estimates, advisory options, supersession links and the investigation/evidence-at-escalation snapshot. Sources are grouped by type, with receipt chronology within each group. A source filter reduces reading without deleting records.
4. **After-Action & Decision History** projects the existing canonical events plus received public reports and issued advisory recommendations. Filters select one contact or the entire network. Report supersession is annotated from current public history; the original receipt event is not rewritten.

The persistent navigation preserves contact/center/path selection. Top-level role, Learning/Challenge controls and scorecard remain accessible. Detailed pages replace the crowded side-panel view while open, rather than permanently obscuring the orbital display; the orbital tactical view remains available. Each long-information area has a single scroll container, with actions outside the scroll. Simulation continues according to the accepted mode; navigation does not pause or reset it.

### Public multi-threat model

`data/decision_assessments.json` is a separate, validated **public assessment** configuration covering all eighteen contacts. It contains one physical assessment (suspected, not currently suspected, or unknown), three unique v12 attack references, independent likelihood estimates or null/Unknown, supporting evidence, asset at risk, and an advisory recommendation/rationale/confidence. All numerical values in this file are explicit authored analyst estimates, not calculated probabilities or confidence inferred from severity. Background comparisons with no supporting evidence use Unknown. A contact can have multiple suspected capabilities; the estimates are not normalized and may exceed 100% in total.

Examples: C-011 has a 55% physical-weapon suspicion based on an ambiguous instrument boom, while WORM (60%), DDoS (35%) and VIRUS (Unknown) coexist as cyber hypotheses. This does **not** add a real weapon to the hidden scenario. C-010 has VIRUS 72%, WORM 46%, RANSOM 28%, demonstrating nonexclusive estimates. C-012's physical assessment is currently negative at 65% confidence, not proof that no weapon exists. Authored recommendations use public observations only and execute nothing automatically.

Attack names, definitions and severity-if-present come from the unchanged v12 export. Catalog severity is not evidence of possession or a likelihood estimate. The five private cyber capabilities, their authored conditions/effectiveness rules, original encounter truths and P8 affiliations remain unchanged. No hidden multi-payload or physical-weapon simulation is added.

### Response availability and confirmation

Three suspected attacks are distinct from three defensive responses. The decision model joins the selected public attack ID through exported `attack_defenses` to exact database defense names/purposes. Mapped defenses not in the contact's existing validated scenario response list are **INFORMATIONAL ONLY**. Validated options explicitly show whether escalation is required, execution is available, or the response was already issued. Inspection explains purpose, suspected attack addressed, uncertainty, possible consequence classes and limitations before confirmation. No database mapping creates a new effectiveness rule. All fifteen original validated choices remain reachable through the five contacts' public hypotheses, including ROOTKIT's authored Antivirus alternative via its VIRUS hypothesis.

Only the existing evaluator may execute a cyber response. Original active encounters retain their accepted abstract signal-interference defense and authoritative deadline check; the confirmation labels that legacy response honestly rather than pretending it is a new database choice. Existing abstract interception remains available only where the operational model already supports it; authorization/execution does not claim verified interception. Physical or coordinated defense without a matching existing evaluator is a non-executable proposal. Continue monitoring and request-more-intelligence remain deliberate alternatives, with the accepted investigation capacity and timing. Hold-fire/release/replay remain in their existing operational/tactical controls.

### Intelligence timestamps and auditable receipt history

The previous action ledger already timestamped decisions, but source intelligence records did not capture receipt wall times. In the new normal entry, `intelligence_session.gd` captures actual local receipt time with UTC offset, wall epoch, authoritative network simulation elapsed time and contact movement progression where available, then emits a public report-received event. Metadata is allowlisted; hidden fixtures remain excluded. Observation timestamps are shown only when supplied, otherwise explicitly unavailable. Receipt time is not misrepresented as the time of observation or original authorship.

New operational reports receive their own current receipt timestamp, even if derived from an earlier report. Superseded records retain their original receipt metadata and text; views show newer report ID/time separately. Initial static briefs and historical records without wall time are labeled unavailable. Original immediate follow-up receipt time is taken from its existing timestamped investigation receipt, not invented. Learning strategic pause holds simulation time, not the host wall clock. It prevents autonomous scheduled release as before; explicit authored follow-up behavior remains accepted. Active Challenge continues timing across pages and centers.

Report events and recommendations are recorded once at receipt/issuance, not page opening. Stable report-event sequence IDs distinguish replayed receipt episodes without duplicate UI-generated events. The network journal remains a projection of authoritative report/action sources. Chronological append sequence breaks ties; recommendations, accepted/rejected commands, cyber results, unresolved dispositions and expirations do not generate new points. All accepted mission scoring, replay protection, movement, hover-freeze, contact counts and deadline rules remain unchanged.

Deferred review: owner validation of authored public confidence/evidence and recommendation wording; whether a later dynamic assessment should revise the public multi-threat briefing; richer report filters; any future real multi-payload/coordinated-defense simulation. These are not implemented by this presentation refinement. No Prototype 10, combat engine, physical weapon, extra private payload, scoring redesign or educational-provider integration is authorized here.


## 26. Prototype 10, Stage 1 ? sliding command interface

**Implemented locally for owner visual review; no new checkpoint.** The accepted Prototype 9 commit/tag remains `1e9700b4de32d583fbcd41c329d394797f8e91d9` / `planetary-prototype9-cyber-command-v1`. Development is on `feature/prototype10-sliding-command-ui`. The two local P9 Git checkpoint audit reports remain unchanged and untracked. Stage 1 is presentation only; it is not authorization for Stage 2.

### Orbital centerpiece and reusable presentation

F5 opens `scene/sliding_command.tscn`, a thin inherited P9 decision-command scene. The optional `sliding_command_enabled` switch installs `sliding_command_ui.gd`, a presentation adapter inheriting the accepted P9 public assessment/report/history and confirmation behavior. Earlier scene entries keep their accepted presentation for regression compatibility. There is still one reusable tactical scene per center, eighteen monitored contacts and the same three official mission participants.

The initial view shows orbital traffic, the unchanged DATA asset/value, a compact top command strip, applicable deadline labels at the upper-right margin and a bottom quick-action strip. The large permanent mission/operations/intelligence cards are suppressed after their controllers refresh, without disabling those controllers or removing records. Center, contact Nodes, transforms, ring geometry, angular speeds, hover/click signals and countdown state are never resized, reparented or recreated by panel navigation.

### Compact controls and sliding overlays

Native text-symbol command icons provide Overview, Contacts, Threat Assessment, Intelligence, History, Mission Status and Alerts with readable tooltips and active-state indication. Center selection, Learning/Challenge mode, explicit strategic pause and command responsibility remain available. Overview resets display filters to the full network; it does not reset contacts or encounter state. Mission Status opens the existing confirmed scorecard, not a new scoring model. Alerts use only applicable public deadline urgency/expiry, never private affiliation or an invented combined threat score.

The left Contacts panel supports all eighteen contacts, center/status display filters, stable selection, and the original seven sorting keys (ID, center, public assessment, confidence, ordinal severity, remaining deadline and operational state). Column order puts severity/confidence/deadline first; horizontal scrolling exposes longer assessment/state details at readable type size. Missing confidence/deadlines retain the accepted explicit handling. The filters affect only which rows are displayed. No confidence slider or confidence mutation is added.

The right Threat Assessment panel shows selected ID/center, operational status, physical suspicion/confidence, all three independent cyber hypotheses with catalog severity and concise supporting evidence, and the existing advisory recommendation/rationale/confidence. Long text is summarized for the panel; full originals and full public hypothesis details remain in Intelligence. Assessment and Countermeasures views separate suspected capabilities from response choices. Fixed action controls open existing investigation, cyber-response, physical-review, monitoring, coordinated-proposal and operational-confirmation workflows. Original active encounters retain explicit hold-fire and practice-replay review controls. Unsupported proposals remain non-executable; opening a view never authorizes a response.

The bottom drawer provides Intelligence and History tabs, source or contact/network filters, real date-time and simulation metadata, complete report/brief contents, supersession history and original after-action results. Its maximum height is 380 reference pixels, with one internal scrolling region. No source report is rewritten or deleted to simplify the display. The quick-action strip opens these same workflows rather than bypassing validation or escalation.

### Overlay, pin and timing policy

Panels animate for 0.18 seconds with a short ease-out slide. Normally opening one large panel closes the previous unpinned panel. There is at most **one pinned panel**; pinning another replaces the previous pin and closes the no-longer-protected panel when needed. A pinned side panel and opposite side panel use separate edge regions. A drawer sharing the view with a side panel narrows to the remaining region, avoiding overlapping command controls. The orbital viewport and simulation transform remain unchanged. Top controls, deadlines, bottom quick actions, pin and close controls remain accessible.

Close explicitly closes/unpins its panel. Escape closes the active unpinned panel; a pinned panel stays open. Escape cancels an active confirmation before closing a panel. Selection, investigations, ledger history and applicable deadlines survive every open/close. Panel animations do not create timers for the simulation, pause it, or add catch-up. Accepted Learning strategic pause and contact-specific hover-freeze continue to govern their original state. Challenge continues while reading panels or viewing another center.

### Preserved rules and review limits

The v12 database/export, existing public assessments, five private cyber capabilities/effectiveness rules, abstract physical response semantics, original encounter outcomes, official scoring, timestamps and event deduplication are unchanged. Stage 1 adds no combat, staffing, resource, score or probability model. Temporary native letter/symbol icons and the written dark blue-gray design direction are used; no external dependencies or unlicensed artwork are added. Approved mockup files were not available in the project during this implementation; visual fidelity to those specific images remains an owner-review item.

Remaining review items: preferred final icon artwork, panel density and contact-table column widths, the single-pin policy, whether additional compact mission summaries are desirable, and further adaptation beyond the 1600 ? 900 reference viewport. These are UI refinement proposals only, not Stage 2 authorization.
