# Learning content retrofit ? input reconciliation preflight

Date: 2026-10-27T15:06:55.638784-07:00

This is a preflight finding, not completion of Phase A or technical approval of content. No learning content, game code, scoring, timing, database IDs, database rows, or runtime catalog were changed. No Git publication operations occurred.

## Source identity conflict

Supplied draft: C:\Users\azwam\Projects\planetary-attacker-defender\cyber_100_attacks_learning_draft.db

Existing game source: C:\Users\azwam\Projects\cyber_defensev12\data\cyber.db

Both have 100 attacks, 185 defenses and 211 mappings, but their numeric ID namespaces differ: 98 attack IDs and 183 defense IDs identify different names. Draft attack 1 is REF DDoS; game attack 1 is VM ESC. Draft exemplar 21 is OFF CRACK; game attack 21 is ENVIRO. The draft original tables also omit the v12 severity and priority_rank columns.

Exact name matching provides 100/100 attack and 179/185 defense correspondences. After that crosswalk, 205/211 mapping pairs match existing game mappings. Unresolved correspondences: 12. These are correspondence checks, not judgments of technical mapping effectiveness.

## Proposed preservation policy ? not applied

Retain current game's v12 IDs as runtime identifiers; preserve supplied draft IDs as separately named provenance identifiers. Use the explicit one-to-one crosswalk when preparing editorial overlays. Never join these sources directly on bare numeric ID. Do not renumber original tables or alter mappings. Owner confirmation is needed because the assignment names the draft password exemplars by the older IDs while requesting stable authoritative identifiers.

Machine-readable evidence: Learning_Content_ID_Reconciliation_2026-10-27_150655.json

## Phase A scope remaining

100 attack editorial reviews, 185 substantive defense expansions, and 211 individual technical mapping judgments remain to be performed after identifier policy is confirmed. Nothing has been marked approved. Phase B remains gated on owner review of Phase A.

## Preservation checks

Input SHA-256 values:

- C:\Users\azwam\Projects\planetary-attacker-defender\cyber_100_attacks_learning_draft.db: `73ba2ab75cddad7213d1ca0c1c27ceadec4ea2d90720799b3d4ed23b628701ec`
- C:\Users\azwam\Projects\cyber_defensev12\data\cyber.db: `22867011a01db80a8766e7320d58aece09373f783a06700a97197c254eb6a871`
- C:\Users\azwam\Projects\planetary-attacker-defender\data\cyber_catalog.json: `8a09c8a396f384371376a07c84b89862392f983eb528542f301ee874d6a2eb57`

All three hashes were verified unchanged after read-only SQLite inspection. The supplied draft remains untracked and untouched. The only new project files from this preflight are this report and its JSON crosswalk.

## Further reconciliation ? explicit aliases proposed, not applied

All 100 attack names match exactly. Six defense names differ in wording. The following explicit proposed aliases complete a one-to-one 185-defense and 211-mapping correspondence; the JSON retains both the initial exact-match evidence and a separate proposed crosswalk. This does not authorize changing any ID or mapping.

- Draft defense 108 (Exec Training) -> v12 defense 118 (Executive Training).
- Draft defense 121 (Web Filter) -> v12 defense 133 (Web Filtering).
- Draft defense 134 (Firewall) -> v12 defense 112 (Firewalls).
- Draft defense 137 (Allow Listing) -> v12 defense 136 (Allowlisting).
- Draft defense 144 (Sink Holing) -> v12 defense 124 (Sinkholing).
- Draft defense 158 (Disable NT LAN Manager) -> v12 defense 125 (Disable NTLM).

No numeric join has been applied, no content has been promoted, and no runtime files have been changed. Owner confirmation of canonical identifier policy remains necessary.
