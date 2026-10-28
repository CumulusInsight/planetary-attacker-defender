# Complete learning-content candidate — owner review book

**Not production-approved.** All 100 attacks, 185 defenses and 211 mapping pairs have an authored editorial candidate. Counts and validation do not constitute owner or independent SME approval.

Canonical IDs below belong to the existing v12 database. Draft IDs are provenance only. Original tables and mappings are unchanged. The three REMOVE_PROPOSED edges remain authoritative until the owner decides otherwise.

The book intentionally shows answer keys for editorial review. In-game keys and reasoning are gated until submission/evaluation. Original draft identification questions have been converted into scenario-specific countermeasure questions for the existing defense-selection game; their before/after values remain in the machine-readable report.

## Scope exceptions requiring particular attention

- Chosen-plaintext cryptanalysis has only the broad Secure Change mapping. Its question explicitly tests governed migration, not a claim that change management supplies cryptographic security.
- Broad categories (cloud, serverless, OT, Kubernetes, DNS, quantum and environmental topics) name a concrete scenario rather than pretend each is one discrete attack.
- Bloatware and advertising software are not automatically malware; packet capture and wardriving may be legitimate authorized work.
- Source verification, Tokens, Strong Hashing, Encrypted RFID, Secure DNS and Pod Policies require the narrower interpretations recorded in their individual reviews.
- Generic assurance controls such as education, monitoring, audits and assessments are not prevention guarantees. Backups support recovery, not prevention of ransomware or radio jamming.
- Distractors are curated and never include another authoritative mapped defense. Scenario-specific best-answer fairness still requires human play review; an unmapped control is not universally useless.
- No field remains a source-preserving placeholder. All candidate content, including the eight rewritten password lessons, remains unaccepted; no production approval has been inferred.

## Attack lessons

### 1. Virtual-machine escape

Draft provenance ID: 8. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A guest workload exploits a hypervisor or virtual-device weakness to cross into host or other guest security domains.

**Scenario question:** An exposed virtual device has a published guest-to-host flaw. Which program of host patching, interface reduction and secure configuration addresses the virtualization boundary?

1. Hypervisor hardening — canonical defense 1
2. Security-Enhanced Linux (SELinux) — canonical defense 114
3. Kernel resource namespaces — canonical defense 115
4. Least privilege — canonical defense 50

**Designated answer:** Hypervisor hardening

**Explanation and reasoning:** Hypervisor hardening reduces vulnerable management and emulation surfaces and applies relevant fixes. Guest isolation depends on the hypervisor, host and configuration, so guest antivirus alone is insufficient. A hardened host can still have unknown flaws and needs monitoring and recovery planning.

**Why the other offered options do not meet the scenario:** Container mandatory policy, resource namespaces and least privilege do not themselves patch a vulnerable virtual-device implementation in a hypervisor.

**Distinct realistic example:** A malicious workload uses a vulnerable emulated controller to execute outside its assigned virtual machine.

### 2. Rootkit

Draft provenance ID: 17. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Software or firmware that hides malicious activity by altering privileged operating-system, boot or hardware behavior. It may also provide persistence.

**Scenario question:** A defender wants an independent alert when protected system files differ from a trusted baseline. Which control supplies that comparison?

1. File and system integrity monitoring — canonical defense 2
2. Process memory inspection — canonical defense 4
3. Endpoint detection and response (EDR) — canonical defense 134
4. Independent code review — canonical defense 47

**Designated answer:** File and system integrity monitoring

**Explanation and reasoning:** Integrity monitoring detects unexpected changes against a baseline that the attacker cannot simply rewrite. A rootkit may lie to tools running inside the compromised system, so offline or hardware-supported verification may be needed. Detection does not itself remove the implant.

**Why the other offered options do not meet the scenario:** Memory inspection, endpoint response and source review do not supply the specifically requested trusted file-state comparison.

**Distinct realistic example:** A kernel module conceals files and network connections from normal administration tools.

### 3. Fileless or memory-resident malware

Draft provenance ID: 18. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malicious activity that relies heavily on memory and legitimate tools, reducing conventional executable-file artifacts. It can still leave logs, registry entries or disk traces.

**Scenario question:** A suspicious script injects code into a live process, but no executable file is available. Which inspection method examines the active process contents?

1. Process memory inspection — canonical defense 4
2. File and system integrity monitoring — canonical defense 2
3. Antivirus protection — canonical defense 138
4. Behavior-based threat detection — canonical defense 137

**Designated answer:** Process memory inspection

**Explanation and reasoning:** Memory inspection can reveal injected code, credentials or execution state unavailable to a file-only scanner. Protected processes, rapid execution and tool visibility limit coverage. Behavioral telemetry and response capability complement it; fileless does not mean forensically invisible.

**Why the other offered options do not meet the scenario:** File integrity comparison, antivirus as a product class and behavior detection do not specify the requested direct inspection of active memory contents.

**Distinct realistic example:** A script interpreter retrieves code into memory and maintains persistence through a scheduled task.

### 4. Reflected distributed denial of service

Draft provenance ID: 1. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A flood in which requests carrying a forged victim source address cause third-party servers to send their replies to the victim. Large replies can amplify the traffic.

**Scenario question:** Your network is sending UDP requests with source addresses that do not belong to it. Which source-network control stops those forged requests before they reach reflectors?

1. Source verification — canonical defense 6
2. Upstream DDoS scrubbing — canonical defense 140
3. Network traffic analysis — canonical defense 141
4. Network firewall rules — canonical defense 59

**Designated answer:** Source verification

**Explanation and reasoning:** Validate packet source addresses at the sending network boundary. This removes a prerequisite for spoofed reflection from that network. Here source verification means network ingress/egress anti-spoofing, not checking an email sender. The victim still needs upstream capacity and mitigation against traffic originating elsewhere.

**Why the other offered options do not meet the scenario:** Scrubbing treats arriving floods, traffic analysis diagnoses patterns, and firewall rules without source-validation logic do not establish the claimed origin.

**Distinct realistic example:** A gaming service receives unsolicited time-server replies from thousands of systems although it sent no requests.

### 5. Replay of authentication material

Draft provenance ID: 15. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reuse of captured authentication messages or credentials to obtain access. Reusable passwords, challenge responses and session tokens require different replay defenses.

**Scenario question:** A device protocol accepts the same captured signed login response twice. Which design binds responses to a fresh server challenge?

1. Authenticated nonces and freshness checks — canonical defense 8
2. Authenticated timestamps and freshness windows — canonical defense 83
3. Authenticated sequence numbers — canonical defense 81
4. Multi-factor authentication (MFA) — canonical defense 70

**Designated answer:** Authenticated nonces and freshness checks

**Explanation and reasoning:** A unique unpredictable challenge, authenticated as part of the response and checked for one-time use, can prevent reuse in that protocol. Merely adding a random field without checking freshness does not work. Static stolen passwords remain reusable unless authentication design changes.

**Why the other offered options do not meet the scenario:** Time windows and ordered counters are different freshness designs; MFA alone does not bind this response to a fresh random challenge.

**Distinct realistic example:** A recorded badge-system authentication exchange opens a door again because freshness is not verified.

### 6. Cloud-resource misconfiguration

Draft provenance ID: 22. Topic type: weakness. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A deployment or permission error that exposes a cloud resource or grants excessive access. It is a weakness category, not a single attack technique.

**Scenario question:** A storage bucket accidentally permits public reads. Which listed assurance activity can discover and verify that exposure before deployment approval?

1. Security configuration and access audits — canonical defense 9
2. Least privilege — canonical defense 50
3. Identity and access management (IAM) — canonical defense 60
4. Resource access controls — canonical defense 48

**Designated answer:** Security configuration and access audits

**Explanation and reasoning:** Configuration audits can detect public policies, excessive permissions and missing safeguards. The actual corrective action is to remove unintended public access and verify effective permissions. Encryption at rest does not help when the service legitimately decrypts data for an anonymous reader.

**Why the other offered options do not meet the scenario:** Privilege and access mechanisms can enforce a correction, but the requested activity is finding and verifying the configuration exposure.

**Distinct realistic example:** An access-policy template makes a confidential document store publicly downloadable.

### 7. WEP wireless-key recovery

Draft provenance ID: 7. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Recovery of a key or injection capability against obsolete Wired Equivalent Privacy, whose design has weaknesses that cannot be repaired with a longer Wi-Fi password alone.

**Scenario question:** A warehouse still uses WEP and can replace its access points and clients. Which listed migration removes WEP rather than merely hiding the network?

1. Migration from WEP to supported WPA3 — canonical defense 11
2. Suppress network-name advertisement — canonical defense 179
3. MAC-address filtering — canonical defense 74
4. Credential and key rotation — canonical defense 185

**Designated answer:** Migration from WEP to supported WPA3

**Explanation and reasoning:** Move to a properly configured supported WPA3 deployment when clients allow it; remove WEP entirely. Compatibility may require an assessed WPA2-AES interim design. WPA3 is not a promise against jamming, compromised clients or every implementation flaw.

**Why the other offered options do not meet the scenario:** Hidden network names, MAC filters and rotating a WEP key do not repair the WEP protocol design.

**Distinct realistic example:** A retired scanner forces an entire wireless segment to use WEP despite newer client devices.

### 8. Offline password cracking

Draft provenance ID: 21. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Testing candidate passwords against stolen password-verification data on an attacker-controlled system outside the original login service.

**Scenario question:** A password database was stolen, so online lockouts cannot slow the attacker. Which listed storage practice raises the computational cost of each offline guess?

1. Cost-tuned password hashing — canonical defense 12
2. Account lockouts and progressive login restrictions — canonical defense 79
3. CAPTCHA and automation challenges — canonical defense 80
4. Correlated failed-login monitoring — canonical defense 69

**Designated answer:** Cost-tuned password hashing

**Explanation and reasoning:** Use a suitable salted, cost-tuned password-hashing function such as an approved memory-hard password KDF. Unique salts defeat reusable precomputation; work factors make guesses expensive. Ordinary fast hashes and composition rules alone are insufficient. The attacker can keep working without contacting the login service.

**Why the other offered options do not meet the scenario:** Account lockouts, CAPTCHA and login telemetry affect online access; they do not meter calculations against a stolen copy.

**Distinct realistic example:** An intruder tests candidate passwords against a copied user database on a separate workstation.

### 9. Spyware

Draft provenance ID: 14. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Software that covertly collects activity, personal information or device data without appropriate authorization or meaningful consent.

**Scenario question:** An endpoint tool identifies a known unauthorized surveillance program. Which listed tool family is intended to detect and remove that software?

1. Anti-spyware protection — canonical defense 13
2. Browser advertising blockers — canonical defense 39
3. Application allowlisting — canonical defense 136
4. Clean system rebuilding — canonical defense 36

**Designated answer:** Anti-spyware protection

**Explanation and reasoning:** Anti-spyware controls can identify known surveillance software and suspicious behavior, then quarantine or remove it. Detection depends on visibility, updates and attacker technique. Permissions review limits exposure but does not reliably remove an already privileged infection.

**Why the other offered options do not meet the scenario:** Ad filtering and execution policy reduce selected exposure paths, while rebuilding replaces system state; none is the requested surveillance-software detection and quarantine tool.

**Distinct realistic example:** An unauthorized application captures browsing activity and sends it to an external operator.

### 10. Shared-cloud side-channel leakage

Draft provenance ID: 6. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An attempt to infer another workload's information from shared hardware behavior such as cache timing. Co-location alone does not prove a leak.

**Scenario question:** Sensitive computations leak timing information to another tenant on the same host. Which hosting choice reduces cross-tenant hardware sharing most directly?

1. Dedicated cloud hosting resources — canonical defense 15
2. Role-based access control (RBAC) — canonical defense 127
3. Virtual private network (VPN) — canonical defense 145
4. Credential and key rotation — canonical defense 185

**Designated answer:** Dedicated cloud hosting resources

**Explanation and reasoning:** Dedicated hardware placement can reduce exposure to an untrusted co-tenant sharing the affected resource. Confirm the provider's actual isolation guarantees; a dedicated virtual instance is not necessarily a dedicated physical host. Vulnerable code and other side channels still require mitigation.

**Why the other offered options do not meet the scenario:** Role permissions, a network VPN and key rotation do not remove shared-cache co-residency.

**Distinct realistic example:** A tenant measures cache behavior to infer activity in a neighboring virtual machine.

### 11. Padding-oracle attack

Draft provenance ID: 2. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An attacker learns about decrypted data by making adaptive ciphertext queries to a service whose padding errors or response timing reveal information.

**Scenario question:** A service returns different errors for altered encrypted cookies and reveals whether their padding is valid. Which redesign supplies confidentiality and integrity together?

1. Authenticated encryption with associated data (AEAD) — canonical defense 16
2. SHA-3 hashing — canonical defense 94
3. HTTP Strict Transport Security (HSTS) — canonical defense 72
4. Credential and key rotation — canonical defense 185

**Designated answer:** Authenticated encryption with associated data (AEAD)

**Explanation and reasoning:** Authenticated encryption checks ciphertext integrity and rejects tampering before revealing decrypted application data. Correct nonce handling, key management and uniform failures remain necessary. Merely changing an error message can leave a timing oracle; replacing the vulnerable construction is the important change.

**Why the other offered options do not meet the scenario:** An unkeyed hash is not a substitute for authenticated encryption; HTTPS enforcement and rotating keys do not repair the vulnerable cookie construction.

**Distinct realistic example:** A legacy encrypted session token can be manipulated because its server distinguishes invalid padding from invalid content.

### 12. Chosen-plaintext cryptanalysis

Draft provenance ID: 3. Topic type: analysis_model. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An analysis setting in which an adversary can obtain encryptions of chosen messages and try to learn secrets from the resulting ciphertexts. Sound modern encryption is designed for this exposure.

**Scenario question:** A reviewed analysis shows that a proprietary cipher leaks its key when outsiders encrypt chosen inputs. Which catalog practice organizes a tested migration away from that broken cipher?

1. Controlled security change — canonical defense 17
2. Adequate cryptographic output length — canonical defense 95
3. Credential and key rotation — canonical defense 185
4. SHA-3 hashing — canonical defense 94

**Designated answer:** Controlled security change

**Explanation and reasoning:** A controlled security change can replace the broken construction, migrate keys and data, test interoperability and provide rollback. Change management is supporting work, not a mathematical defense against chosen-plaintext analysis. The replacement must be an appropriate, reviewed cryptographic scheme with correct mode and nonce use.

**Why the other offered options do not meet the scenario:** Longer output, routine key rotation and an unrelated hash do not establish security for the existing cipher. This question deliberately asks about migration governance, not a cryptographic guarantee.

**Distinct realistic example:** A researcher submits selected records to an encryption API and demonstrates patterns caused by a defective design.

### 13. Wireless radio-frequency jamming

Draft provenance ID: 19. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Intentional radio interference that degrades communication availability rather than decrypting traffic. Ordinary interference must be distinguished from an attack.

**Scenario question:** A supported radio system can change among authorized channels to reduce narrow-band interference. Which mechanism provides that channel agility?

1. Radio frequency hopping — canonical defense 18
2. Authenticated data encryption — canonical defense 10
3. Configured WPA3 wireless security — canonical defense 61
4. MAC-address filtering — canonical defense 74

**Designated answer:** Radio frequency hopping

**Explanation and reasoning:** Frequency hopping may improve resilience when interference covers only some frequencies and both endpoints support the scheme. It cannot guarantee service against wideband or sufficiently strong jamming. Spectrum regulations, detection and alternate communication paths matter.

**Why the other offered options do not meet the scenario:** Encryption, WPA3 authentication and MAC filtering do not remove interfering radio energy or provide the specified channel hopping.

**Distinct realistic example:** A control link loses packets near a continuously transmitting interferer on its current channel.

### 14. Bluetooth bluesnarfing

Draft provenance ID: 4. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Unauthorized retrieval of data over Bluetooth, usually by exploiting a vulnerable service or insecure pairing rather than merely detecting the radio.

**Scenario question:** An older handset must keep Bluetooth available but should stop advertising itself to casual nearby discovery. Which setting reduces discoverability without claiming to fix its vulnerable service?

1. Disable Bluetooth discoverability — canonical defense 20
2. Disable unused Bluetooth — canonical defense 38
3. Device firmware security updates — canonical defense 62
4. Privacy and permission settings — canonical defense 14

**Designated answer:** Disable Bluetooth discoverability

**Explanation and reasoning:** Disabling discoverability reduces easy discovery during routine scanning. It does not make the address secret or block an attacker who already knows it. Patch the handset, restrict profiles and pairing, or disable Bluetooth when it is not needed to address the actual access path.

**Why the other offered options do not meet the scenario:** Turning Bluetooth off violates the requirement to keep approved connections available; firmware updates and application privacy permissions do not select the requested discovery setting.

**Distinct realistic example:** An obsolete phone exposes an address book through a poorly protected Bluetooth profile.

### 15. Voice phishing

Draft provenance ID: 10. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A deceptive voice conversation that pressures someone to reveal information, authorize a transaction or install software. Caller ID is not proof of identity.

**Scenario question:** A caller claiming to be IT asks for your sign-in code. Which action checks the claim without using contact details supplied by that caller?

1. Independent callback verification — canonical defense 21
2. Challenge-response authentication — canonical defense 23
3. Multi-factor authentication (MFA) — canonical defense 70
4. Message-sender verification — canonical defense 130

**Designated answer:** Independent callback verification

**Explanation and reasoning:** End the call and verify through an independently obtained internal number or approved directory. Even an encrypted call can carry a fraudulent request. Never share authentication codes simply because a voice sounds familiar or a displayed number appears correct.

**Why the other offered options do not meet the scenario:** A challenge protocol, additional sign-in factor and email-sender check are not the specified independent telephone callback.

**Distinct realistic example:** An automated bank call tells a customer to transfer savings into a purported safe account.

### 16. Pretexting

Draft provenance ID: 11. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Manipulation through a fabricated role, story or situation that makes a request seem legitimate. The channel may be voice, email or in-person contact.

**Scenario question:** A supposed contractor asks for a restricted document. Your organization has a verified identity challenge process. Which control checks the requester before release?

1. Challenge-response authentication — canonical defense 23
2. Social-engineering response training — canonical defense 97
3. Restricted access to sensitive information — canonical defense 120
4. Privacy and permission settings — canonical defense 14

**Designated answer:** Challenge-response authentication

**Explanation and reasoning:** Use an established challenge-and-response process that proves access to an approved identity factor or trusted channel. Public biographical questions are weak challenges and can be researched. Verification does not replace checking whether that verified person is authorized to receive the document.

**Why the other offered options do not meet the scenario:** Training, data restrictions and privacy permissions do not perform a fresh identity challenge against the requester.

**Distinct realistic example:** A visitor claims to be an auditor and asks a receptionist for an employee list.

### 17. Forged authentication request

Draft provenance ID: 25. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A fabricated or altered authentication-related message intended to be accepted as genuine. The source label is broad, so the protocol and violated checks must be stated.

**Scenario question:** A service accepts a login assertion without verifying its issuer or signature. Which security check must establish the assertion's authenticity before a session is granted?

1. Authentication assertion checks — canonical defense 26
2. Identity proofing and verification — canonical defense 166
3. Multi-factor authentication (MFA) — canonical defense 70
4. Request-bound anti-CSRF tokens — canonical defense 84

**Designated answer:** Authentication assertion checks

**Explanation and reasoning:** Verify the assertion using the expected issuer, audience, signature, freshness and applicable protocol rules. Syntactically valid input is not necessarily authenticated. This scenario is about forged authentication evidence, distinct from CSRF or a verified user's authorization to perform an action.

**Why the other offered options do not meet the scenario:** Claimant proofing, extra sign-in factors and anti-CSRF values do not verify this assertion's issuer, signature and audience.

**Distinct realistic example:** A fabricated identity token claims administrator status because the relying party never verifies its signature.

### 18. Brand impersonation

Draft provenance ID: 24. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Use of a trusted organization's identity, look or messaging to deceive people. It can occur through sites, ads, messages or phone calls.

**Scenario question:** Fraudulent sites copy your brand, and the security team needs to discover new imitations promptly. Which ongoing activity supports detection and takedown?

1. Operational security monitoring — canonical defense 27
2. Email threat filtering — canonical defense 150
3. Domain-based Message Authentication, Reporting and Conformance (DMARC) — canonical defense 116
4. Browser typo and look-alike warnings — canonical defense 174

**Designated answer:** Operational security monitoring

**Explanation and reasoning:** Monitoring relevant domains, advertisements and abuse reports can reveal impersonation. Confirm findings before takedown and preserve evidence. Recognition training helps users but does not automatically discover every copied site; brand familiarity is not authentication.

**Why the other offered options do not meet the scenario:** Mail filtering and domain email policy cover messaging, while browser typo alerts act during navigation rather than discover copied advertisements and sites.

**Distinct realistic example:** A fake delivery-company website asks customers to pay a redelivery charge.

### 19. Dumpster diving for information

Draft provenance ID: 12. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Recovering sensitive material from discarded paper, storage media or equipment without authorized access to its contents.

**Scenario question:** Payroll documents are leaving the office as readable paper waste. Which action makes those documents difficult to reconstruct before disposal?

1. Secure paper shredding — canonical defense 29
2. Privacy policies and handling rules — canonical defense 24
3. Resource access controls — canonical defense 48
4. Clean system rebuilding — canonical defense 36

**Designated answer:** Secure paper shredding

**Explanation and reasoning:** Appropriate shredding or secure destruction reduces recoverability of paper records before waste leaves controlled custody. Media need destruction or sanitization appropriate to their technology. Locked bins help custody but do not destroy information after collection.

**Why the other offered options do not meet the scenario:** Handling rules and access permissions do not destroy paper; reinstalling a computer addresses a different disposal medium.

**Distinct realistic example:** A discarded printer contains a storage device holding previously scanned contracts.

### 20. Shoulder surfing

Draft provenance ID: 13. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Obtaining information by watching a screen, keyboard or other user interaction, directly or through a camera.

**Scenario question:** A train passenger can read a colleague's screen from the side. Which control narrows the screen's viewing angle?

1. Screen privacy filters — canonical defense 31
2. On-screen virtual keyboards — canonical defense 75
3. Session expiration and idle timeouts — canonical defense 52
4. Restricted access to sensitive information — canonical defense 120

**Designated answer:** Screen privacy filters

**Explanation and reasoning:** A privacy filter reduces off-axis screen readability. It cannot stop a camera positioned directly behind the user or prevent observation of keyboard entry. Seating, awareness and minimizing sensitive work in public remain relevant. Recorded video can also be reviewed later, so the absence of a person immediately nearby does not eliminate observation risk.

**Why the other offered options do not meet the scenario:** On-screen input, session expiration and limited data access do not narrow the viewing angle of an active display.

**Distinct realistic example:** A camera above a service desk records PIN entry despite a secure network connection.

### 21. Environmental disruption of computing

Draft provenance ID: 20. Topic type: environmental_threat. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Loss or manipulation of physical conditions such as cooling, power or humidity that harms computing operations. It can be accidental or deliberate.

**Scenario question:** A server room is overheating and staff need an early measured warning. Which control detects the physical condition?

1. Environmental monitoring sensors — canonical defense 33
2. Protected and tested backups — canonical defense 19
3. Physical intrusion alarms — canonical defense 178
4. Reinforced doors and entry assemblies — canonical defense 177

**Designated answer:** Environmental monitoring sensors

**Explanation and reasoning:** Calibrated environmental sensors provide measurements and alerts for conditions such as temperature, water and power. Alerts need actionable thresholds and a response plan. They neither repair cooling equipment nor prove malicious intent. Measurements should be compared with equipment operating limits rather than interpreted as proof of sabotage.

**Why the other offered options do not meet the scenario:** Backups preserve data, alarms relay events and doors resist entry; the question asks for measurement of a physical condition.

**Distinct realistic example:** A failed cooling valve causes thermal shutdowns across a rack.

### 22. Bloatware and unnecessary software

Draft provenance ID: 23. Topic type: unwanted_software. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Unneeded preinstalled or bundled applications that consume resources or enlarge the attack surface. Their presence alone does not establish malicious behavior.

**Scenario question:** An approved inventory identifies unnecessary bundled applications on an otherwise healthy laptop. Which targeted action removes them without reinstalling the whole system?

1. Supported software removal tools — canonical defense 35
2. System hardening — canonical defense 93
3. Application allowlisting — canonical defense 136
4. Security awareness education — canonical defense 28

**Designated answer:** Supported software removal tools

**Explanation and reasoning:** Use supported removal tools or management policies to uninstall unnecessary packages and verify dependencies. Some applications serve required business functions, and removal must be assessed. A clean reinstall may be warranted after compromise but is not the only response to ordinary bloatware.

**Why the other offered options do not meet the scenario:** Baseline hardening, execution rules and education do not themselves perform the identified package uninstallation.

**Distinct realistic example:** A fleet image includes trial utilities that add background services nobody uses.

### 23. Quantum-enabled cryptographic threat

Draft provenance ID: 9. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** The potential use of sufficiently capable quantum computers to defeat vulnerable public-key algorithms. It is not evidence that current adversaries can instantly break all encryption.

**Scenario question:** A long-lived archive uses quantum-vulnerable public-key key establishment and must plan for future confidentiality. Which migration family addresses that algorithmic risk?

1. Post-quantum cryptography — canonical defense 37
2. Advanced Encryption Standard (AES) — canonical defense 182
3. Credential and key rotation — canonical defense 185
4. Adequate cryptographic output length — canonical defense 95

**Designated answer:** Post-quantum cryptography

**Explanation and reasoning:** Use standardized post-quantum algorithms and supported protocols appropriate to the operation, with tested implementations and a migration inventory. Symmetric cryptography and hash functions face different effects and are not all broken in the same way. Migration planning must not overstate current quantum capability.

**Why the other offered options do not meet the scenario:** Replacing a symmetric algorithm, merely rotating vulnerable public keys or increasing an unrelated output length does not supply post-quantum public-key security.

**Distinct realistic example:** A government archive assesses information that must remain confidential for decades against harvest-now-decrypt-later collection.

### 24. Bluejacking

Draft provenance ID: 5. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Sending unsolicited messages through Bluetooth features, historically object-push services. Receiving a message does not by itself prove theft or device compromise.

**Scenario question:** A museum tablet needs no Bluetooth connections and receives unsolicited nearby messages. Which action removes this particular radio communication path?

1. Disable unused Bluetooth — canonical defense 38
2. Disable Bluetooth discoverability — canonical defense 20
3. Device firmware security updates — canonical defense 62
4. Privacy and permission settings — canonical defense 14

**Designated answer:** Disable unused Bluetooth

**Explanation and reasoning:** Turning Bluetooth off prevents that device from participating in Bluetooth exchanges while the radio is disabled. Blocking unsolicited requests and updating software also matter when Bluetooth is required. Bluejacking should not be confused with bluesnarfing or arbitrary remote code execution.

**Why the other offered options do not meet the scenario:** Hiding discovery leaves a radio active; firmware updates and application privacy permissions do not remove the unused communication path.

**Distinct realistic example:** Visitors repeatedly send unwanted contact cards to a discoverable kiosk.

### 25. Unwanted advertising software

Draft provenance ID: 16. Topic type: unwanted_software. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Software that delivers advertising, sometimes bundled without clear consent or accompanied by tracking. Not every advertising-supported product is malware.

**Scenario question:** A browser's advertising requests are the unwanted channel, and malicious software has already been ruled out. Which control filters those requests?

1. Browser advertising blockers — canonical defense 39
2. Anti-spyware protection — canonical defense 13
3. Privacy and permission settings — canonical defense 14
4. Web destination and content filtering — canonical defense 133

**Designated answer:** Browser advertising blockers

**Explanation and reasoning:** An ad blocker can filter ad-related network requests and page elements. It does not uninstall every bundled program or establish that a download is safe. Endpoint cleanup and informed installation choices address unwanted applications themselves.

**Why the other offered options do not meet the scenario:** Spyware inspection, application permissions and broad destination filtering do not provide the specific browser ad-request filtering function asked for.

**Distinct realistic example:** A free utility adds an advertising component that redirects searches after installation.

### 26. Operating-system command injection

Draft provenance ID: 35. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Untrusted input changes the meaning of an operating-system command executed by an application, rather than remaining a data argument.

**Scenario question:** A file-processing service needs to accept only documented operation names and fixed-format identifiers. Which listed control rejects everything outside that small allowed set?

1. Allowlisting permitted operations — canonical defense 42
2. Prepared SQL statements and bound parameters — canonical defense 43
3. Context-aware output encoding — canonical defense 158
4. Content Security Policy (CSP) — canonical defense 159

**Designated answer:** Allowlisting permitted operations

**Explanation and reasoning:** Use an explicit allowlist and a non-shell library API with separated arguments wherever possible. Shell escaping is context-sensitive and can leave argument-injection risks. An allowlist must validate the actual command structure and cannot rescue arbitrary command concatenation on its own.

**Why the other offered options do not meet the scenario:** SQL parameters, HTML output encoding and browser script policy address other interpreters rather than an allowed operating-system operation set.

**Distinct realistic example:** A web diagnostic tool passes user text into a shell command and treats special syntax as instructions.

### 27. SQL injection

Draft provenance ID: 45. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Untrusted input is interpreted as SQL syntax because an application fails to separate database instructions from data.

**Scenario question:** A search endpoint concatenates user text into a database query. Which coding technique binds that text as data rather than SQL structure?

1. Prepared SQL statements and bound parameters — canonical defense 43
2. Context-specific escaping — canonical defense 41
3. Context-aware output encoding — canonical defense 158
4. Content Security Policy (CSP) — canonical defense 159

**Designated answer:** Prepared SQL statements and bound parameters

**Explanation and reasoning:** Prepared statements with bound parameters keep supplied values separate from query syntax. Structural elements such as table names still require controlled selection. Database least privilege and error handling reduce impact, while a WAF is supplementary rather than a replacement for fixing the query construction.

**Why the other offered options do not meet the scenario:** Interpreter escaping, HTML encoding and browser resource policy do not bind input values separately from SQL query structure.

**Distinct realistic example:** A reporting form alters the intended database filter because a submitted value becomes SQL syntax.

### 28. Process memory injection

Draft provenance ID: 40. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Placing code or executable content inside another process to run in that process's context or evade inspection.

**Scenario question:** A legacy program tries to execute bytes from a memory region marked for data only. Which operating-system mitigation can block that execution?

1. Data Execution Prevention (DEP) — canonical defense 45
2. Address Space Layout Randomization (ASLR) — canonical defense 146
3. Stack protection canaries — canonical defense 147
4. Application allowlisting — canonical defense 136

**Designated answer:** Data Execution Prevention (DEP)

**Explanation and reasoning:** Data Execution Prevention marks appropriate memory pages non-executable and blocks attempts to execute from them. It does not prevent every write or every injection technique; code-reuse and permission-changing paths can evade this barrier. Fixing the underlying bug and using additional mitigations are still necessary.

**Why the other offered options do not meet the scenario:** Address randomization, stack guards and application allowlisting do not supply the stated non-executable-page enforcement.

**Distinct realistic example:** An attacker writes malicious code into a trusted process and attempts to start a new thread at that address.

### 29. Logic bomb

Draft provenance ID: 37. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malicious code designed to perform a harmful action when a specified event or condition occurs.

**Scenario question:** A privileged maintainer proposes a scheduled deletion feature tied to their employment status. Which predeployment practice examines the actual code and intent?

1. Independent code review — canonical defense 47
2. File and system integrity monitoring — canonical defense 2
3. Application allowlisting — canonical defense 136
4. Behavior-based threat detection — canonical defense 137

**Designated answer:** Independent code review

**Explanation and reasoning:** Independent code review can detect suspicious triggers, hidden destructive paths and misuse of legitimate privileges. Review requires appropriate expertise and separation of duties; it can miss obfuscated or externally introduced behavior. Access controls and trustworthy build pipelines complement it.

**Why the other offered options do not meet the scenario:** Integrity monitoring, execution policy and behavior detection operate on deployed artifacts or activity rather than review the proposed source change.

**Distinct realistic example:** A script is set to wipe a shared folder on a specific date unless an undocumented file exists.

### 30. Malicious insider activity

Draft provenance ID: 39. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Harmful use of an organization's access, knowledge or trust by someone within its authorized population. Insider risk also includes negligence, which is a different intent.

**Scenario question:** A support employee can read every department's records although the job needs only one queue. Which principle directly reduces the unnecessary reach?

1. Least privilege — canonical defense 50
2. Security configuration and access audits — canonical defense 9
3. Role-based access control (RBAC) — canonical defense 127
4. System hardening — canonical defense 93

**Designated answer:** Least privilege

**Explanation and reasoning:** Give the employee only the data and actions needed for the assigned work, with time-bounded elevation where appropriate. Least privilege limits opportunity and impact rather than detecting every malicious act. Monitoring, review and a safe reporting process remain important.

**Why the other offered options do not meet the scenario:** Audits inspect, roles organize permissions and hardening is a broader process; least privilege is the specific authority-minimization principle.

**Distinct realistic example:** A departing employee misuses legitimately assigned bulk-export rights.

### 31. Web session hijacking

Draft provenance ID: 43. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Using another user's valid session token or manipulating session state to take over an authenticated interaction.

**Scenario question:** A browser sends a session cookie over plain HTTP as well as HTTPS. Which cookie setting prevents that browser from sending it on the HTTP path?

1. Session-cookie security attributes — canonical defense 51
2. SameSite cookie policy — canonical defense 85
3. Multi-factor authentication (MFA) — canonical defense 70
4. Transport Layer Security (TLS) — canonical defense 143

**Designated answer:** Session-cookie security attributes

**Explanation and reasoning:** The Secure cookie attribute restricts transmission to secure transport. HttpOnly reduces script access and appropriate SameSite settings reduce some cross-site request risks, but these are different protections. Token rotation, session invalidation and XSS prevention remain necessary.

**Why the other offered options do not meet the scenario:** Cross-site cookie policy, MFA and the transport protocol are distinct from the cookie's specific Secure transmission attribute.

**Distinct realistic example:** A stolen session token is replayed after the user completed MFA successfully.

### 32. On-path interception

Draft provenance ID: 30. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An adversary gains a position between communicating parties and may observe, relay or alter their exchanges. It overlaps with the older man-in-the-middle label.

**Scenario question:** The application control session must verify both peers independently of any network tunnel. Which mechanism explicitly establishes both application identities?

1. Mutual peer authentication — canonical defense 53
2. Virtual private network (VPN) — canonical defense 145
3. Certificate or public-key pinning — canonical defense 144
4. DNS Security Extensions (DNSSEC) — canonical defense 54

**Designated answer:** Mutual peer authentication

**Explanation and reasoning:** Mutual authentication makes each endpoint verify the other's identity, often with certificates or another suitable authenticated protocol. Confidentiality without authentication can leave an active intermediary. Trust anchors, identity binding and key protection are essential.

**Why the other offered options do not meet the scenario:** A network tunnel, server pin or DNS signature does not by itself supply mutual application-peer authentication.

**Distinct realistic example:** A compromised local gateway redirects device traffic to a service impersonator.

### 33. DNS cache poisoning

Draft provenance ID: 34. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Introducing false DNS data into a resolver cache so later clients receive an incorrect answer.

**Scenario question:** A resolver must verify that signed zone data came from the authorized DNS zone and was not altered. Which mechanism supplies that chain of DNS data authentication?

1. DNS Security Extensions (DNSSEC) — canonical defense 54
2. Transport Layer Security (TLS) — canonical defense 143
3. Look-alike domain monitoring — canonical defense 173
4. Virtual private network (VPN) — canonical defense 145

**Designated answer:** DNS Security Extensions (DNSSEC)

**Explanation and reasoning:** DNSSEC validates signatures and a chain of trust for signed DNS data. Validation must be enabled and the zone must be correctly signed. It does not encrypt DNS queries, protect unsigned data automatically or prove that the destination site is trustworthy.

**Why the other offered options do not meet the scenario:** TLS, registration monitoring and a VPN do not authenticate the signed DNS zone data itself.

**Distinct realistic example:** Clients of a poisoned resolver are directed to a false address for a payment portal.

### 34. ARP poisoning

Draft provenance ID: 33. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Forging local Address Resolution Protocol information so peers associate an IP address with an attacker's link-layer address.

**Scenario question:** A managed switch can compare ARP messages against trusted address bindings. Which feature rejects inconsistent ARP advertisements?

1. Dynamic ARP Inspection — canonical defense 56
2. DNS Security Extensions (DNSSEC) — canonical defense 54
3. Virtual local area networks (VLANs) — canonical defense 165
4. Network firewall rules — canonical defense 59

**Designated answer:** Dynamic ARP Inspection

**Explanation and reasoning:** Dynamic ARP Inspection checks ARP against trusted bindings, commonly from DHCP snooping plus explicit exceptions. Incorrect trust ports or static-device handling can cause outages. ARP is a local-link problem; secure higher-layer protocols add protection even if local redirection occurs.

**Why the other offered options do not meet the scenario:** DNS signatures, VLAN boundaries and general flow filtering do not validate local ARP against trusted switch bindings.

**Distinct realistic example:** A host announces that the default gateway's IP address belongs to the host's own MAC address.

### 35. Amplified reflection DDoS

Draft provenance ID: 32. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A distributed reflected flood that exploits services whose replies are larger than forged requests, multiplying traffic sent to a victim.

**Scenario question:** Your ISP wants to stop customer hosts from sending forged-source requests that enlist amplifiers. Which established network practice addresses the spoofed source prerequisite?

1. BCP 38 source-address filtering — canonical defense 58
2. Upstream DDoS scrubbing — canonical defense 140
3. Load balancing and capacity distribution — canonical defense 78
4. DNS Security Extensions (DNSSEC) — canonical defense 54

**Designated answer:** BCP 38 source-address filtering

**Explanation and reasoning:** BCP 38 source-address validation rejects packets inconsistent with their legitimate source network. Deployment at sending networks reduces reflection abuse. It does not guarantee that a victim link cannot be flooded by attacks originating elsewhere or by non-spoofed traffic.

**Why the other offered options do not meet the scenario:** Scrubbing and load balancing act at different points; DNS response authentication does not validate the source address of outgoing packets.

**Distinct realistic example:** Small queries to exposed UDP services cause much larger replies to converge on a victim.

### 36. Abuse of a serverless function

Draft provenance ID: 57. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Exploitation or misconfiguration of event-driven functions, their permissions, dependencies or triggers. Serverless hosting does not remove application security responsibility.

**Scenario question:** A compromised image-processing function can read every storage bucket. Which control restricts its execution identity to the bucket and operations it actually needs?

1. Identity and access management (IAM) — canonical defense 60
2. Vulnerability patch management — canonical defense 104
3. Security configuration and access audits — canonical defense 9
4. Network segmentation — canonical defense 111

**Designated answer:** Identity and access management (IAM)

**Explanation and reasoning:** An appropriately scoped identity policy limits what that function can do and which resources it can access. Apply least privilege through the platform's IAM rules and test effective permissions. Input validation and dependency security still matter; permissions do not repair the compromised code.

**Why the other offered options do not meet the scenario:** Patching, configuration inspection and network zones do not enforce the function identity's resource-specific authorization policy.

**Distinct realistic example:** An overly permissive event function can retrieve secrets unrelated to its assigned job.

### 37. Attack against WPA-protected Wi-Fi

Draft provenance ID: 28. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A family of attacks against Wi-Fi authentication, configuration or implementations. WPA/TKIP, WPA2 and WPA3 are distinct technologies with different weaknesses.

**Scenario question:** A modern access point has a vendor-confirmed implementation flaw, and a tested security update is available. Which response fixes that known implementation defect?

1. Device firmware security updates — canonical defense 62
2. MAC-address filtering — canonical defense 74
3. Protected Management Frames (802.11w) — canonical defense 163
4. Disable unsafe automatic network association — canonical defense 157

**Designated answer:** Device firmware security updates

**Explanation and reasoning:** Install the applicable tested firmware update and verify its configuration. Protocol migration can improve security but does not replace patching a vulnerable implementation. Strong enterprise authentication or WPA3-SAE also requires appropriate configuration and client support.

**Why the other offered options do not meet the scenario:** MAC policy, protected management frames and client association settings do not apply the vendor's implementation repair.

**Distinct realistic example:** A wireless deployment uses a supported protocol but an unpatched access-point implementation remains vulnerable.

### 38. Implementation side-channel attack

Draft provenance ID: 36. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Inferring secrets from timing, power, cache use or other observable implementation behavior rather than directly breaking the algorithm.

**Scenario question:** A remote service's secret comparison runs longer when more prefix bytes match. Which implementation property removes that data-dependent timing pattern?

1. Constant-time cryptographic implementation — canonical defense 63
2. Credential and key rotation — canonical defense 185
3. Advanced Encryption Standard (AES) — canonical defense 182
4. Cryptographic key management — canonical defense 183

**Designated answer:** Constant-time cryptographic implementation

**Explanation and reasoning:** Use well-reviewed constant-time primitives and avoid secret-dependent branches or memory accesses in the relevant path. Constant time is a property of the deployed implementation and platform, not a claim that every operation takes identical wall-clock time. Other physical leakage may remain.

**Why the other offered options do not meet the scenario:** Rotation, a cipher name and key custody do not remove secret-dependent timing from the comparison implementation.

**Distinct realistic example:** A smart-card power trace reveals patterns correlated with secret-key operations.

### 39. Exploitable race condition

Draft provenance ID: 41. Topic type: weakness. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A security-sensitive result changes because concurrent operations interleave unexpectedly, including checks that become invalid before use.

**Scenario question:** Two threads can both approve withdrawal from the same balance before either updates it. Which listed operation property makes the check-and-update indivisible?

1. Atomic operations and transactions — canonical defense 66
2. Request rate limiting — canonical defense 77
3. Authenticated sequence numbers — canonical defense 81
4. Session expiration and idle timeouts — canonical defense 52

**Designated answer:** Atomic operations and transactions

**Explanation and reasoning:** Perform the related check and state update as one correctly synchronized atomic transaction or operation. Atomicity must cover the whole invariant, not just an individual read. Mutexes are another synchronization method but the question asks for the property of the combined transaction.

**Why the other offered options do not meet the scenario:** Request rates, message numbering and session lifetimes do not make the balance check-and-update an indivisible transaction.

**Distinct realistic example:** A file path is validated and then replaced by an attacker before a privileged program opens it.

### 40. Credential stuffing

Draft provenance ID: 51. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Automated attempts to sign in with username/password pairs exposed by another service. It exploits password reuse rather than discovering a new password through guessing.

**Scenario question:** An unrelated retailer suffers a breach. Which password habit prevents the stolen retailer password from also being your company email password?

1. Unique passwords per service — canonical defense 68
2. Account lockouts and progressive login restrictions — canonical defense 79
3. Per-password salting — canonical defense 89
4. Multi-factor authentication (MFA) — canonical defense 70

**Designated answer:** Unique passwords per service

**Explanation and reasoning:** Use a different strong password for each account, preferably generated and stored by a trustworthy password manager. Unique passwords reduce cross-service reuse but do not protect a password stolen from the very service being accessed. Phishing-resistant MFA adds a separate layer.

**Why the other offered options do not meet the scenario:** Lockouts, salts and MFA provide other protections, but none is the specific habit of choosing a different password for each service.

**Distinct realistic example:** Credentials leaked from a forum are tested against streaming, mail and financial accounts.

### 41. Password spraying

Draft provenance ID: 49. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Trying a small number of common passwords across many accounts, often slowly enough to evade simple per-account thresholds.

**Scenario question:** One common password is being tried once against hundreds of staff accounts. Which telemetry control can correlate those failures across accounts?

1. Correlated failed-login monitoring — canonical defense 69
2. Account lockouts and progressive login restrictions — canonical defense 79
3. Per-password salting — canonical defense 89
4. CAPTCHA and automation challenges — canonical defense 80

**Designated answer:** Correlated failed-login monitoring

**Explanation and reasoning:** Correlate failures across accounts, sources and time windows, then investigate and respond to the pattern. Per-account lockouts may not trigger during low-and-slow spraying. Phishing-resistant MFA and avoiding common passwords reduce takeover risk, but monitoring itself is detection rather than guaranteed prevention.

**Why the other offered options do not meet the scenario:** A lockout sees each account separately, a salt applies offline and CAPTCHA alone does not provide cross-account failure correlation.

**Distinct realistic example:** One candidate password is tested across an entire department before the attacker changes candidates.

### 42. Protocol downgrade attack

Draft provenance ID: 53. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Interference that causes peers to use a weaker protocol or configuration than they could otherwise negotiate.

**Scenario question:** A service still accepts obsolete protocol versions that clients do not need. Which action removes those versions from the available negotiation choices?

1. Disable obsolete protocols and features — canonical defense 71
2. Credential and key rotation — canonical defense 185
3. Certificate or public-key pinning — canonical defense 144
4. Transport Layer Security (TLS) — canonical defense 143

**Designated answer:** Disable obsolete protocols and features

**Explanation and reasoning:** Disable deprecated versions and weak algorithms using a supported configuration and test required clients. Authentication must protect negotiation where the protocol requires it. Removing a fallback may expose compatibility problems; HSTS addresses browser HTTP-to-HTTPS behavior rather than every cryptographic downgrade.

**Why the other offered options do not meet the scenario:** Key rotation, pinning and the TLS protocol label do not remove the server's configured obsolete negotiation choices.

**Distinct realistic example:** An attacker interferes with setup so a client falls back to an older, vulnerable mode.

### 43. Unauthorized wireless access point

Draft provenance ID: 54. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An access point deployed without organizational authorization. It may be malicious or an employee's convenience device; discovery does not establish intent.

**Scenario question:** An office needs to identify access points that are absent from its approved inventory and investigate their wired location. Which system supplies wireless detection and policy response?

1. Wireless intrusion detection and prevention — canonical defense 73
2. Suppress network-name advertisement — canonical defense 179
3. Device firmware security updates — canonical defense 62
4. Disable unsafe automatic network association — canonical defense 157

**Designated answer:** Wireless intrusion detection and prevention

**Explanation and reasoning:** Wireless intrusion prevention and detection can compare observed access points with authorized infrastructure and help locate suspicious devices. Correct inventory and verification are essential. Automated radio disruption has legal and availability implications and is not universally appropriate.

**Why the other offered options do not meet the scenario:** SSID suppression, firmware maintenance and client auto-join policy do not discover radios absent from an authorized inventory.

**Distinct realistic example:** An employee plugs a personal access point into an internal network port.

### 44. Keystroke logging

Draft provenance ID: 42. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Recording user input through software, a hardware device or another interception layer. A keylogger may capture passwords but can also steal ordinary sensitive text.

**Scenario question:** An endpoint has a known software keylogger. Which listed product class can detect and quarantine the implant rather than merely change how keys are entered?

1. Anti-malware protection — canonical defense 76
2. Multi-factor authentication (MFA) — canonical defense 70
3. Application allowlisting — canonical defense 136
4. File and system integrity monitoring — canonical defense 2

**Designated answer:** Anti-malware protection

**Explanation and reasoning:** Anti-malware tools can identify known keyloggers and suspicious input interception. They require sufficient visibility and may miss kernel-level or novel implants. Hardware inspection is needed for hardware loggers, and credentials exposed before removal must be treated as compromised.

**Why the other offered options do not meet the scenario:** MFA and execution rules protect other stages; file-state monitoring is not the requested malware identification and quarantine engine.

**Distinct realistic example:** A keyboard cable contains a small recorder that stores everything typed.

### 45. Denial of service

Draft provenance ID: 29. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Making a service unavailable by exhausting resources, exploiting a failure or disrupting dependencies. A single source can cause DoS; distribution is not required.

**Scenario question:** One API client is exhausting an expensive endpoint with excessive requests. Which control caps that client's request rate before the costly work?

1. Request rate limiting — canonical defense 77
2. Upstream DDoS scrubbing — canonical defense 140
3. Network firewall rules — canonical defense 59
4. Network traffic analysis — canonical defense 141

**Designated answer:** Request rate limiting

**Explanation and reasoning:** Per-client, per-identity or resource-aware rate limits can reduce request exhaustion when placed before expensive operations. Attackers may distribute requests or share addresses with legitimate users. Limits need fair handling and sufficient upstream capacity. Place enforcement before the expensive operation rather than after the constrained resource has already been consumed.

**Why the other offered options do not meet the scenario:** Upstream scrubbing, packet filtering and traffic analysis do not impose the stated per-client limit before costly API work.

**Distinct realistic example:** A malformed request crashes a single-threaded service even without a large traffic flood.

### 46. Online brute-force password guessing

Draft provenance ID: 47. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Repeated systematic password guesses against an account or service. Brute-force search can also be performed offline, where login controls do not apply.

**Scenario question:** A login service must place an account into a temporary locked state after repeated bad guesses. Which listed control implements that state?

1. Account lockouts and progressive login restrictions — canonical defense 79
2. Correlated failed-login monitoring — canonical defense 69
3. Multi-factor authentication (MFA) — canonical defense 70
4. Credential breach monitoring — canonical defense 67

**Designated answer:** Account lockouts and progressive login restrictions

**Explanation and reasoning:** An appropriately designed lockout or progressive throttling policy can restrict online guessing. Attackers can abuse rigid lockouts to deny service, so recovery and rate limits need care. This scenario is online; no account setting stops guesses computed against stolen hashes.

**Why the other offered options do not meet the scenario:** Failure monitoring, added identity proof and breach intelligence do not implement the specified account lockout state.

**Distinct realistic example:** A remote-access gateway logs sequential password candidates for one user over several minutes.

### 47. Protocol message replay

Draft provenance ID: 58. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reusing a previously valid message to repeat an authenticated operation because the receiver does not establish freshness or uniqueness.

**Scenario question:** A signed command stream needs to reject a previously accepted message number. Which protocol field, checked with an anti-replay window, supports that decision?

1. Authenticated sequence numbers — canonical defense 81
2. Authenticated timestamps and freshness windows — canonical defense 83
3. Authenticated nonces and freshness checks — canonical defense 8
4. Credential and key rotation — canonical defense 185

**Designated answer:** Authenticated sequence numbers

**Explanation and reasoning:** Authenticate sequence numbers and track which values have already been accepted for the session. Handle resets and wraparound safely. A number that is not checked or is not integrity-protected gives no replay guarantee. One-time codes are useful in authentication but do not automatically protect arbitrary command streams.

**Why the other offered options do not meet the scenario:** A timestamp, nonce and credential replacement are not the ordered message-number acceptance window specified in this scenario.

**Distinct realistic example:** A captured payment instruction is resent and accepted a second time despite a valid signature.

### 48. Replay against an IoT command protocol

Draft provenance ID: 38. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reusing a previously valid device message to repeat an action when freshness or one-time acceptance is not enforced.

**Scenario question:** A smart lock must bind an unlock response to a fresh unpredictable receiver challenge. Which authenticated one-time value provides that challenge?

1. Authenticated nonces and freshness checks — canonical defense 8
2. Cryptographically authenticated RFID — canonical defense 86
3. Time-based one-time authentication codes — canonical defense 7
4. Authenticated sequence numbers — canonical defense 81

**Designated answer:** Authenticated nonces and freshness checks

**Explanation and reasoning:** An authenticated one-time nonce or challenge can distinguish a fresh authorized command from a captured message. The receiver must track or verify freshness securely across reconnects as needed. Resource-constrained devices still require careful protocol design; encryption alone is not replay protection.

**Why the other offered options do not meet the scenario:** Badge authentication and login codes concern other exchanges; ordered counters are not a fresh unpredictable receiver challenge.

**Distinct realistic example:** A recorded actuator instruction is resent after the operator has stopped the machinery.

### 49. Cross-site request forgery

Draft provenance ID: 46. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A site causes a victim's browser to send an unwanted authenticated request to another site that trusts ambient credentials without sufficient request-origin safeguards.

**Scenario question:** A banking form needs a server-checked unpredictable value bound to the user's session to reject forged cross-site submissions. Which listed defense supplies it?

1. Request-bound anti-CSRF tokens — canonical defense 84
2. Session-cookie security attributes — canonical defense 51
3. Multi-factor authentication (MFA) — canonical defense 70
4. Transport Layer Security (TLS) — canonical defense 143

**Designated answer:** Request-bound anti-CSRF tokens

**Explanation and reasoning:** A correctly implemented anti-CSRF token binds the request to the legitimate interaction. Check the value server-side and protect it from leakage; XSS can often bypass this protection. SameSite cookies and origin checks are useful layers, but they do not eliminate every CSRF scenario.

**Why the other offered options do not meet the scenario:** Cookie transport attributes, sign-in factors and TLS do not supply the stated unpredictable request-bound anti-CSRF value.

**Distinct realistic example:** An attacker-controlled page triggers a logged-in browser to change an account's email address.

### 50. RFID credential cloning

Draft provenance ID: 56. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Copying identifying data from a radio credential to reproduce its accepted behavior, particularly when a reader trusts a static identifier.

**Scenario question:** A badge reader accepts a copied static tag number. Which upgraded badge design can authenticate a secret without transmitting a reusable static proof?

1. Cryptographically authenticated RFID — canonical defense 86
2. Electronic badge access systems — canonical defense 171
3. Biometric authentication — canonical defense 32
4. MAC-address filtering — canonical defense 74

**Designated answer:** Cryptographically authenticated RFID

**Explanation and reasoning:** Choose cryptographically authenticated RFID with challenge-response and protected keys, not simply encrypted storage or a different printed serial number. Relay attacks and compromised readers remain concerns. The catalog label Encrypted RFID needs this narrower authentication interpretation.

**Why the other offered options do not meet the scenario:** An access system, biometric check or MAC rule is not the requested fresh cryptographic proof performed by the RFID credential.

**Distinct realistic example:** A copied access-tag identifier is written to another token that an old reader accepts.

### 51. Dictionary-based password guessing

Draft provenance ID: 48. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Trying likely passwords from a wordlist, breach corpus or predictable variations rather than exploring all character combinations.

**Scenario question:** At password creation, users must be steered away from predictable words and compromised candidates, not merely reuse. Which listed password-selection policy addresses that choice?

1. Strong password selection — canonical defense 88
2. Account lockouts and progressive login restrictions — canonical defense 79
3. Unique passwords per service — canonical defense 68
4. Password KDF work factors (key stretching) — canonical defense 91

**Designated answer:** Strong password selection

**Explanation and reasoning:** Interpret the legacy Complex Passwords label as long, unique, blocklisted-against-common-values passwords or passphrases, not mandatory symbol recipes. A wordlist can target online services or offline hashes. Salts prevent reusable precomputation but do not make a weak individual password unguessable.

**Why the other offered options do not meet the scenario:** Online attempt restrictions, avoiding cross-service reuse and KDF cost do not reject predictable password choices at creation.

**Distinct realistic example:** A password based on a sports team and the current year is found early in a targeted wordlist.

### 52. Rainbow-table password recovery

Draft provenance ID: 50. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Searching precomputed hash-chain structures for candidate passwords matching vulnerable unsalted hashes. It is a lookup strategy, not mathematical reversal of a hash.

**Scenario question:** A legacy password database uses unsalted hashes. Which storage change specifically defeats reusing one precomputed table across all users?

1. Uniquely salted password verifiers — canonical defense 90
2. Account lockouts and progressive login restrictions — canonical defense 79
3. Correlated failed-login monitoring — canonical defense 69
4. Unique passwords per service — canonical defense 68

**Designated answer:** Uniquely salted password verifiers

**Explanation and reasoning:** A unique random salt per password makes each user's hash computation distinct and makes shared precomputed tables impractical. The salt need not be secret. A cost-tuned password KDF is also necessary because an attacker can still compute guesses for an individual salted record.

**Why the other offered options do not meet the scenario:** Login restrictions, failure telemetry and using different service passwords do not add a distinct salt to each stored verifier.

**Distinct realistic example:** A legacy application's identical password hashes reveal that several users chose the same password.

### 53. Default credential exploitation

Draft provenance ID: 52. Topic type: weakness. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Unauthorized access using a factory-set, shared or predictable credential that remains active after deployment.

**Scenario question:** A camera fleet still accepts a published factory administrator password. Which provisioning requirement replaces that default before the cameras are put into service?

1. Secure initial and compromised-credential changes — canonical defense 92
2. Credential and key rotation — canonical defense 185
3. Correlated failed-login monitoring — canonical defense 69
4. Multi-factor authentication (MFA) — canonical defense 70

**Designated answer:** Secure initial and compromised-credential changes

**Explanation and reasoning:** Require unique initial credentials or a secure first-use change, disable unused default accounts and restrict management access. Here Mandatory Changes refers to changing exposed defaults, not arbitrary periodic password rotation. A changed password does not fix vulnerable firmware.

**Why the other offered options do not meet the scenario:** A generic later rotation cycle, monitoring and MFA do not ensure the published default is removed before production use.

**Distinct realistic example:** An internet-accessible appliance can be administered with a credential printed in its public setup guide.

### 54. Birthday-bound collision search

Draft provenance ID: 31. Topic type: analysis_model. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Using the birthday effect to find any two inputs with the same hash more efficiently than finding a preimage for one fixed digest.

**Scenario question:** A signature design uses a hash with an output too short for its collision-security target. Which design change increases the generic collision-search work factor?

1. Adequate cryptographic output length — canonical defense 95
2. Hash-based message authentication code (HMAC) — canonical defense 175
3. Credential and key rotation — canonical defense 185
4. Cryptographic key management — canonical defense 183

**Designated answer:** Adequate cryptographic output length

**Explanation and reasoning:** A suitably longer output increases the birthday-bound work factor, roughly to the square root of the output space for an ideal hash. The algorithm must also resist practical cryptanalysis. This is different from guessing a password or finding a message for one specified digest.

**Why the other offered options do not meet the scenario:** Message authentication and key-lifecycle measures change other properties; the question asks for adequate collision-resistant output size.

**Distinct realistic example:** A toy 32-bit checksum quickly produces duplicate values for unrelated files.

### 55. Quid pro quo social engineering

Draft provenance ID: 26. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Offering a benefit or service in exchange for information or actions that the requester should not receive.

**Scenario question:** A stranger offers technical support in exchange for your password. Which immediate action checks the supposed support request independently?

1. Independent request verification — canonical defense 96
2. Enforceable security policies — canonical defense 169
3. Restricted access to sensitive information — canonical defense 120
4. Role-appropriate security instruction — canonical defense 167

**Designated answer:** Independent request verification

**Explanation and reasoning:** Verify the request through an established help-desk channel and refuse credential sharing. A promised benefit does not establish authority. Training helps recognize the exchange, while operational verification addresses this particular request before action. The verifier should record and report the approach so similar requests can be recognized across the organization.

**Why the other offered options do not meet the scenario:** A policy, limited data access and training do not independently confirm the legitimacy of this specific offer.

**Distinct realistic example:** A caller promises a gift card if an employee installs a remote-access utility.

### 56. Piggybacking into a restricted area

Draft provenance ID: 27. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Entry by an unauthorized person with another person's assistance or apparent permission. Organizations sometimes use the term interchangeably with tailgating.

**Scenario question:** A visitor is admitted legitimately but must not wander into restricted rooms alone. Which rule keeps a responsible employee with the visitor?

1. Visitor escort procedures — canonical defense 98
2. Electronic badge access systems — canonical defense 171
3. Physical security personnel — canonical defense 172
4. Access-control vestibules — canonical defense 170

**Designated answer:** Visitor escort procedures

**Explanation and reasoning:** An escort policy defines who can sponsor, accompany and account for visitors throughout controlled areas. It requires staff compliance and a safe challenge process. A badge at the main entrance does not automatically authorize every interior area.

**Why the other offered options do not meet the scenario:** Door credentials, guard presence and entry vestibules do not define continuous authorized accompaniment of a visitor.

**Distinct realistic example:** A contractor with a visitor pass follows a helpful employee into an engineering lab without approval.

### 57. Lock picking

Draft provenance ID: 55. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Manipulating a lock mechanism to open it without the authorized key and without necessarily forcing the door.

**Scenario question:** A sensitive storeroom needs a lock designed and independently assessed to resist manipulation of its cylinder. Which listed control addresses the lock mechanism itself?

1. High-security mechanical locks — canonical defense 99
2. Physical intrusion alarms — canonical defense 178
3. Reinforced doors and entry assemblies — canonical defense 177
4. Physical security personnel — canonical defense 172

**Designated answer:** High-security mechanical locks

**Explanation and reasoning:** Select an appropriately rated high-security lock as part of a secure door assembly and managed key system. Resistance is not immunity; installation, key custody and other entry paths matter. Electronic monitoring may alert on an opening but does not necessarily improve a mechanical cylinder.

**Why the other offered options do not meet the scenario:** Alarms, reinforced doors and guards provide other physical layers; they do not specify a cylinder's manipulation resistance.

**Distinct realistic example:** A lock is opened by manipulating its internal components, leaving little obvious door damage.

### 58. Security hoax

Draft provenance ID: 44. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A false security warning or fabricated incident claim that induces harmful action. A mistaken warning is not proof of malicious intent.

**Scenario question:** A viral message instructs staff to delete a system file to stop an alleged virus. Which first step checks whether the claim is genuine?

1. Security-claim source verification — canonical defense 101
2. Threat intelligence — canonical defense 108
3. Email threat filtering — canonical defense 150
4. Role-appropriate security instruction — canonical defense 167

**Designated answer:** Security-claim source verification

**Explanation and reasoning:** Check the warning against independent trusted advisories or the organization's security team before acting. Preserve suspicious messages for investigation. An incident plan can organize the response, but verification avoids turning the hoax itself into a destructive action.

**Why the other offered options do not meet the scenario:** Intelligence, delivery filtering and training can support response but do not establish the truth of this particular warning.

**Distinct realistic example:** A fabricated breach announcement causes staff to send credentials to an unapproved support site.

### 59. Ransomware and extortion

Draft provenance ID: 73. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malware or an intrusion campaign that denies access to data or systems and demands payment, sometimes also stealing data for extortion.

**Scenario question:** After ransomware, a team needs to restore data without paying and without trusting copies writable by the attacker. Which recovery control is essential?

1. Protected and tested backups — canonical defense 19
2. Endpoint or workload isolation — canonical defense 123
3. Network segmentation — canonical defense 111
4. Antivirus protection — canonical defense 138

**Designated answer:** Protected and tested backups

**Explanation and reasoning:** Maintain tested, isolated or immutable backups with protected credentials and clean recovery procedures. Restoration does not undo exfiltration, eliminate persistence or guarantee a fast recovery. Containment and investigation must establish that restored systems will not be immediately compromised again.

**Why the other offered options do not meet the scenario:** Containment, zone boundaries and malware detection do not create an independent recoverable data copy.

**Distinct realistic example:** A criminal encrypts a file server and threatens to publish previously stolen documents.

### 60. Software supply-chain compromise

Draft provenance ID: 94. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Compromise of a supplier, dependency, build system or delivery channel that reaches users through trusted relationships or software distribution.

**Scenario question:** A release process needs evidence that downloaded packages came from the approved publisher and were not modified after signing. Which mechanism supplies that check?

1. Verified digital signatures — canonical defense 106
2. Security scanning — canonical defense 135
3. Cryptographic key management — canonical defense 183
4. Application allowlisting — canonical defense 136

**Designated answer:** Verified digital signatures

**Explanation and reasoning:** Verify signatures against a trusted publisher identity and protect the signing process. A valid signature demonstrates integrity relative to the signed content, not that the publisher's code is benign. Compromised build or signing systems can produce legitimately signed malicious releases.

**Why the other offered options do not meet the scenario:** Scanning, key management and execution policy do not themselves verify this release package against its publisher signature.

**Distinct realistic example:** A dependency update introduces attacker code into many downstream products.

### 61. Exploitation of a zero-day vulnerability

Draft provenance ID: 96. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Exploitation of a vulnerability before an effective fix or sufficient defender knowledge is available. An unknown flaw is not automatically being exploited.

**Scenario question:** No signature exists for a new exploit, but an endpoint can flag suspicious patterns such as unexpected process creation. Which detection approach uses those behavior-based clues?

1. Heuristic threat detection — canonical defense 107
2. Vulnerability patch management — canonical defense 104
3. Endpoint or workload isolation — canonical defense 123
4. Network segmentation — canonical defense 111

**Designated answer:** Heuristic threat detection

**Explanation and reasoning:** Heuristic detection can identify suspicious patterns without an exact known signature. It produces false positives and can miss new techniques; it does not guarantee detection of every zero-day. Isolation, least privilege and rapid investigation reduce impact while a fix is developed.

**Why the other offered options do not meet the scenario:** A patch, containment action and network architecture do not detect an unfamiliar behavior pattern without a known signature.

**Distinct realistic example:** An attacker uses an unpatched browser flaw before the vendor publishes remediation.

### 62. Attack against operational technology

Draft provenance ID: 93. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malicious interference with systems that monitor or control physical processes. Safety, availability and engineering constraints shape the response.

**Scenario question:** An industrial zone needs tightly controlled communication between engineering systems and plant controllers. Which listed boundary control can enforce allowed industrial traffic?

1. Industrial and SCADA network firewalls — canonical defense 110
2. Physical intrusion alarms — canonical defense 178
3. Network segmentation — canonical defense 111
4. Supported software and device updates — canonical defense 129

**Designated answer:** Industrial and SCADA network firewalls

**Explanation and reasoning:** An appropriately designed industrial firewall can restrict approved paths and, where supported, inspect relevant protocols. Coordinate policy changes with operators and safety engineers; blocking a legitimate command can be hazardous. Firewalls do not replace host hardening, recovery planning or physical safety controls.

**Why the other offered options do not meet the scenario:** Physical alarms, general network zoning and software updates do not provide the specified industrial protocol boundary inspection.

**Distinct realistic example:** An attacker changes a process setpoint through an exposed engineering workstation.

### 63. Malicious software update

Draft provenance ID: 100. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An update distributes unwanted or malicious behavior through a software delivery path, whether by tampering or compromise of a trusted publisher.

**Scenario question:** A package mirror may have been tampered with. Which check verifies the update against an independently trusted publisher signature before installation?

1. Verified digital signatures — canonical defense 106
2. Supplier and system security assessments — canonical defense 105
3. Vulnerability patch management — canonical defense 104
4. Cryptographic key management — canonical defense 183

**Designated answer:** Verified digital signatures

**Explanation and reasoning:** Verify publisher signatures and release provenance using a trust route independent of the suspect mirror. Signing does not prove benign content if the publisher, build pipeline or signing key was compromised. Staged rollout, review and recovery plans limit the consequences of a bad update.

**Why the other offered options do not meet the scenario:** Supplier assessment, applying patches and managing keys do not themselves perform the requested publisher-signature verification on this downloaded package.

**Distinct realistic example:** An attacker replaces an unsigned update on a distribution server with a modified package.

### 64. Network worm

Draft provenance ID: 71. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malware that propagates autonomously between systems, commonly by exploiting exposed services or reusable access paths.

**Scenario question:** A worm is spreading between departments over services they do not need to share. Which architectural control restricts that lateral traffic?

1. Network segmentation — canonical defense 111
2. Antivirus protection — canonical defense 138
3. Supported software and device updates — canonical defense 129
4. Least privilege — canonical defense 50

**Designated answer:** Network segmentation

**Explanation and reasoning:** Segmentation limits allowed communication between defined zones and can contain spread when enforced by tested access rules. It does not remove an already infected host or protect an explicitly permitted vulnerable service. Patching and incident containment remain necessary.

**Why the other offered options do not meet the scenario:** Malware detection, updates and privilege reduction do not define the requested network-zone architecture.

**Distinct realistic example:** An unpatched service allows infected hosts to compromise reachable peers without a user opening a file.

### 65. Container breakout

Draft provenance ID: 91. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Crossing a container's intended isolation boundary to affect the host or other workloads through vulnerabilities, excessive privileges or exposed interfaces.

**Scenario question:** A Linux host needs mandatory rules limiting what a containerized process can access even when ordinary file permissions allow it. Which mechanism provides that policy enforcement?

1. Security-Enhanced Linux (SELinux) — canonical defense 114
2. Kubernetes workload admission security policy — canonical defense 128
3. Least privilege — canonical defense 50
4. Address Space Layout Randomization (ASLR) — canonical defense 146

**Designated answer:** Security-Enhanced Linux (SELinux)

**Explanation and reasoning:** SELinux can enforce mandatory access rules based on labels and policy, limiting resources a process can use. Its effectiveness depends on enforcing mode and appropriate profiles. Namespaces alone are not a complete security boundary, and a privileged container or vulnerable kernel can undermine isolation.

**Why the other offered options do not meet the scenario:** Admission rules, least privilege and memory randomization do not provide the specified label-based mandatory runtime access engine.

**Distinct realistic example:** A container with an exposed host management socket gains control outside its intended workload scope.

### 66. Business email compromise

Draft provenance ID: 63. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Fraud using impersonated or compromised business communication to manipulate payments or release information, often without malware.

**Scenario question:** A supplier requests new bank details by email. Which control requires independent approval and account-change checks before money moves?

1. Financial authorization and fraud controls — canonical defense 117
2. Email threat filtering — canonical defense 150
3. Multi-factor authentication (MFA) — canonical defense 70
4. Message-sender verification — canonical defense 130

**Designated answer:** Financial authorization and fraud controls

**Explanation and reasoning:** Use segregation of duties, verified account-change procedures and transaction approval thresholds. These controls address the payment process even when a genuine mailbox has been compromised. Email authentication and MFA reduce some entry paths but do not certify that a payment instruction is legitimate.

**Why the other offered options do not meet the scenario:** Mail inspection and identity checks do not impose separation of duties or account-change approval on the payment itself.

**Distinct realistic example:** A criminal takes over a supplier mailbox and replaces an invoice's destination account.

### 67. Executive-targeted phishing

Draft provenance ID: 61. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Targeted phishing aimed at senior or otherwise high-value decision makers, often exploiting authority, confidential projects or payment powers.

**Scenario question:** A purported chief executive urgently requests a changed payment destination. Which established process checks the request through a known channel before payment?

1. Out-of-band verification procedures — canonical defense 119
2. Domain-based Message Authentication, Reporting and Conformance (DMARC) — canonical defense 116
3. Email threat filtering — canonical defense 150
4. Multi-factor authentication (MFA) — canonical defense 70

**Designated answer:** Out-of-band verification procedures

**Explanation and reasoning:** An out-of-band verification protocol and appropriate approvals can interrupt executive impersonation even when the message appears authentic. No employee should be exempt because a request invokes seniority. Training prepares staff and access controls limit exposure but are not transaction verification.

**Why the other offered options do not meet the scenario:** Domain policy, mail inspection and MFA do not verify the legitimacy of the changed bank account for this transaction.

**Distinct realistic example:** A tailored message uses a board member's name and a confidential acquisition as a pretext for a transfer.

### 68. Remote access Trojan

Draft provenance ID: 74. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malware providing covert or unauthorized remote control of a device. Legitimate remote administration tools can also be abused, but are not automatically Trojans.

**Scenario question:** A workstation begins an unusual external control session through an allowed connection. Which listed monitoring method flags behavior that differs from its established baseline?

1. Anomaly detection — canonical defense 122
2. Session expiration and idle timeouts — canonical defense 52
3. Application allowlisting — canonical defense 136
4. Least privilege — canonical defense 50

**Designated answer:** Anomaly detection

**Explanation and reasoning:** Anomaly detection can reveal new destinations, unusual remote activity or unexpected process behavior and trigger investigation. Baselines drift and legitimate changes can look suspicious. MFA does not prevent malware already executing from using the victim's session or making outbound connections.

**Why the other offered options do not meet the scenario:** Session expiry, execution rules and privilege limits do not compare the connection pattern with an established behavioral baseline.

**Distinct realistic example:** A disguised utility gives an attacker interactive access to files, microphone and running applications.

### 69. Botnet activity

Draft provenance ID: 75. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Coordinated activity by a collection of compromised or otherwise abusively controlled devices. Individual devices may send spam, floods or other commands.

**Scenario question:** A known botnet control domain must be redirected to an authorized defensive destination to interrupt command contact and observe affected clients. Which technique does that?

1. Authorized sinkholing — canonical defense 124
2. Network firewall rules — canonical defense 59
3. DNS Security Extensions (DNSSEC) — canonical defense 54
4. Network traffic analysis — canonical defense 141

**Designated answer:** Authorized sinkholing

**Explanation and reasoning:** Authorized DNS or infrastructure sinkholing can divert control traffic and help identify compromised clients. It depends on the malware's command scheme and the defender's legal and technical authority. Devices still require remediation; blocking one domain does not remove the bot.

**Why the other offered options do not meet the scenario:** Flow restrictions, DNS data authentication and traffic analysis do not implement the authorized command-domain redirection.

**Distinct realistic example:** Compromised cameras periodically contact a shared command service before sending attack traffic.

### 70. Privilege escalation

Draft provenance ID: 81. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Obtaining permissions or execution authority beyond the actor's authorized level, through flaws, misconfiguration or abuse of trusted functions.

**Scenario question:** An application routinely runs as administrator despite needing only one data directory. Which principle reduces the privileges available if it is compromised?

1. Least privilege — canonical defense 50
2. Role-based access control (RBAC) — canonical defense 127
3. System hardening — canonical defense 93
4. Security-Enhanced Linux (SELinux) — canonical defense 114

**Designated answer:** Least privilege

**Explanation and reasoning:** Run with only required rights, separating administrative operations and limiting elevation duration. Least privilege reduces impact and some escalation paths but does not patch a kernel flaw or prove that all authorization checks are correct. Monitor and review privileged activity.

**Why the other offered options do not meet the scenario:** Role administration, baseline hardening and a mandatory policy engine are implementations or processes, not the requested least-authority principle.

**Distinct realistic example:** A local service flaw turns a low-privilege account into an administrative process.

### 71. Pass-the-hash authentication abuse

Draft provenance ID: 82. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Using stolen NTLM password-hash material to authenticate without recovering the plaintext password. It differs from offline cracking and ordinary password replay.

**Scenario question:** An assessed Windows deployment can retire NTLM without breaking required services. Which listed change removes that specific authentication path for stolen NTLM hashes?

1. Restrict or disable NTLM — canonical defense 125
2. Account lockouts and progressive login restrictions — canonical defense 79
3. Password KDF work factors (key stretching) — canonical defense 91
4. Per-password salting — canonical defense 89

**Designated answer:** Restrict or disable NTLM

**Explanation and reasoning:** Restrict or disable NTLM where supported after compatibility assessment, and combine this with credential isolation, unique local administrator secrets and least privilege. Kerberos use alone does not eliminate credential theft or all NTLM fallback paths. Ticket and key abuse remain possible in other protocols.

**Why the other offered options do not meet the scenario:** Online restrictions, password-guess cost and salts do not remove an accepted NTLM authentication path for stolen hash material.

**Distinct realistic example:** A stolen administrator NTLM hash is used to authenticate laterally to another host.

### 72. Kubernetes workload or cluster compromise

Draft provenance ID: 95. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Abuse of container workloads, cluster permissions, exposed management interfaces or insecure deployment settings in Kubernetes.

**Scenario question:** A cluster should reject new workloads requesting privileged containers or unsafe host access. Which listed admission-policy family can enforce those workload restrictions?

1. Kubernetes workload admission security policy — canonical defense 128
2. Kernel resource namespaces — canonical defense 115
3. Security-Enhanced Linux (SELinux) — canonical defense 114
4. Least privilege — canonical defense 50

**Designated answer:** Kubernetes workload admission security policy

**Explanation and reasoning:** Use supported admission controls such as Pod Security Admission and suitable policy enforcement. The historical PodSecurityPolicy resource was removed; do not recommend deploying that removed API. RBAC, network rules, runtime security and patching address additional cluster risks.

**Why the other offered options do not meet the scenario:** Resource views, mandatory runtime policy and least privilege do not perform the workload-admission check described.

**Distinct realistic example:** A workload manifest requests excessive host privileges and can inspect sensitive host resources.

### 73. IoT devices used in DDoS

Draft provenance ID: 92. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Compromised internet-connected devices participate in a distributed availability attack. The device category describes sources, not a special kind of traffic immunity.

**Scenario question:** A camera fleet exposes a vendor-fixed remote compromise flaw. Which action removes that known weakness from the devices when a safe update is available?

1. Supported software and device updates — canonical defense 129
2. System hardening — canonical defense 93
3. Upstream DDoS scrubbing — canonical defense 140
4. Network firewalls — canonical defense 112

**Designated answer:** Supported software and device updates

**Explanation and reasoning:** Apply supported, verified device updates and review management access and default credentials. Test operational compatibility and replace unsupported devices when needed. Updates do not disinfect every compromised device or absorb a flood already in progress.

**Why the other offered options do not meet the scenario:** Configuration hardening, flood scrubbing and network access rules do not apply the vendor's code fix.

**Distinct realistic example:** Compromised cameras are instructed to send coordinated traffic against an external service.

### 74. Spear phishing

Draft provenance ID: 60. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Phishing tailored to a person or group using their role, relationships or recent activity to make the approach credible.

**Scenario question:** A project-specific message requests a confidential design. Which immediate check verifies the sender through a trusted route rather than trusting familiar project details?

1. Message-sender verification — canonical defense 130
2. Email threat filtering — canonical defense 150
3. Domain-based Message Authentication, Reporting and Conformance (DMARC) — canonical defense 116
4. Executive-focused security training — canonical defense 118

**Designated answer:** Message-sender verification

**Explanation and reasoning:** Confirm the request and identity through an independently known channel before releasing information. A real compromised mailbox can still pass email authentication, so verification should include intent and authorization. Tailoring is the distinguishing feature, not proof of legitimacy.

**Why the other offered options do not meet the scenario:** Filtering, domain authentication and executive training do not independently confirm the sender's intent for this disclosure.

**Distinct realistic example:** An attacker mentions a current procurement meeting to persuade its participants to open a malicious attachment.

### 75. Watering-hole compromise

Draft provenance ID: 66. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Compromising a site or service frequented by an intended victim group so visits expose them to malicious content or credential theft.

**Scenario question:** A frequently used trade site is compromised and is now known to deliver malicious content. Which control can block access to that destination pending remediation?

1. Web destination and content filtering — canonical defense 133
2. Email threat filtering — canonical defense 150
3. Look-alike domain monitoring — canonical defense 173
4. Browser typo and look-alike warnings — canonical defense 174

**Designated answer:** Web destination and content filtering

**Explanation and reasoning:** A web filter can deny known harmful destinations or content categories and reduce exposure while the site is investigated. Encrypted traffic visibility, false positives and new sites limit coverage. Browser patching and endpoint protections remain necessary when a site has not yet been classified.

**Why the other offered options do not meet the scenario:** Mail inspection, registration discovery and typo alerts do not block a known compromised but correctly spelled web destination.

**Distinct realistic example:** An engineering community portal serves a malicious script only to visitors from selected organizations.

### 76. Trojan horse malware

Draft provenance ID: 72. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malicious software presented as useful or legitimate so a user or administrator runs it. Disguise, rather than self-replication, defines this category.

**Scenario question:** A managed workstation must run only explicitly approved applications, even if a user downloads a convincing fake utility. Which execution policy addresses that requirement?

1. Application allowlisting — canonical defense 136
2. Verified digital signatures — canonical defense 106
3. Trusted acquisition sources — canonical defense 40
4. Security scanning — canonical defense 135

**Designated answer:** Application allowlisting

**Explanation and reasoning:** Application allowlisting restricts executable content to approved identities, rules or trusted publishers. Rule design and update processes matter, and approved tools can still be abused. Signing alone does not establish that a publisher's program is safe.

**Why the other offered options do not meet the scenario:** Signatures, trusted distribution and scanning inform trust decisions but do not enforce the stated approved-executable policy.

**Distinct realistic example:** A fake video-conferencing installer also opens a covert remote-control channel.

### 77. Computer virus

Draft provenance ID: 70. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malware that attaches to a host file or other executable content and replicates when that host executes. This differs from autonomous network propagation by a worm.

**Scenario question:** A known file-infecting malware family has been identified in downloaded programs. Which listed tool detects and quarantines recognized infected files?

1. Antivirus protection — canonical defense 138
2. Application allowlisting — canonical defense 136
3. Network segmentation — canonical defense 111
4. Least privilege — canonical defense 50

**Designated answer:** Antivirus protection

**Explanation and reasoning:** Antivirus combines signatures and other detection methods to find malicious files and activity. Keep it updated and verify remediation; new or concealed malware can evade detection. Recovery may require clean rebuilding and restoration rather than trusting a single successful scan.

**Why the other offered options do not meet the scenario:** Execution allowlists, network zones and reduced privileges restrict opportunity or impact rather than identify and quarantine infected files.

**Distinct realistic example:** An infected program modifies other executable files when users run it.

### 78. Distributed denial of service

Draft provenance ID: 76. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A coordinated availability attack using multiple sources. Sources need not be infected hosts, and a high request count alone does not prove malicious intent.

**Scenario question:** A distributed flood will saturate your internet circuit before local filtering can act. Which listed service removes harmful traffic upstream before forwarding legitimate traffic?

1. Upstream DDoS scrubbing — canonical defense 140
2. Load balancing and capacity distribution — canonical defense 78
3. Network firewall rules — canonical defense 59
4. Network segmentation — canonical defense 111

**Designated answer:** Upstream DDoS scrubbing

**Explanation and reasoning:** An adequately provisioned upstream scrubbing service can absorb and filter attack traffic before the constrained link. Routing arrangements, application-layer attacks and false positives need planning. Local server capacity or an on-premises firewall cannot create missing upstream bandwidth.

**Why the other offered options do not meet the scenario:** Balancing backend work, local packet rules and network zoning do not provide upstream flood absorption before the constrained circuit.

**Distinct realistic example:** Thousands of independent sources exhaust a public service's network and request-processing capacity.

### 79. Man-in-the-middle interception

Draft provenance ID: 77. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An older term for active intermediary attacks in which an adversary relays or alters communication between parties. It substantially overlaps on-path attacks.

**Scenario question:** A browser must authenticate a site's server and protect the session against local interception. Which protocol, with correct certificate validation, supplies that protection?

1. Transport Layer Security (TLS) — canonical defense 143
2. DNS Security Extensions (DNSSEC) — canonical defense 54
3. Mutual peer authentication — canonical defense 53
4. Disable obsolete protocols and features — canonical defense 71

**Designated answer:** Transport Layer Security (TLS)

**Explanation and reasoning:** Properly configured TLS authenticates the server and protects data confidentiality and integrity in transit. Validate the intended hostname, certificate chain and protocol configuration; do not bypass certificate errors. Compromised endpoints and trusted malicious certificates remain outside a simple transport guarantee.

**Why the other offered options do not meet the scenario:** DNS authentication, mutual identity proof as a property and removal of obsolete options do not name the requested protected web-session protocol.

**Distinct realistic example:** A hostile hotspot attempts to substitute its own certificate for a banking website.

### 80. Buffer overflow

Draft provenance ID: 80. Topic type: weakness. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Writing outside an allocated memory buffer, potentially corrupting data or control flow. Read overflows are a separate confidentiality issue.

**Scenario question:** A program copies input into a fixed-size array without checking length. Which engineering practice addresses the root defect instead of merely making exploitation harder?

1. Secure software construction — canonical defense 46
2. Data Execution Prevention (DEP) — canonical defense 45
3. Application allowlisting — canonical defense 136
4. File and system integrity monitoring — canonical defense 2

**Designated answer:** Secure software construction

**Explanation and reasoning:** Use memory-safe abstractions or languages, bounds-checked APIs and validation appropriate to the object size. Test boundary cases and review unsafe interfaces. ASLR, stack canaries and DEP are complementary mitigations rather than proof that the overflow no longer exists.

**Why the other offered options do not meet the scenario:** Non-executable pages, execution policy and integrity alerts do not repair the unchecked out-of-bounds write.

**Distinct realistic example:** An oversized network message overwrites memory beyond a parser's receive buffer.

### 81. Browser-resident session manipulation

Draft provenance ID: 98. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Malicious code inside a browser or its extensions alters transactions or steals session data after transport decryption. It is distinct from a network intermediary.

**Scenario question:** A browser is suspected of modifying transactions locally. Which immediate containment action separates that affected endpoint from production access while a clean device is used?

1. Endpoint or workload isolation — canonical defense 123
2. Transport Layer Security (TLS) — canonical defense 143
3. Multi-factor authentication (MFA) — canonical defense 70
4. Application allowlisting — canonical defense 136

**Designated answer:** Endpoint or workload isolation

**Explanation and reasoning:** Isolate the compromised browser or endpoint from sensitive sessions, invalidate exposed sessions and investigate from a trusted environment. TLS cannot protect data from malicious code running at its trusted endpoint. Merely adding a browser extension is not a reliable cleanup method.

**Why the other offered options do not meet the scenario:** Transport protection, added sign-in proof and execution policy do not contain an already compromised browser session.

**Distinct realistic example:** A malicious extension changes payment details within the genuine bank page after the TLS session is established.

### 82. DNS infrastructure abuse

Draft provenance ID: 97. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A broad group of attacks against name resolution or its administration, including poisoning, hijacking, flooding and unauthorized changes. They require different defenses.

**Scenario question:** A resolver must authenticate signed DNS answers, and the team is selecting what the broad Secure DNS label means for this case. Which listed defense family should be configured specifically for DNSSEC validation?

1. Threat-specific DNS security — canonical defense 149
2. Network traffic analysis — canonical defense 141
3. Look-alike domain monitoring — canonical defense 173
4. Virtual private network (VPN) — canonical defense 145

**Designated answer:** Threat-specific DNS security

**Explanation and reasoning:** Define the DNS control explicitly: DNSSEC validates signed data, while encrypted DNS transports protect a particular resolver connection. Registrar security, resilient hosting and monitoring address other DNS threats. A vague Secure DNS checkbox must not stand in for a complete, threat-specific design.

**Why the other offered options do not meet the scenario:** Traffic analysis, look-alike domain monitoring and a VPN do not themselves validate a DNSSEC signature chain.

**Distinct realistic example:** An attacker changes a registrar account's delegation settings despite the organization's encrypted client-to-resolver traffic.

### 83. Phishing

Draft provenance ID: 59. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Deceptive communication that induces a person to reveal information, transfer value or run content. Email is common, but phishing is not limited to email.

**Scenario question:** An email gateway must quarantine known malicious attachments and suspicious links before delivery. Which listed control performs that delivery-path inspection?

1. Email threat filtering — canonical defense 150
2. Domain-based Message Authentication, Reporting and Conformance (DMARC) — canonical defense 116
3. Web destination and content filtering — canonical defense 133
4. Security simulation exercises — canonical defense 132

**Designated answer:** Email threat filtering

**Explanation and reasoning:** Email filtering can assess senders, links, attachments and known malicious patterns before mail reaches users. It can miss novel or compromised-sender attacks and needs incident reporting and endpoint defenses. A delivered message is not necessarily trustworthy merely because it passed filters.

**Why the other offered options do not meet the scenario:** Domain mail policy, web destination rules and exercises do not perform the specified attachment quarantine before mail delivery.

**Distinct realistic example:** A fake document-sharing notice leads to a sign-in page controlled by an attacker.

### 84. SMS phishing

Draft provenance ID: 62. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Deceptive text messages that lure recipients into a fraudulent site, call or software installation. Sender labels and message threads can be misleading.

**Scenario question:** A text says your account is locked and supplies a recovery link. Which user action avoids trusting that message's destination?

1. Independent navigation instead of unexpected text links — canonical defense 152
2. User security training — canonical defense 151
3. Web destination and content filtering — canonical defense 133
4. Multi-factor authentication (MFA) — canonical defense 70

**Designated answer:** Independent navigation instead of unexpected text links

**Explanation and reasoning:** Open the organization's application or enter a previously known address independently rather than using an unexpected text link. This reduces exposure to the particular lure but does not guarantee the genuine service or device is uncompromised. Verify urgent claims through trusted support.

**Why the other offered options do not meet the scenario:** Training, destination filtering and MFA are supporting safeguards; the requested immediate user action is independent navigation.

**Distinct realistic example:** A false parcel notification asks for a small card payment through a texted link.

### 85. Evil-twin wireless network

Draft provenance ID: 87. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A deceptive access point imitates a trusted network identity to attract client connections, steal authentication material or intercept traffic.

**Scenario question:** A managed Wi-Fi client must reject an enterprise authentication server whose identity is not trusted for that network. Which trust service supports validating the server certificate?

1. Certificate authority trust and identity validation — canonical defense 155
2. Virtual private network (VPN) — canonical defense 145
3. Wireless intrusion detection and prevention — canonical defense 73
4. Disable unsafe automatic network association — canonical defense 157

**Designated answer:** Certificate authority trust and identity validation

**Explanation and reasoning:** Configure the client to validate the expected authentication-server certificate and name using the appropriate CA trust policy. Possession of any certificate is not sufficient. A VPN can protect traffic after a trusted tunnel forms but cannot make a fraudulent Wi-Fi login page safe.

**Why the other offered options do not meet the scenario:** A VPN, wireless detection and auto-join policy do not supply the expected authentication-server certificate trust decision.

**Distinct realistic example:** A hotspot copies a company's network name and asks users to enter their enterprise password into a fake sign-in flow.

### 86. KARMA-style wireless impersonation

Draft provenance ID: 89. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An access point responds deceptively to clients searching for previously used networks, exploiting unsafe automatic association behavior.

**Scenario question:** Managed devices should not automatically join networks merely because a nearby responder claims a remembered name. Which client policy addresses that initial association behavior?

1. Disable unsafe automatic network association — canonical defense 157
2. MAC-address filtering — canonical defense 74
3. Suppress network-name advertisement — canonical defense 179
4. Wireless intrusion detection and prevention — canonical defense 73

**Designated answer:** Disable unsafe automatic network association

**Explanation and reasoning:** Disable unsafe automatic connection and remove obsolete network profiles, using authenticated network configuration where possible. A user can still approve a deceptive network manually. A VPN reduces some traffic exposure only after a trusted tunnel is established, not the false association itself.

**Why the other offered options do not meet the scenario:** MAC rules, hidden-name presentation and wireless detection do not change unsafe client automatic-association behavior.

**Distinct realistic example:** A laptop probing for an old guest network associates with an attacker's responding access point.

### 87. Cross-site scripting

Draft provenance ID: 78. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Untrusted content executes as script in a site's browser security context, potentially reading data or acting with the user's privileges.

**Scenario question:** A page displays an untrusted comment as plain text inside HTML. Which context-specific output treatment prevents it becoming HTML markup or script?

1. Context-aware output encoding — canonical defense 158
2. Prepared SQL statements and bound parameters — canonical defense 43
3. Context-specific escaping — canonical defense 41
4. Input and schema validation — canonical defense 25

**Designated answer:** Context-aware output encoding

**Explanation and reasoning:** Use the appropriate HTML text-context encoding at the output boundary and safe rendering APIs. Different contexts need different handling; some should never accept untrusted interpolation. CSP is defense in depth, and sanitization is needed when intentionally allowing a restricted subset of HTML.

**Why the other offered options do not meet the scenario:** SQL binding, shell escaping and input checking do not encode untrusted plain text for its HTML output context.

**Distinct realistic example:** A stored comment executes code for every administrator who views it because it is inserted as markup.

### 88. Path traversal

Draft provenance ID: 79. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Manipulating file-path input to access data outside an intended directory or resource scope.

**Scenario question:** A download service accepts a filename and must reject paths that resolve outside an approved root. Which operation supports checking the resolved path rather than the raw spelling?

1. Path canonicalization and confinement checks — canonical defense 161
2. Resource access controls — canonical defense 48
3. Input and schema validation — canonical defense 25
4. Context-aware output encoding — canonical defense 158

**Designated answer:** Path canonicalization and confinement checks

**Explanation and reasoning:** Canonicalize and validate the resolved path against an authorized root, with platform-specific separators and encoding handled correctly. Prefer safe file APIs and explicit identifiers. Symbolic links and check/use races can defeat a naive string-prefix test even after normalization.

**Why the other offered options do not meet the scenario:** Permissions, general input checks and HTML encoding do not specify canonical file-path resolution and confinement.

**Distinct realistic example:** A crafted filename makes a document server read an operating-system file instead of a user's export.

### 89. Forged Wi-Fi deauthentication

Draft provenance ID: 88. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Sending forged management messages to disconnect wireless clients when the relevant management frames lack effective protection.

**Scenario question:** Compatible wireless infrastructure and clients must reject forged protected management messages. Which Wi-Fi mechanism addresses that frame-authentication problem?

1. Protected Management Frames (802.11w) — canonical defense 163
2. MAC-address filtering — canonical defense 74
3. Device firmware security updates — canonical defense 62
4. Disable unsafe automatic network association — canonical defense 157

**Designated answer:** Protected Management Frames (802.11w)

**Explanation and reasoning:** Protected Management Frames, introduced through 802.11w, protect specified robust management frames when negotiated and enforced. They do not protect every management frame or defeat radio jamming. Verify client compatibility and actual configuration rather than assuming the label covers all wireless denial of service.

**Why the other offered options do not meet the scenario:** MAC rules, software updates and auto-join restrictions do not name the management-frame authentication feature.

**Distinct realistic example:** A nearby sender repeatedly disconnects clients from an older unprotected wireless network.

### 90. Packet capture and sniffing

Draft provenance ID: 84. Topic type: potentially_legitimate_activity. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Collecting network packets for analysis. It can support authorized troubleshooting or unauthorized surveillance; intent and permission determine the context.

**Scenario question:** An analyst must protect application contents from an unauthorized passive observer on the network. Which control makes those contents unreadable in transit when implemented correctly?

1. Authenticated data encryption — canonical defense 10
2. Intrusion detection systems (IDS) — canonical defense 164
3. Network firewall rules — canonical defense 59
4. Dynamic ARP Inspection — canonical defense 56

**Designated answer:** Authenticated data encryption

**Explanation and reasoning:** Authenticated encryption protects content against observers and active alteration on the protected path. Traffic timing, addresses and sizes may remain visible. Encryption must terminate at trusted endpoints; authorized capture is still useful for troubleshooting without declaring every observer malicious.

**Why the other offered options do not meet the scenario:** Detection, flow policy and ARP inspection do not make captured application contents cryptographically unreadable.

**Distinct realistic example:** A network administrator captures packets under an approved incident-response procedure while an attacker captures them without permission.

### 91. Identity impersonation

Draft provenance ID: 65. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Pretending to be a trusted person or entity to gain access, information or action. It may be digital or physical.

**Scenario question:** A person requests a replacement employee credential. Which procedure checks that the claimant is actually the employee before an account is recovered?

1. Identity proofing and verification — canonical defense 166
2. Authentication assertion checks — canonical defense 26
3. Multi-factor authentication (MFA) — canonical defense 70
4. Message-sender verification — canonical defense 130

**Designated answer:** Identity proofing and verification

**Explanation and reasoning:** Use identity verification proportionate to recovery risk, with evidence and independent channels that an attacker cannot easily supply. A verified identity still needs authorization for the requested operation. Avoid making public biographical information the decisive proof.

**Why the other offered options do not meet the scenario:** Token validation, a returning user's authentication factors and email identity differ from proofing the claimant during recovery.

**Distinct realistic example:** A visitor borrows an employee's name and job title to request internal access.

### 92. Baiting with removable media

Draft provenance ID: 68. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Offering something attractive, such as a labeled USB drive, to induce unsafe handling that exposes a device or information.

**Scenario question:** Unapproved USB storage is being left near an office entrance. Which endpoint policy can prevent those storage devices from mounting on managed workstations?

1. USB device control — canonical defense 168
2. Application allowlisting — canonical defense 136
3. System hardening — canonical defense 93
4. Safer web use — canonical defense 139

**Designated answer:** USB device control

**Explanation and reasoning:** Device-control policy can block unapproved USB storage or require explicitly authorized devices. Distinguish storage from other USB device classes and preserve legitimate operational needs. Scanning alone may miss unknown malware or a device that emulates a keyboard.

**Why the other offered options do not meet the scenario:** Execution policy, baseline configuration and safer browsing do not specify device-class rules preventing a USB storage mount.

**Distinct realistic example:** A drive labeled Salary Review tempts employees to connect it to a work computer.

### 93. Tailgating into a controlled area

Draft provenance ID: 69. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Following an authorized person through an access boundary without completing required individual entry checks.

**Scenario question:** A laboratory needs a controlled vestibule that checks one person's authorization before the next door opens. Which physical control supplies it?

1. Access-control vestibules — canonical defense 170
2. Visitor escort procedures — canonical defense 98
3. Electronic physical access security — canonical defense 100
4. Physical intrusion alarms — canonical defense 178

**Designated answer:** Access-control vestibules

**Explanation and reasoning:** A correctly designed access-control vestibule can enforce one-at-a-time entry and reduce unnoticed following. Emergency egress, accessibility and safe operating procedures must be designed in. The terms tailgating and piggybacking vary; the learning scenario states the actual behavior.

**Why the other offered options do not meet the scenario:** Escorting, electronic access and alarms are distinct from a controlled one-person entry vestibule.

**Distinct realistic example:** An unauthorized person carries a box and follows staff through a badge-controlled door.

### 94. Typosquatting

Draft provenance ID: 67. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Registering or using a domain resembling a legitimate name through spelling mistakes or similar characters to attract or deceive users.

**Scenario question:** Your security team wants early notice of newly registered look-alike domains. Which control watches registrations rather than relying only on user reports?

1. Look-alike domain monitoring — canonical defense 173
2. Domain-based Message Authentication, Reporting and Conformance (DMARC) — canonical defense 116
3. Email threat filtering — canonical defense 150
4. Web destination and content filtering — canonical defense 133

**Designated answer:** Look-alike domain monitoring

**Explanation and reasoning:** Domain monitoring can find suspicious registrations and support investigation, warnings and takedown. Similar spelling alone is not proof of abuse. It does not stop someone from visiting a malicious site before detection. Use the finding to investigate actual behavior; unrelated legitimate owners can also hold similar names.

**Why the other offered options do not meet the scenario:** Mail-domain policy and mail or browsing filters do not provide the requested look-alike registration discovery.

**Distinct realistic example:** A fake vendor address differs from the genuine domain by one missing letter.

### 95. Hash collision exploitation

Draft provenance ID: 83. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Finding or exploiting two different messages with the same hash value to undermine a use that assumes collision resistance. This does not necessarily find a preimage for a chosen digest.

**Scenario question:** A document-signing workflow relies on a hash with practical collision attacks. Which policy requires replacing that broken primitive with a suitable current one?

1. Appropriate modern cryptographic algorithms — canonical defense 176
2. Credential and key rotation — canonical defense 185
3. Adequate cryptographic output length — canonical defense 95
4. Cryptographic key management — canonical defense 183

**Designated answer:** Appropriate modern cryptographic algorithms

**Explanation and reasoning:** Use a cryptographic primitive whose security properties fit the workflow and whose collision resistance remains supported. Migration includes protocol and interoperability review. HMAC can authenticate messages with a shared secret but is not a drop-in replacement for a public digital-signature design.

**Why the other offered options do not meet the scenario:** Key rotation, a longer output and key custody do not establish that a collision-broken primitive has been replaced safely.

**Distinct realistic example:** Two specially constructed documents share a digest under a broken hash and undermine a signature workflow.

### 96. Forced physical entry

Draft provenance ID: 90. Topic type: attack. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Breaking or forcing a physical access boundary rather than opening it with an authorized credential or manipulating its lock mechanism.

**Scenario question:** A facility needs greater resistance to a door being kicked open. Which listed measure strengthens that physical barrier?

1. Reinforced doors and entry assemblies — canonical defense 177
2. Physical security personnel — canonical defense 172
3. High-security mechanical locks — canonical defense 99
4. Electronic physical access security — canonical defense 100

**Designated answer:** Reinforced doors and entry assemblies

**Explanation and reasoning:** Use an appropriately rated door, frame, hinges and anchoring as an integrated assembly. A stronger panel with a weak frame is not sufficient. Entry resistance must be balanced with fire egress and accessibility; it delays attackers rather than guaranteeing prevention.

**Why the other offered options do not meet the scenario:** Human response, a pick-resistant cylinder and electronic access do not strengthen the whole door and frame against force.

**Distinct realistic example:** An intruder forces a poorly anchored service door despite its undamaged lock cylinder.

### 97. Wireless network surveying (wardriving)

Draft provenance ID: 99. Topic type: potentially_legitimate_activity. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Discovering and mapping wireless networks from a moving location. It may be authorized research or surveying; mapping alone is not an intrusion.

**Scenario question:** An authorized survey can still observe your network name. Which control protects the content of wireless communications instead of trying to conceal that public radio identifier?

1. Authenticated data encryption — canonical defense 10
2. MAC-address filtering — canonical defense 74
3. Disable unsafe automatic network association — canonical defense 157
4. Radio frequency hopping — canonical defense 18

**Designated answer:** Authenticated data encryption

**Explanation and reasoning:** Use properly authenticated modern wireless encryption to protect transmitted content. Encryption does not prevent detection of radio transmissions, network names or all metadata. Surveying must follow authorization and privacy rules; do not teach that wardriving inherently proves malicious intent.

**Why the other offered options do not meet the scenario:** MAC filtering regulates associations, disabling auto-connect changes client behavior and frequency hopping is not a substitute for authenticated content encryption.

**Distinct realistic example:** A contracted wireless assessor maps coverage and records access points with the owner's permission.

### 98. False or misleading information

Draft provenance ID: 64. Topic type: category. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Inaccurate information that may be spread accidentally or deliberately. Deliberate deception is often called disinformation; falsity alone does not prove intent.

**Scenario question:** A widely shared breach claim has no linked evidence. Which analytical step checks the underlying facts against independent reliable material?

1. Evidence-based fact checking — canonical defense 180
2. Operational security monitoring — canonical defense 27
3. Look-alike domain monitoring — canonical defense 173
4. Threat intelligence — canonical defense 108

**Designated answer:** Evidence-based fact checking

**Explanation and reasoning:** Verify primary evidence, dates, context and independent corroboration before repeating the claim. A source's popularity does not establish accuracy, and uncertainty should remain visible. Content moderation is a policy action, not a substitute for verifying whether a claim is true.

**Why the other offered options do not meet the scenario:** Observation, domain discovery and threat information do not replace checking this claim's primary evidence and context.

**Distinct realistic example:** An old outage screenshot is circulated as proof of a new compromise.

### 99. Known-plaintext cryptanalysis

Draft provenance ID: 85. Topic type: analysis_model. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Analysis using plaintext/ciphertext pairs already known to the adversary to investigate an encryption system. Secure modern designs anticipate such exposure.

**Scenario question:** A proprietary encryption scheme fails when predictable headers are known. Which established symmetric primitive can underpin a reviewed replacement instead of inventing another cipher?

1. Advanced Encryption Standard (AES) — canonical defense 182
2. SHA-3 hashing — canonical defense 94
3. Credential and key rotation — canonical defense 185
4. Authenticated encryption with associated data (AEAD) — canonical defense 16

**Designated answer:** Advanced Encryption Standard (AES)

**Explanation and reasoning:** AES is a standardized block cipher that must be used in an appropriate authenticated mode with sound key and nonce handling. Merely naming AES is not a complete system design. Known plaintext is a normal security assumption, not automatic evidence that every cipher is broken.

**Why the other offered options do not meet the scenario:** A hash, key replacement and an authenticated-encryption construction are not the specific standardized symmetric block cipher requested.

**Distinct realistic example:** Predictable file-format headers expose known message portions to an analyst studying a weak cipher.

### 100. Ciphertext-only cryptanalysis

Draft provenance ID: 86. Topic type: analysis_model. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Studying encrypted messages without known plaintext to infer information or attack a weak scheme. Even secure encryption can expose metadata such as length.

**Scenario question:** A developer proposes an unreviewed cipher because intercepted messages appear unreadable. Which engineering rule calls for well-reviewed standards and correct implementations instead?

1. Reviewed cryptographic standards and designs — canonical defense 184
2. Adequate cryptographic output length — canonical defense 95
3. Cryptographic key management — canonical defense 183
4. Advanced Encryption Standard (AES) — canonical defense 182

**Designated answer:** Reviewed cryptographic standards and designs

**Explanation and reasoning:** Choose established cryptographic constructions with security properties suited to the application, then test implementation and key use. Lack of readable text is not evidence of cryptographic strength. Randomness, nonce uniqueness and authenticated encryption matter alongside standards selection.

**Why the other offered options do not meet the scenario:** Output length, key custody and one named primitive do not establish the complete standards-based design and implementation policy.

**Distinct realistic example:** A repeated-pattern homegrown cipher reveals structure across many intercepted encrypted records.

## Defense explanations

### Defense 1. Hypervisor hardening

Draft provenance ID: 8. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reducing weaknesses and exposed interfaces in the software and host that run virtual machines.

**How it works:** Patch the host, restrict management access, minimize emulated devices and isolate administrative functions.

**Applicable conditions:** Relevant to guest-to-host attack paths and multi-tenant isolation boundaries.

**Important limitations:** Unknown flaws, vulnerable host firmware and excessive device passthrough can remain. Guest isolation needs more than a configuration checklist.

**Realistic example:** A virtualization team removes unused virtual devices and limits host administration to a separate management network.

### Defense 2. File and system integrity monitoring

Draft provenance ID: 24. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Comparing protected resources with trusted expected state to detect unauthorized changes.

**How it works:** Record baselines and alert on relevant file, configuration or boot-state differences using protected evidence.

**Applicable conditions:** Useful where changes can be distinguished from authorized maintenance and alerts are investigated.

**Important limitations:** An attacker controlling the monitor or baseline can hide changes. A rootkit may deceive tools running inside its own compromised OS.

**Realistic example:** A monitored server alerts when a protected system binary changes outside the maintenance window.

### Defense 3. Secure Boot and startup trust

Draft provenance ID: 25. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A boot-chain mechanism that verifies permitted boot components before loading them.

**How it works:** Firmware trust policy checks signatures or allowed measurements for the relevant startup code.

**Applicable conditions:** Useful for reducing unauthorized bootloaders and some boot-level persistence when keys and configuration are managed.

**Important limitations:** Signed vulnerable components, compromised firmware and post-boot attacks remain concerns. It is not proof that the whole running OS is clean.

**Realistic example:** A workstation refuses an unsigned replacement bootloader after an attempted bootkit installation.

### Defense 4. Process memory inspection

Draft provenance ID: 26. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Examining active memory for malicious code, injected regions or suspicious state.

**How it works:** Endpoint tools inspect executable mappings, process relationships and memory artifacts unavailable to file-only scans.

**Applicable conditions:** Useful for memory-resident activity when tooling has sufficient access and evidence is collected safely.

**Important limitations:** Protected processes, evasion and short-lived activity can limit visibility. Memory collection can expose sensitive data and needs controls.

**Realistic example:** An analyst identifies injected executable memory in a normally trusted process.

### Defense 5. Behavioral security analytics

Draft provenance ID: 27. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Analysis of sequences and relationships of system activity to identify suspicious behavior.

**How it works:** Correlate process, identity and network events instead of relying solely on a matching malicious file hash.

**Applicable conditions:** Useful for fileless execution and abuse of legitimate tools when telemetry is sufficiently complete.

**Important limitations:** Unusual behavior can be legitimate and common behavior can be malicious. Alerts need investigation and tuning.

**Realistic example:** A script interpreter spawning an unexpected credential-access tool triggers a correlated alert.

### Defense 6. Source verification

Draft provenance ID: 1. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Checking whether a claimed origin is consistent with trusted evidence.

**How it works:** For IP traffic, validate source addresses against legitimate network prefixes; for messages, use authenticated channels and independently verified identities.

**Applicable conditions:** Choose the mechanism for the actual layer: network anti-spoofing and email identity verification are not interchangeable.

**Important limitations:** A plausible address or familiar display name is not proof. Local filtering cannot stop forged traffic sent by other networks.

**Realistic example:** An ISP rejects a customer packet claiming an external source prefix.

### Defense 7. Time-based one-time authentication codes

Draft provenance ID: 20. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Short-lived authentication values derived from a secret and a time interval.

**How it works:** The verifier checks codes within a limited window, with replay controls and rate limiting.

**Applicable conditions:** Useful as an additional authentication factor when secrets and recovery processes are protected.

**Important limitations:** Codes can be phished or relayed in real time, and may be replayable inside the accepted interval if not tracked.

**Realistic example:** A user signs in with a password and an authenticator code, while the service rejects code reuse.

### Defense 8. Authenticated nonces and freshness checks

Draft provenance ID: 21. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Unique values used to bind an operation to a fresh protocol exchange.

**How it works:** Include a nonce in the authenticated message and verify its expected value or non-reuse at the receiver.

**Applicable conditions:** Useful for replay-resistant authentication and device commands with adequate state or challenge handling.

**Important limitations:** A random value that is neither authenticated nor checked does not prevent replay. Reset and concurrency behavior need design.

**Realistic example:** A controller rejects an old signed unlock response because it does not match the current challenge.

### Defense 9. Security configuration and access audits

Draft provenance ID: 33. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Structured examination of controls, permissions and configuration against an intended baseline.

**How it works:** Inspect effective access and evidence, record deviations and track remediation to verification.

**Applicable conditions:** Useful for finding public cloud exposure, excessive privileges and drift in deployed environments.

**Important limitations:** An audit is a point-in-time or scheduled check, not automatic enforcement. Findings do not fix themselves.

**Realistic example:** A storage audit identifies an unintended anonymous-read policy and verifies its subsequent removal.

### Defense 10. Authenticated data encryption

Draft provenance ID: 34. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Cryptographic protection of data confidentiality with integrity and identity checks appropriate to the context.

**How it works:** Use suitable protocols or storage constructions and protect keys at trusted endpoints.

**Applicable conditions:** Useful against unauthorized reading or modification of data on a protected path or medium.

**Important limitations:** Encryption at rest does not override public read authorization. Traffic metadata and compromised endpoints can remain exposed.

**Realistic example:** A captured application session reveals encrypted payloads but still shows packet sizes and destination addresses.

### Defense 11. Migration from WEP to supported WPA3

Draft provenance ID: 7. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Replacing obsolete WEP wireless security with a supported modern Wi-Fi security configuration.

**How it works:** Compatible clients and access points negotiate WPA3 authentication and encryption instead of WEP.

**Applicable conditions:** Requires an inventory, tested client compatibility and a plan to remove obsolete modes and unsafe fallback.

**Important limitations:** It does not stop radio jamming or compromised clients. An interim supported WPA2-AES configuration may be needed for assessed compatibility.

**Realistic example:** A warehouse retires WEP-only scanners before enabling a WPA3-only network.

### Defense 12. Cost-tuned password hashing

Draft provenance ID: 32. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Storing password verification data using a suitable salted password-derivation function rather than a fast general hash.

**How it works:** A deliberately expensive computation raises the cost of each offline candidate, with unique salts preventing shared precomputation.

**Applicable conditions:** Use an appropriate current KDF, measured resource costs and a migration strategy for older hashes.

**Important limitations:** Weak passwords can still be guessed; excessive cost can overload the service. A generic strong hash such as plain SHA is not sufficient.

**Realistic example:** A password service upgrades verified logins to a current cost-tuned password-hash format.

### Defense 13. Anti-spyware protection

Draft provenance ID: 19. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Endpoint detection and removal focused on unauthorized monitoring software.

**How it works:** Recognize known spyware or suspicious collection behavior, then quarantine and investigate affected components.

**Applicable conditions:** Useful with current detection information, appropriate privileges and a response process.

**Important limitations:** Novel, privileged or concealed surveillance can evade detection. Already stolen information and credentials require separate response.

**Realistic example:** A managed endpoint quarantines a program that records browsing activity without authorization.

### Defense 14. Privacy and permission settings

Draft provenance ID: 18. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Platform controls limiting which applications or parties can access personal data and sensors.

**How it works:** Restrict unnecessary permissions, tracking features, audience visibility and data-sharing defaults.

**Applicable conditions:** Useful before granting access and during periodic application permission review.

**Important limitations:** A privileged malicious program may bypass these controls; a setting is not a substitute for malware removal.

**Realistic example:** A mobile application loses microphone and location access when those capabilities are not needed.

### Defense 15. Dedicated cloud hosting resources

Draft provenance ID: 6. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reducing resource sharing with other tenants through a specified isolation arrangement.

**How it works:** Dedicated hosts or other provider guarantees reduce co-residency on the protected hardware resource.

**Applicable conditions:** Relevant to a demonstrated shared-resource threat and sensitive workloads with an assessed hosting requirement.

**Important limitations:** A dedicated virtual instance may still share physical hardware. Host, firmware and workload leakage can remain.

**Realistic example:** A sensitive computation moves to an explicitly dedicated physical host after a cache-sharing risk assessment.

### Defense 16. Authenticated encryption with associated data (AEAD)

Draft provenance ID: 2. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Encryption that also authenticates the ciphertext and optional unencrypted associated data.

**How it works:** A keyed tag is verified before application plaintext is accepted, preventing undetected ciphertext modification when the construction is used correctly.

**Applicable conditions:** Use a reviewed AEAD construction with protected keys, correct nonce requirements and safe error handling.

**Important limitations:** Nonce misuse, implementation defects or an exposed key can defeat protection. Associated data is authenticated but not encrypted.

**Realistic example:** A service rejects an altered encrypted token instead of processing its modified contents.

### Defense 17. Controlled security change

Draft provenance ID: 3. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A governed process for making and verifying security-relevant system changes.

**How it works:** Record the reason, authorize the change, test a reviewed design, deploy safely and verify results with a rollback plan.

**Applicable conditions:** Useful for migrating away from a broken cipher or unsafe configuration once a concrete corrective design exists.

**Important limitations:** It is management support, not a cryptographic primitive or evidence that a chosen replacement is secure.

**Realistic example:** A team stages a tested encryption-library migration rather than patching a cipher ad hoc.

### Defense 18. Radio frequency hopping

Draft provenance ID: 28. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A supported communication method that changes radio channels according to an agreed scheme.

**How it works:** Channel diversity can reduce disruption from interference occupying only part of the available spectrum.

**Applicable conditions:** Relevant to compatible radio systems and assessed narrow-band interference within regulatory limits.

**Important limitations:** It does not defeat all jamming, authenticate users or replace encryption; wideband interference can affect every hop.

**Realistic example:** A supported industrial radio link moves among permitted channels while an alternate communication path is prepared.

### Defense 19. Protected and tested backups

Draft provenance ID: 29. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Independent data copies and recovery procedures for restoring information after loss or corruption.

**How it works:** Keep recoverable versions with isolation or immutability, separate credentials and regular restore testing.

**Applicable conditions:** Useful for ransomware recovery, accidental deletion and other data-loss events.

**Important limitations:** Backups do not stop infection or undo exfiltration. A copy writable through compromised credentials may be encrypted too.

**Realistic example:** A recovery team restores a clean file-server version from immutable storage after containing ransomware.

### Defense 20. Disable Bluetooth discoverability

Draft provenance ID: 4. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Stopping routine Bluetooth discovery advertisements when a device does not need to be found.

**How it works:** The device limits how it announces its availability for discovery and pairing.

**Applicable conditions:** Useful after legitimate pairing and where platform behavior permits connections without continual discovery.

**Important limitations:** Known addresses and vulnerable services may remain reachable. This does not patch Bluetooth or make the radio invisible.

**Realistic example:** A paired headset remains usable while a phone stops inviting new discovery.

### Defense 21. Independent callback verification

Draft provenance ID: 11. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Confirming a voice request through a separately trusted contact route.

**How it works:** End the unexpected call and use a known directory, established number or approved support workflow.

**Applicable conditions:** Useful for requests involving credentials, money, recovery or sensitive information.

**Important limitations:** Caller ID and voice familiarity can be spoofed. A number provided by the suspicious caller is not independent evidence.

**Realistic example:** An employee verifies a supposed IT call through the organization's published help-desk extension.

### Defense 22. Authenticated secure communication channels

Draft provenance ID: 10. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Communication that protects data in transit and authenticates the intended peer where configured.

**How it works:** Protocols such as appropriately validated TLS prevent undetected interception on their protected path.

**Applicable conditions:** Useful when both the endpoint identity and the transport security configuration are verified.

**Important limitations:** Encryption does not make a fraudulent caller honest or protect plaintext after an endpoint is compromised.

**Realistic example:** A help desk uses an authenticated portal rather than accepting sensitive requests through an unverified caller.

### Defense 23. Challenge-response authentication

Draft provenance ID: 12. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An identity check in which a claimant answers a fresh challenge using an appropriate secret or possession factor.

**How it works:** The verifier checks a response bound to the challenge and rejects reused or invalid proofs.

**Applicable conditions:** Suitable when the protocol, factor and verification channel are designed to resist replay and impersonation.

**Important limitations:** Public trivia questions are weak. A verified identity still requires authorization for the requested action.

**Realistic example:** A registered authenticator signs a new server challenge during an approved identity check.

### Defense 24. Privacy policies and handling rules

Draft provenance ID: 13. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Statements and procedures describing how personal information is collected, used, shared and disposed of.

**How it works:** Operational rules can define permitted disclosures and disposal responsibilities; a public notice communicates those practices.

**Applicable conditions:** Relevant to information governance when procedures are implemented and enforced.

**Important limitations:** A notice does not authenticate a requester, shred a document or stop social engineering by itself.

**Realistic example:** A reception procedure prohibits disclosing staff contact details without a verified business purpose.

### Defense 25. Input and schema validation

Draft provenance ID: 39. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Checking untrusted data against an explicit expected structure and allowed values.

**How it works:** Apply server-side type, length, format and business-rule checks before using input.

**Applicable conditions:** Useful for APIs, event data and command parameters when rules reflect the true operation.

**Important limitations:** Syntactic validity does not prove authenticity or authorization. Validation alone does not replace parameterized SQL or context-safe output handling.

**Realistic example:** A function rejects an event whose resource identifier is outside its documented format.

### Defense 26. Authentication assertion checks

Draft provenance ID: 40. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Verifying that an identity claim is genuine and valid for the intended context.

**How it works:** Check protocol-specific signatures, issuer, audience, expiration and freshness before creating a session.

**Applicable conditions:** Useful when services accept authentication tokens, federated assertions or signed requests.

**Important limitations:** Authentication does not automatically authorize every requested action. Checking only token syntax or an algorithm label is insufficient.

**Realistic example:** A relying service rejects a signed token issued for a different application audience.

### Defense 27. Operational security monitoring

Draft provenance ID: 37. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Collecting and examining events to identify conditions requiring investigation or response.

**How it works:** Use relevant logs, network observations and alerts with defined ownership and retention.

**Applicable conditions:** Useful for brand abuse, compromised devices and other observable security activity.

**Important limitations:** Monitoring does not automatically prevent an event, and missing or tampered telemetry creates blind spots.

**Realistic example:** A team correlates unexpected outbound connections with endpoint alerts before isolating a suspected bot.

### Defense 28. Security awareness education

Draft provenance ID: 38. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Instruction that helps people recognize risks and follow workable protective practices.

**How it works:** Use relevant examples, reporting routes and reinforcement suited to actual job decisions.

**Applicable conditions:** Useful for phishing, suspicious downloads and deceptive domains alongside technical safeguards.

**Important limitations:** Education cannot guarantee that every person detects every attack. Poorly designed processes can defeat even trained staff.

**Realistic example:** A workshop shows how to verify a vendor URL using a known bookmark rather than a search advertisement.

### Defense 29. Secure paper shredding

Draft provenance ID: 14. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Physical destruction that makes sensitive paper information impractical to reconstruct at the required risk level.

**How it works:** An appropriate shredder or vetted destruction service reduces paper to sufficiently small fragments with controlled custody.

**Applicable conditions:** Use for paper records at end of retention, with a method suited to their sensitivity.

**Important limitations:** Ordinary tearing may be insufficient. Drives and flash memory need technology-appropriate sanitization or destruction instead.

**Realistic example:** An office transfers confidential paper from locked collection bins to a verified destruction service.

### Defense 30. Locked waste containers

Draft provenance ID: 15. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Physical access control over discarded material before secure collection or destruction.

**How it works:** Locks, placement and collection procedures reduce unauthorized access to bins and disposal areas.

**Applicable conditions:** Useful during the interval between discarding material and its final destruction.

**Important limitations:** The contents remain recoverable if the container or collection chain is breached. Locking is not sanitization.

**Realistic example:** A data center uses locked document bins inside a restricted service area.

### Defense 31. Screen privacy filters

Draft provenance ID: 16. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A display accessory or feature that reduces readability from off-axis viewing angles.

**How it works:** The screen remains usable from the intended position while side views are darkened or obscured.

**Applicable conditions:** Useful for sensitive work in shared spaces along with suitable seating and awareness.

**Important limitations:** It does not block a directly positioned camera, protect keyboard entry or secure an unlocked session.

**Realistic example:** A traveling employee adds a privacy filter and avoids opening sensitive documents near an overlooking seat.

### Defense 32. Biometric authentication

Draft provenance ID: 17. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Using measured physical or behavioral characteristics as part of identity verification.

**How it works:** A sensor compares a captured characteristic with an enrolled reference under an appropriate authentication design.

**Applicable conditions:** Use with protected templates, presentation-attack controls and suitable fallback; local biometrics often unlock a device-bound credential.

**Important limitations:** Biometrics are not easily replaced secrets and do not automatically authenticate a remote caller. Compromised endpoints can still misuse sessions.

**Realistic example:** A workstation uses a fingerprint to unlock a device-bound sign-in key rather than a reusable typed password.

### Defense 33. Environmental monitoring sensors

Draft provenance ID: 30. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Instruments that measure physical conditions affecting systems or facilities.

**How it works:** Temperature, water, smoke or power sensors report values and trigger actionable alerts.

**Applicable conditions:** Useful where thresholds, calibration, response responsibility and communications are maintained.

**Important limitations:** An alert does not repair the equipment or prove deliberate interference. Sensors can fail or be positioned badly.

**Realistic example:** A water detector beneath cooling equipment alerts operators before leakage reaches a rack.

### Defense 34. Operational redundancy

Draft provenance ID: 31. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Additional components or service paths that preserve availability when one fails.

**How it works:** Replicate critical capability and test failover with sufficiently independent failure domains.

**Applicable conditions:** Useful for power, network or service failures when alternate capacity is actually usable.

**Important limitations:** Shared dependencies, replicated bad configuration and correlated attacks can disable both paths. Redundancy is not a data backup.

**Realistic example:** A service fails over to an independent power and network path during a facility incident.

### Defense 35. Supported software removal tools

Draft provenance ID: 35. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Installation-management or remediation tools that remove unwanted applications and related components.

**How it works:** Identify packages, uninstall safely and verify that associated services or persistence are removed.

**Applicable conditions:** Useful for unnecessary software on a trusted system or as part of a defined malware response.

**Important limitations:** Some removals break dependencies; malware can survive incomplete cleanup. Privileged compromise may require rebuilding.

**Realistic example:** An endpoint administrator removes unused trial software from a fleet image and checks remaining services.

### Defense 36. Clean system rebuilding

Draft provenance ID: 36. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reinstalling a system from a verified trusted image and restoring only assessed data and configuration.

**How it works:** Replace potentially compromised operating-system state instead of trying to identify every altered component.

**Applicable conditions:** Useful after serious compromise when trust cannot be restored by selective removal.

**Important limitations:** Restoring infected backups, compromised firmware or stolen credentials can reintroduce the problem. Preserve required evidence first.

**Realistic example:** A server is rebuilt from a controlled image after root compromise, with credentials replaced separately.

### Defense 37. Post-quantum cryptography

Draft provenance ID: 9. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Cryptographic algorithms designed to resist known attacks using sufficiently capable quantum computers.

**How it works:** Replace vulnerable public-key operations through supported standardized algorithms and protocol implementations.

**Applicable conditions:** Use an inventory of cryptographic dependencies and required confidentiality lifetime to plan tested migration.

**Important limitations:** Not every primitive has the same quantum exposure. Migration errors, weak implementations and compromised endpoints remain risks.

**Realistic example:** A long-term archive plans a supported post-quantum key-establishment transition with interoperability testing.

### Defense 38. Disable unused Bluetooth

Draft provenance ID: 5. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Turning off a device's Bluetooth radio or service when it is unnecessary.

**How it works:** Removing the active communication path prevents Bluetooth exchanges while disabled.

**Applicable conditions:** Appropriate for devices whose current workflow does not require Bluetooth peripherals or data transfer.

**Important limitations:** It does not fix other radios or remove malware already installed; operating-system controls must actually disable the interface.

**Realistic example:** A kiosk with wired peripherals has Bluetooth disabled in its managed configuration.

### Defense 39. Browser advertising blockers

Draft provenance ID: 23. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Tools that filter selected advertising requests or page elements.

**How it works:** Request rules and content filters reduce exposure to unwanted advertising and some malicious advertising paths.

**Applicable conditions:** Useful within supported browsers where rules and extension permissions are managed responsibly.

**Important limitations:** They do not uninstall every adware application, detect all malware or guarantee a permitted site is safe.

**Realistic example:** A browser blocks advertising requests on a site while endpoint staff investigate a bundled advertising program.

### Defense 40. Trusted acquisition sources

Draft provenance ID: 22. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Obtaining software or information through an independently established and verified source.

**How it works:** Check publisher identity, distribution route and integrity rather than accepting a convenient download mirror.

**Applicable conditions:** Useful for reducing fake installers and misleading advice in everyday workflows.

**Important limitations:** Reputable publishers and their build pipelines can be compromised. Familiarity and search ranking do not prove integrity.

**Realistic example:** An administrator retrieves an installer from the known vendor portal and verifies its release signature.

### Defense 41. Context-specific escaping

Draft provenance ID: 57. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Representing special characters so a specific interpreter treats them as literal data.

**How it works:** Apply the correct library and rules for the actual interpreter and encoding context.

**Applicable conditions:** Useful only where avoiding that interpreter or using separated arguments is not possible.

**Important limitations:** Shell quoting can be fragile and may not prevent argument injection. SQL, HTML and shell escaping are not interchangeable.

**Realistic example:** A legacy integration uses a reviewed escaping library while being migrated away from shell command construction.

### Defense 42. Allowlisting permitted operations

Draft provenance ID: 58. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Restricting accepted inputs, commands or identities to a defined approved set.

**How it works:** Reject values outside a small, explicit server-side policy and avoid arbitrary interpreter construction.

**Applicable conditions:** Useful when a service should offer only documented operations or controlled parameter forms.

**Important limitations:** An overly broad allowlist or unsafe downstream interpretation can still be exploitable. The approved set needs maintenance.

**Realistic example:** An administrative API accepts only enumerated maintenance operation names and uses library calls to execute them.

### Defense 43. Prepared SQL statements and bound parameters

Draft provenance ID: 76. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Database interfaces that keep supplied values separate from SQL program structure.

**How it works:** The driver binds data values to a fixed query rather than concatenating them into executable SQL.

**Applicable conditions:** Useful for database access paths that support parameterization and appropriately scoped database permissions.

**Important limitations:** Identifiers and dynamic query structure require controlled selection; parameterizing one path does not fix another unsafe path.

**Realistic example:** A search query binds the user's search term through a parameter rather than inserting it into SQL text.

### Defense 44. Web application firewall (WAF)

Draft provenance ID: 77. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A control that inspects HTTP traffic and applies application-focused filtering policy.

**How it works:** Rules or behavioral checks identify and block selected malicious request patterns before the application handles them.

**Applicable conditions:** Useful as a supplementary layer, including temporary mitigation while an application defect is repaired.

**Important limitations:** Bypasses, false positives, protocol differences and encrypted visibility limits remain. It does not replace safe application code.

**Realistic example:** A WAF rule blocks a known exploit request while developers repair the vulnerable endpoint.

### Defense 45. Data Execution Prevention (DEP)

Draft provenance ID: 66. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A memory-protection mechanism that prevents execution from pages not marked executable.

**How it works:** Processor and operating-system page protections enforce executable versus non-executable memory regions.

**Applicable conditions:** Useful as one layer against injected code in data pages and some memory-corruption exploitation.

**Important limitations:** It does not stop every memory write or code-reuse attack; legitimate executable mappings and other bypass paths remain.

**Realistic example:** A process terminates when an exploit tries to execute injected bytes from a non-executable data page.

### Defense 46. Secure software construction

Draft provenance ID: 67. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Engineering practices that remove security defects through appropriate design, APIs, languages and verification.

**How it works:** Use memory-safe abstractions, explicit authorization, separated data and commands, tests and review appropriate to the threat.

**Applicable conditions:** Useful for preventing root causes rather than relying only on exploit mitigations.

**Important limitations:** The label is broad: each defect needs a concrete practice and verification. A coding checklist cannot prove absence of flaws.

**Realistic example:** A parser replaces an unchecked copy with a bounds-safe interface and tests oversized inputs.

### Defense 47. Independent code review

Draft provenance ID: 61. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Examination of changes for security defects, unintended behavior and policy violations before acceptance.

**How it works:** Reviewers inspect sensitive paths, tests, dependencies and change intent using an accountable process.

**Applicable conditions:** Useful for dangerous triggers, insecure APIs and privileged code when reviewers understand the context.

**Important limitations:** Review can miss obfuscation, large changes or compromised build artifacts. Reviewing source alone does not prove the shipped binary matches.

**Realistic example:** A second maintainer rejects a destructive scheduled task hidden in a routine maintenance change.

### Defense 48. Resource access controls

Draft provenance ID: 62. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Policies that limit who or what may perform particular operations on resources.

**How it works:** Enforce authenticated identity, permissions and appropriate contextual rules at each relevant boundary.

**Applicable conditions:** Useful for limiting data access, destructive changes and unauthorized use of privileged functions.

**Important limitations:** An authorized account can still misuse permitted actions, and missing checks on a second path can bypass policy.

**Realistic example:** Only an approved service identity may modify a sensitive deployment configuration.

### Defense 49. User behavior analytics

Draft provenance ID: 64. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Analysis of identity activity to identify behavior inconsistent with established patterns or expectations.

**How it works:** Correlate logins, data access, privilege use and movement across systems for investigation.

**Applicable conditions:** Useful for detecting some insider abuse and compromised accounts with adequate contextual telemetry.

**Important limitations:** An anomaly is not proof of malicious intent; false negatives, privacy concerns and baseline drift require oversight.

**Realistic example:** An employee account's unusual bulk export triggers a review of business justification.

### Defense 50. Least privilege

Draft provenance ID: 65. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Granting only the permissions and duration needed for a specific task.

**How it works:** Remove excess standing rights and separate routine work from controlled elevation.

**Applicable conditions:** Useful for users, services, cloud functions and administrative paths to limit opportunity and impact.

**Important limitations:** It does not fix every software flaw or stop misuse of legitimately needed rights. Effective permissions must be tested.

**Realistic example:** A reporting service can read its own dataset but cannot administer the database server.

### Defense 51. Session-cookie security attributes

Draft provenance ID: 72. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Browser cookie controls that limit exposure of session identifiers.

**How it works:** Secure restricts transport, HttpOnly limits script access and appropriate SameSite settings constrain cross-site sending.

**Applicable conditions:** Useful alongside HTTPS, safe session generation, rotation, invalidation and XSS prevention.

**Important limitations:** These attributes have different purposes; none makes a stolen valid token universally unusable.

**Realistic example:** A login service issues its session cookie with appropriate transport and script-access restrictions.

### Defense 52. Session expiration and idle timeouts

Draft provenance ID: 73. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Ending session validity after a defined period of inactivity or total lifetime.

**How it works:** The server checks lifetime and invalidates the session rather than relying only on a browser display timer.

**Applicable conditions:** Useful for reducing the window of abandoned or stolen session use, with limits suitable for the application.

**Important limitations:** An attacker can act before expiration; idle sessions may be kept active. Timeouts do not remove endpoint malware.

**Realistic example:** A financial application requires reauthentication after an appropriate idle interval.

### Defense 53. Mutual peer authentication

Draft provenance ID: 48. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A protocol arrangement in which both communicating endpoints prove their identities.

**How it works:** Each party verifies a credential bound to the intended peer and session before trusting application data.

**Applicable conditions:** Useful for device-to-service control channels and inter-service communication.

**Important limitations:** Trust-anchor errors, stolen keys and missing identity checks can defeat it. Encryption alone is not mutual authentication.

**Realistic example:** A controller accepts commands only after validating the authorized device certificate and server identity.

### Defense 54. DNS Security Extensions (DNSSEC)

Draft provenance ID: 55. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A system of signatures and trust relationships that authenticates DNS data for signed zones.

**How it works:** A validating resolver verifies the chain of trust and signatures before accepting protected responses.

**Applicable conditions:** Useful against forged or modified DNS answers when signing and validation are correctly deployed.

**Important limitations:** It does not encrypt queries, secure unsigned data automatically or prove the destination website is benign.

**Realistic example:** A resolver refuses an altered response whose signature cannot be validated to the trusted DNS chain.

### Defense 55. Hardened and trusted DNS resolvers

Draft provenance ID: 56. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Resolvers configured to resist abuse, validate appropriate data and restrict administrative and recursive access.

**How it works:** Patch resolver software, limit recursion where appropriate and use validation and protected management.

**Applicable conditions:** Useful for reducing cache poisoning and resolver misuse within an assessed name-resolution design.

**Important limitations:** Selecting a familiar resolver is not proof of DNSSEC validation or protection from every registrar or authoritative-server compromise.

**Realistic example:** An organization operates patched validating resolvers with recursion limited to its intended clients.

### Defense 56. Dynamic ARP Inspection

Draft provenance ID: 53. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Switch validation of local ARP messages against trusted IP/MAC bindings.

**How it works:** Use verified bindings, commonly DHCP-snooping data and approved exceptions, to reject inconsistent advertisements.

**Applicable conditions:** Useful on supported managed local networks with carefully configured trust ports.

**Important limitations:** Bad bindings or trust settings can interrupt legitimate hosts. It does not authenticate arbitrary traffic beyond the local link.

**Realistic example:** A switch rejects an ARP claim that conflicts with the gateway's trusted binding.

### Defense 57. Static network address bindings

Draft provenance ID: 54. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Manually fixed address associations instead of learning them dynamically.

**How it works:** Pin selected IP-to-MAC mappings or related entries on appropriate devices.

**Applicable conditions:** Useful in small stable networks where changes can be managed and verified reliably.

**Important limitations:** Operational drift and spoofed or compromised legitimate devices remain risks. Large-scale manual maintenance is error prone.

**Realistic example:** A small control network uses managed static neighbor entries for critical peers.

### Defense 58. BCP 38 source-address filtering

Draft provenance ID: 51. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Network boundary filtering intended to reduce traffic with forged source IP addresses.

**How it works:** Reject outgoing or incoming packets whose claimed source is inconsistent with the legitimate connected network.

**Applicable conditions:** Useful at networks that originate spoofed reflection requests, with routing-aware deployment.

**Important limitations:** It does not stop every DDoS technique or filter forged packets originating outside the enforcing network.

**Realistic example:** A provider filters customer egress so a compromised host cannot claim arbitrary victim addresses.

### Defense 59. Network firewall rules

Draft provenance ID: 52. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Explicit policy deciding which network flows or packets may cross a boundary.

**How it works:** Apply permitted addresses, services, connection states or application-aware conditions according to the firewall capability.

**Applicable conditions:** Useful for restricting unnecessary exposure and dropping identifiable unwanted traffic.

**Important limitations:** Overly broad rules, encrypted traffic and allowed compromised services limit effectiveness. Local filtering cannot repair a saturated upstream link.

**Realistic example:** An edge policy blocks an unnecessary exposed UDP service used in reflection abuse.

### Defense 60. Identity and access management (IAM)

Draft provenance ID: 100. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Systems and policies managing identities, credentials and their authorized access to resources.

**How it works:** Issue, authenticate, authorize, review and revoke identities and permissions through defined lifecycle controls.

**Applicable conditions:** Useful for people, services and cloud functions when effective permissions are assessed rather than assumed.

**Important limitations:** An authenticated or validly assigned identity can still be overprivileged or compromised. Policy interactions can be complex.

**Realistic example:** A function receives a service identity allowed to read only its assigned storage location.

### Defense 61. Configured WPA3 wireless security

Draft provenance ID: 44. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Modern Wi-Fi authentication and encryption using the appropriate WPA3 personal or enterprise configuration.

**How it works:** SAE or enterprise authentication protects association under the selected deployment model, with required management protections.

**Applicable conditions:** Use compatible patched clients and access points and an assessed transition configuration.

**Important limitations:** WPA3 does not patch every implementation flaw, prevent jamming or certify endpoint integrity. Unsafe fallback can weaken a deployment.

**Realistic example:** An enterprise distributes verified authentication-server settings to managed wireless clients.

### Defense 62. Device firmware security updates

Draft provenance ID: 45. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Vendor-supported changes that repair known defects in embedded device software.

**How it works:** Verify update provenance, assess compatibility, deploy and confirm the required version and configuration.

**Applicable conditions:** Useful when an applicable fix exists for an access point, camera or other supported device.

**Important limitations:** Updates can disrupt service and do not guarantee removal of prior compromise. Unsupported devices may need replacement.

**Realistic example:** A tested access-point firmware update closes a documented implementation weakness.

### Defense 63. Constant-time cryptographic implementation

Draft provenance ID: 59. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Code designed to avoid leaking secrets through data-dependent execution behavior relevant to the platform.

**How it works:** Use reviewed primitives without secret-dependent branches or memory access in sensitive paths.

**Applicable conditions:** Useful against certain timing and cache side channels in comparisons and cryptographic operations.

**Important limitations:** Scheduling noise does not establish constant-time behavior; compiler, hardware, power and fault channels require separate analysis.

**Realistic example:** A token verifier uses a suitable constant-time comparison rather than exiting on the first differing byte.

### Defense 64. Hardware security module (HSM)

Draft provenance ID: 60. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A dedicated cryptographic device or service boundary that protects keys and performs permitted operations.

**How it works:** Keys can remain inside the module while access policy, auditing and protected cryptographic operations constrain use.

**Applicable conditions:** Useful when an assessed security boundary and key-custody requirement justify the module's assurance level.

**Important limitations:** A module may still be misconfigured or vulnerable; authorized misuse and side channels are not automatically eliminated.

**Realistic example:** A signing service requests a signature from an HSM without exporting the private key to application memory.

### Defense 65. Mutual-exclusion locking (mutex)

Draft provenance ID: 68. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A synchronization mechanism that lets only one participating execution path enter a protected critical section.

**How it works:** Acquire the shared lock before reading and updating the related state, then release it safely.

**Applicable conditions:** Useful when all paths obey the same lock discipline and the protected invariant is correctly identified.

**Important limitations:** Locks can deadlock or fail across non-participating processes; locking one variable may not protect a multi-resource invariant.

**Realistic example:** Threads serialize updates to a shared account balance through one agreed lock.

### Defense 66. Atomic operations and transactions

Draft provenance ID: 69. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Operations whose relevant effects are indivisible to competing participants under the stated consistency model.

**How it works:** Use suitable atomic instructions or transactions to protect an entire security-relevant state transition.

**Applicable conditions:** Useful for preventing check-and-update races when the operation spans the required invariant.

**Important limitations:** Atomicity of individual reads does not make a compound workflow safe. Distributed transactions and isolation levels need separate design.

**Realistic example:** A database transaction verifies and deducts an available balance as one protected operation.

### Defense 67. Credential breach monitoring

Draft provenance ID: 88. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Checking for evidence that organizational accounts or credentials have appeared in known exposures.

**How it works:** Correlate reliable breach intelligence with accounts and trigger verification, reset or investigation as appropriate.

**Applicable conditions:** Useful for finding reuse exposure and initiating response after a third-party breach.

**Important limitations:** Coverage is incomplete and reports can be delayed or wrong. Monitoring does not revoke a credential by itself.

**Realistic example:** A confirmed exposure leads the identity team to invalidate affected secrets and check suspicious sign-ins.

### Defense 68. Unique passwords per service

Draft provenance ID: 89. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Using a distinct password for each account so one service's exposure does not unlock another.

**How it works:** A password manager can generate and retain separate strong secrets rather than relying on human memorization of variations.

**Applicable conditions:** Useful for limiting cross-service credential stuffing after another service exposes reusable passwords.

**Important limitations:** It does not protect a credential stolen from the very service being attacked or a compromised password manager or endpoint.

**Realistic example:** A retail password leak cannot authenticate to the user's email account because its password is different.

### Defense 69. Correlated failed-login monitoring

Draft provenance ID: 84. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Collecting and analyzing failed authentication events across accounts, sources and time.

**How it works:** Detect patterns such as many accounts receiving a few common guesses, not only repeated failures on one account.

**Applicable conditions:** Useful for spotting spraying and other online authentication abuse with adequate retention and response.

**Important limitations:** It is detection, not automatic prevention. Attackers may distribute activity or blend with ordinary user failures.

**Realistic example:** A security alert links low-rate failures across hundreds of accounts to a coordinated spraying campaign.

### Defense 70. Multi-factor authentication (MFA)

Draft provenance ID: 85. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Authentication using independent factors rather than repeated versions of the same secret type.

**How it works:** Require an additional factor and protect enrollment, recovery and factor replacement; prefer phishing-resistant designs where appropriate.

**Applicable conditions:** Useful for reducing takeover using a stolen password alone.

**Important limitations:** Some methods can be phished or fatigued. MFA does not protect every existing session or cure a compromised endpoint.

**Realistic example:** A service requires a device-bound authenticator proof that a stolen password alone cannot provide.

### Defense 71. Disable obsolete protocols and features

Draft provenance ID: 92. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Removing deprecated negotiation options and legacy access paths that the system no longer needs.

**How it works:** Configure services to reject unsupported versions, weak algorithms or unsafe fallback, then test required clients.

**Applicable conditions:** Useful when older options enable downgrade or insecure authentication paths.

**Important limitations:** Compatibility dependencies need assessment; disabling an option does not fix every vulnerability in the remaining implementation.

**Realistic example:** A service stops accepting an obsolete transport version after all required clients are tested.

### Defense 72. HTTP Strict Transport Security (HSTS)

Draft provenance ID: 93. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A browser policy directing future access to an origin through HTTPS and disallowing certain insecure fallbacks.

**How it works:** The site sends a policy over a valid HTTPS connection; approved preload deployment can cover an initial visit.

**Applicable conditions:** Useful against some HTTP downgrade and cookie transport exposure in supporting browsers.

**Important limitations:** It does not authenticate a look-alike domain or repair every TLS version downgrade. Initial-visit and subdomain policy need planning.

**Realistic example:** A browser refuses to downgrade a known HSTS site to plain HTTP on a hostile network.

### Defense 73. Wireless intrusion detection and prevention

Draft provenance ID: 94. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Monitoring wireless infrastructure for unauthorized or suspicious activity and applying assessed response policies.

**How it works:** Compare observed radios and configurations with approved inventory and investigate anomalies.

**Applicable conditions:** Useful for discovering rogue or impersonating access points with adequate sensor coverage.

**Important limitations:** False positives and blind spots exist; automatic disruption may cause outages or legal issues. Detection is not proof of malicious intent.

**Realistic example:** Wireless sensors locate an unapproved access point connected to an office network.

### Defense 74. MAC-address filtering

Draft provenance ID: 95. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Allowing or denying local network participation based on observed link-layer addresses.

**How it works:** Compare a device's claimed MAC address with a configured list at a supported access point or switch.

**Applicable conditions:** Useful for limited administrative inventory controls when stronger authentication is also present.

**Important limitations:** MAC addresses are observable and spoofable. This does not authenticate an access point or reliably prevent a rogue AP.

**Realistic example:** A small isolated lab uses MAC lists as an inventory aid, not as its primary device identity control.

### Defense 75. On-screen virtual keyboards

Draft provenance ID: 71. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Input interfaces that let users select characters without typing them through a physical keyboard.

**How it works:** They may bypass a simple hardware or software logger that captures only physical key events.

**Applicable conditions:** Useful only against a clearly defined input interception path and with appropriate accessibility design.

**Important limitations:** Screen capture, mouse recording and browser hooks can still capture input. They are not a general defense against a compromised endpoint.

**Realistic example:** A special-purpose kiosk avoids a simple hardware keystroke recorder but still requires tamper inspection.

### Defense 76. Anti-malware protection

Draft provenance ID: 70. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Tools that detect, block or remediate malicious software using signatures and other techniques.

**How it works:** Inspect files, processes and behavior, then quarantine or trigger investigation under managed policy.

**Applicable conditions:** Useful where the tool has sufficient visibility and current detection capability.

**Important limitations:** Unknown, privileged or evasive malware can be missed. A clean scan does not prove that all compromise effects are removed.

**Realistic example:** An endpoint blocks a recognized credential-stealing program and alerts the response team.

### Defense 77. Request rate limiting

Draft provenance ID: 46. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Restricting request frequency or resource use over a defined interval.

**How it works:** Enforce appropriate quotas before expensive work, using identities or other assessed grouping keys.

**Applicable conditions:** Useful for login guessing and application-resource exhaustion when enforcement occurs at the relevant boundary.

**Important limitations:** Distributed sources, shared addresses and expensive permitted requests complicate limits. Local limits cannot create upstream bandwidth.

**Realistic example:** An API rejects excessive per-token requests before allocating costly backend jobs.

### Defense 78. Load balancing and capacity distribution

Draft provenance ID: 47. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Spreading service traffic across multiple healthy instances or locations.

**How it works:** Routing and health checks distribute work and support failover across available capacity.

**Applicable conditions:** Useful for legitimate demand, instance failures and some resource-exhaustion events.

**Important limitations:** An attacker can overwhelm shared dependencies or total capacity. A load balancer does not itself distinguish malicious requests.

**Realistic example:** A service shifts traffic away from a failing instance while maintaining capacity in another zone.

### Defense 79. Account lockouts and progressive login restrictions

Draft provenance ID: 80. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Controls limiting repeated authentication failures against an account.

**How it works:** Temporarily restrict attempts or apply increasing delays with appropriate recovery and monitoring.

**Applicable conditions:** Useful against online password guessing where the service controls the authentication path.

**Important limitations:** Attackers can abuse lockouts for denial of service, and low-rate spraying may evade per-account thresholds. Offline guesses are unaffected.

**Realistic example:** A portal slows repeated failed attempts and provides a protected recovery route for legitimate users.

### Defense 80. CAPTCHA and automation challenges

Draft provenance ID: 81. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Tests intended to make automated interaction more costly or difficult.

**How it works:** Present an assessed challenge when risk warrants it, using accessible alternatives and server-side verification.

**Applicable conditions:** Useful as supplementary friction in some automated-abuse workflows.

**Important limitations:** Challenges can be solved, relayed or bypassed and can exclude users. They are not a sole authentication or brute-force defense.

**Realistic example:** A signup service challenges suspicious automation while also enforcing quotas and abuse monitoring.

### Defense 81. Authenticated sequence numbers

Draft provenance ID: 101. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Ordered message identifiers used with verification state to reject duplicates or out-of-window messages.

**How it works:** Authenticate the sequence field and maintain an appropriate acceptance window for the session.

**Applicable conditions:** Useful for replay protection in command and transport protocols.

**Important limitations:** Unauthenticated numbering can be altered; resets, wraparound and state loss can reopen replay paths.

**Realistic example:** A controller discards an authenticated command number it has already processed.

### Defense 82. One-time authentication passwords or codes

Draft provenance ID: 102. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Values intended to be accepted only once for a defined authentication purpose.

**How it works:** Bind a generated code to the intended operation and invalidate it after use with server-side state or protocol checks.

**Applicable conditions:** Useful for specific authentication or recovery flows with protected delivery and verification.

**Important limitations:** Codes can be stolen or relayed before use; time-limited is not automatically single-use. They do not protect arbitrary messages without binding.

**Realistic example:** A recovery code becomes invalid immediately after a verified password-recovery transaction.

### Defense 83. Authenticated timestamps and freshness windows

Draft provenance ID: 63. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Time values used with trusted clocks and protocol checks to constrain message age.

**How it works:** Authenticate the timestamp and reject messages outside a defined window, usually with additional replay tracking.

**Applicable conditions:** Useful when devices can maintain appropriate time and tolerate a designed acceptance window.

**Important limitations:** A timestamp alone permits repeated messages within the window. Clock drift and rollback handling require design.

**Realistic example:** A device rejects a signed command that is too old and tracks accepted message identifiers within the allowed interval.

### Defense 84. Request-bound anti-CSRF tokens

Draft provenance ID: 78. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Unpredictable values used to distinguish legitimate state-changing browser requests from cross-site forgeries.

**How it works:** Generate and validate tokens bound to the appropriate session or request context on the server.

**Applicable conditions:** Useful for applications that otherwise rely on automatically sent credentials such as cookies.

**Important limitations:** XSS, token leakage and missing validation undermine the design. A generic bearer token is not automatically an anti-CSRF token.

**Realistic example:** A profile-change form is rejected when its request lacks the expected session-bound anti-CSRF value.

### Defense 85. SameSite cookie policy

Draft provenance ID: 79. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Browser rules controlling cookie transmission in cross-site request contexts.

**How it works:** Choose an appropriate Strict, Lax or other supported policy and verify behavior for the application's flows.

**Applicable conditions:** Useful as one layer against some CSRF and cross-site cookie exposure.

**Important limitations:** It is not a complete CSRF defense, especially for same-site attacks or unsafe endpoint design. Compatibility and necessary cross-site workflows matter.

**Realistic example:** A site tests that a cross-site navigation cannot silently perform a sensitive state-changing operation.

### Defense 86. Cryptographically authenticated RFID

Draft provenance ID: 98. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** RFID credentials using protected cryptographic operations rather than relying only on a readable static identifier.

**How it works:** Challenge-response can prove possession of a tag secret while freshness checks reject simple recording and replay.

**Applicable conditions:** Useful when readers, credentials and key management support an assessed authentication design.

**Important limitations:** Encrypted stored data alone may still be clonable; relay attacks and compromised readers require additional consideration.

**Realistic example:** A replacement badge system rejects a copied serial number because the counterfeit cannot answer its fresh challenge.

### Defense 87. Radio shielding

Draft provenance ID: 99. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Materials or enclosures that reduce radio transmission through a physical boundary.

**How it works:** Attenuate the relevant frequencies with appropriate coverage, installation and tested effectiveness.

**Applicable conditions:** Useful for limiting unintended RFID reads or reducing particular electromagnetic exposure.

**Important limitations:** Gaps, unsupported frequencies and handling outside the enclosure remain risks. Shielding does not make a cloned identifier unforgeable.

**Realistic example:** Sensitive contactless credentials are kept in a tested shielded holder when not in use.

### Defense 88. Strong password selection

Draft provenance ID: 82. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Choosing long, unique passwords and rejecting commonly used or compromised candidates.

**How it works:** Use adequate length, blocklists and password managers rather than relying on predictable character substitutions.

**Applicable conditions:** Useful against likely-password guessing for secrets that must still be user-entered.

**Important limitations:** Forced composition recipes can encourage predictable patterns. Better selection does not prevent phishing or theft from an endpoint.

**Realistic example:** A user creates a unique generated password instead of a sports team name with a year suffix.

### Defense 89. Per-password salting

Draft provenance ID: 83. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Adding a unique salt as input to the password-hashing process.

**How it works:** Store the salt with the verifier so identical passwords do not share a reusable precomputed hash computation.

**Applicable conditions:** Useful with a suitable cost-tuned password KDF for stored verification records.

**Important limitations:** Salts are not secrets and do not block online guesses or make an individual weak password unguessable.

**Realistic example:** Two accounts using the same password have distinct stored verification values because their salts differ.

### Defense 90. Uniquely salted password verifiers

Draft provenance ID: 86. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Stored password hashes computed using a different salt for each password record.

**How it works:** Per-record salts defeat shared lookup tables and reveal less about identical user passwords.

**Applicable conditions:** Use with an appropriate slow or memory-hard KDF and protected migration procedures.

**Important limitations:** A salted fast hash can still be guessed rapidly. Salting is not encryption and does not stop online credential stuffing.

**Realistic example:** A legacy application migrates unsalted hashes to a versioned salted password-verifier format.

### Defense 91. Password KDF work factors (key stretching)

Draft provenance ID: 87. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Deliberately expensive derivation that increases the cost of testing each password guess.

**How it works:** Apply a suitable KDF with measured CPU and, where appropriate, memory cost and unique salts.

**Applicable conditions:** Useful against offline guessing when parameters balance security and authentication capacity.

**Important limitations:** It does not add entropy to a weak password or prevent online attacks by itself. Excessive cost can create service-exhaustion risks.

**Realistic example:** A password service periodically reassesses its KDF cost as hardware and operational capacity change.

### Defense 92. Secure initial and compromised-credential changes

Draft provenance ID: 90. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Requiring changes when defaults, exposure or recovery make an existing secret unsafe.

**How it works:** Provision unique initial credentials, disable shared defaults and replace known compromised credentials through verified workflows.

**Applicable conditions:** Useful before device deployment and after evidence of exposure.

**Important limitations:** Arbitrary periodic changes without evidence are not a universal best practice and can encourage weak patterns. Rotation alone does not repair an active compromise.

**Realistic example:** A device cannot enter production until its published factory administrator credential is removed.

### Defense 93. System hardening

Draft provenance ID: 91. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reducing unnecessary services, unsafe defaults and excess administrative exposure.

**How it works:** Apply a reviewed baseline, remove unused functions and verify effective configuration after deployment.

**Applicable conditions:** Useful for reducing default-password exposure and avoidable attack surface.

**Important limitations:** A hardened baseline can drift and does not patch every unknown vulnerability. Hardening must respect operational needs.

**Realistic example:** An appliance's remote administration is restricted and unused accounts and services are disabled.

### Defense 94. SHA-3 hashing

Draft provenance ID: 49. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A standardized family of cryptographic hash and extendable-output functions.

**How it works:** A selected variant produces a digest for a specified security purpose without a shared secret.

**Applicable conditions:** Useful for appropriate integrity or cryptographic constructions when the variant and output size meet the requirement.

**Important limitations:** An unkeyed digest does not authenticate its sender. SHA-3 alone is not a password-storage scheme or a fix for every collision-sensitive design.

**Realistic example:** A protocol uses a reviewed SHA-3 variant as one component of its specified construction.

### Defense 95. Adequate cryptographic output length

Draft provenance ID: 50. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Choosing an output size that supplies the required work factor for the particular primitive and threat.

**How it works:** For ideal n-bit hashes, generic collision search is about 2^(n/2), distinct from an n-bit preimage target.

**Applicable conditions:** Useful when designing identifiers or hashes that actually require collision resistance.

**Important limitations:** Length does not rescue a broken algorithm, poor randomness or an unsuitable protocol. Password strength is a separate property.

**Realistic example:** A toy short digest is replaced with an appropriately sized modern hash for document integrity checks.

### Defense 96. Independent request verification

Draft provenance ID: 41. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Checking a claimed fact or requested action against separately trusted evidence.

**How it works:** Confirm identity, intent and relevant details through known channels or approved records.

**Applicable conditions:** Useful for financial changes, support requests and software release decisions when the procedure is specific.

**Important limitations:** A vague instruction to verify is not a technical control until the evidence and procedure are defined.

**Realistic example:** Accounts payable confirms a bank-detail change using the supplier's established phone number.

### Defense 97. Social-engineering response training

Draft provenance ID: 42. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Practice in recognizing manipulation and using safe challenge and escalation procedures.

**How it works:** Teach staff to pause, verify and report requests despite urgency, rewards or apparent authority.

**Applicable conditions:** Useful for pretexting and quid-pro-quo approaches with practical support from management.

**Important limitations:** Training does not authenticate a requester or block malware. Staff need a process they can actually follow under pressure.

**Realistic example:** A help-desk exercise rehearses refusing password requests while offering a legitimate recovery route.

### Defense 98. Visitor escort procedures

Draft provenance ID: 43. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Rules requiring an authorized sponsor to accompany and account for visitors in controlled areas.

**How it works:** Define access scope, check-in, supervision and safe escalation when a visitor separates from the escort.

**Applicable conditions:** Useful for visitors whose limited authorization does not permit independent movement.

**Important limitations:** A written rule without staffing and compliance does not enforce access. Emergency safety and accessibility remain essential.

**Realistic example:** A contractor is escorted between the reception desk and an approved equipment room.

### Defense 99. High-security mechanical locks

Draft provenance ID: 96. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Locks designed and assessed for specified resistance to manipulation and unauthorized opening.

**How it works:** Use an appropriate cylinder, protected installation and controlled key management as part of the door assembly.

**Applicable conditions:** Useful where mechanical access resistance is required and the selected assurance level matches the risk.

**Important limitations:** No lock is invulnerable; weak frames, copied keys and alternate entrances may bypass the cylinder.

**Realistic example:** A restricted store installs a rated cylinder and tracks authorized key issuance.

### Defense 100. Electronic physical access security

Draft provenance ID: 97. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Electronic systems controlling or recording physical entry and related security events.

**How it works:** Readers, door controllers, sensors and audit records enforce a defined access policy and support response.

**Applicable conditions:** Useful with reliable power, safe egress, protected credentials and maintained equipment.

**Important limitations:** A door reader does not necessarily strengthen a mechanical lock or prevent tailgating. Controllers themselves require security.

**Realistic example:** An entry controller logs a door opening and checks the presented credential against current access rights.

### Defense 101. Security-claim source verification

Draft provenance ID: 74. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Checking a warning, instruction or incident claim against independently trusted evidence.

**How it works:** Consult genuine vendor advisories, internal security staff and original evidence rather than forwarding rumors.

**Applicable conditions:** Useful for hoaxes and misleading security instructions before taking disruptive action.

**Important limitations:** A trusted source can be mistaken or outdated; verify applicability and context rather than treating reputation as proof.

**Realistic example:** Staff verify an alarming deletion instruction with the security team before touching system files.

### Defense 102. Incident response plans

Draft provenance ID: 75. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Prepared responsibilities and procedures for identifying, containing, investigating and recovering from incidents.

**How it works:** Define escalation routes, evidence handling, communications and tested recovery decisions.

**Applicable conditions:** Useful when personnel exercise the plan and have authority and resources to act.

**Important limitations:** A document alone neither detects nor blocks an incident. Rigid procedures can fail when the real situation differs.

**Realistic example:** An exercised response plan coordinates containment and communications during a suspected ransomware incident.

### Defense 103. Security gateways

Draft provenance ID: 139. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Boundary services that mediate and inspect a defined class of traffic.

**How it works:** An email or web gateway can enforce content rules, scan objects and route suspicious activity for review.

**Applicable conditions:** Useful when the gateway's specific capability matches a documented delivery path.

**Important limitations:** The broad label does not imply all-purpose protection. Encrypted visibility, direct paths and unknown threats limit coverage.

**Realistic example:** A mail gateway quarantines a known malicious attachment associated with a ransomware campaign.

### Defense 104. Vulnerability patch management

Draft provenance ID: 140. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** The process of applying and verifying fixes for known software defects.

**How it works:** Prioritize exposure, test operational effects, deploy trusted fixes and confirm vulnerable versions are removed.

**Applicable conditions:** Useful when a relevant vendor or maintainer fix exists.

**Important limitations:** Patching does not retroactively undo theft or persistence and cannot fix a flaw for which no remedy exists.

**Realistic example:** An exposed service receives a verified security patch after its risk and dependencies are assessed.

### Defense 105. Supplier and system security assessments

Draft provenance ID: 178. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Structured evaluation of a supplier, service or system's relevant risks and practices.

**How it works:** Review evidence, dependencies, development practices and response capability, then track specific findings.

**Applicable conditions:** Useful for selecting and monitoring supply-chain relationships according to their actual exposure.

**Important limitations:** A favorable assessment is not a guarantee of future security and may miss hidden compromise. Findings need enforceable follow-up.

**Realistic example:** A software buyer examines build provenance and incident notification commitments before adopting a dependency.

### Defense 106. Verified digital signatures

Draft provenance ID: 179. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Cryptographic checks tying signed content to a key identity and detecting later modification.

**How it works:** Verify the signature with an independently trusted key and check release context and publisher identity.

**Applicable conditions:** Useful for software packages and update authenticity when the signing process is protected.

**Important limitations:** A valid signature does not prove benign behavior; compromised publishers or signing keys can sign malicious code.

**Realistic example:** An updater rejects a package altered by a mirror because its signature no longer matches the trusted release.

### Defense 107. Heuristic threat detection

Draft provenance ID: 181. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Rules or models that infer suspicious behavior from patterns rather than only exact known signatures.

**How it works:** Evaluate activity such as abnormal process chains or exploit-like behavior and escalate assessed matches.

**Applicable conditions:** Useful for finding some new variants or unknown exploits when relevant observations are available.

**Important limitations:** False positives, evasion and blind spots remain. It does not guarantee detection of a zero-day exploit.

**Realistic example:** An endpoint flags unusual child-process behavior even though the payload has no known hash signature.

### Defense 108. Threat intelligence

Draft provenance ID: 182. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Assessed information about adversaries, techniques, vulnerabilities or indicators that informs security decisions.

**How it works:** Collect context, evaluate reliability and relevance, then connect intelligence to monitoring and response.

**Applicable conditions:** Useful for prioritization, hunting and detection updates when information is timely and applicable.

**Important limitations:** An indicator can be stale, shared or misleading; intelligence is not automatic blocking and cannot describe every unknown exploit.

**Realistic example:** A confirmed campaign report helps a team investigate a specific suspicious endpoint pattern.

### Defense 109. Air-gap and strong network isolation

Draft provenance ID: 176. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An architecture separating a system from direct network connections to other environments.

**How it works:** Remove intended electronic network paths and control media transfer, maintenance and human access routes.

**Applicable conditions:** Useful where operational and safety needs permit a carefully maintained isolation boundary.

**Important limitations:** Removable media, laptops, supply-chain compromise and unofficial bridges can cross the gap. Claimed isolation must be verified.

**Realistic example:** A sensitive control system exchanges approved files only through a controlled transfer procedure.

### Defense 110. Industrial and SCADA network firewalls

Draft provenance ID: 177. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Network boundary enforcement designed for assessed industrial control environments.

**How it works:** Restrict allowed communication and, where supported, inspect relevant industrial protocol operations.

**Applicable conditions:** Useful between engineering, supervisory and process zones when rules are developed with operations and safety staff.

**Important limitations:** An unsafe rule can disrupt physical processes. Firewalls do not replace controller hardening, recovery or independent safety systems.

**Realistic example:** A plant boundary allows only approved engineering paths and rejects unnecessary controller access.

### Defense 111. Network segmentation

Draft provenance ID: 135. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Dividing a network into security zones with controlled communication between them.

**How it works:** Define allowed paths and enforce them through suitable routing, firewall or equivalent policy.

**Applicable conditions:** Useful for limiting lateral movement and reducing blast radius across workloads or device fleets.

**Important limitations:** An unconstrained VLAN is not sufficient isolation. Permitted vulnerable services and shared management paths can bridge zones.

**Realistic example:** An IoT camera zone cannot initiate connections to employee workstations.

### Defense 112. Network firewalls

Draft provenance ID: 134. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Enforcement devices or host controls that permit or block traffic according to configured policy.

**How it works:** Restrict unnecessary services and crossings between network security boundaries.

**Applicable conditions:** Useful for reducing reachable paths and limiting propagation through unwanted services.

**Important limitations:** Allowed flows may carry attacks; policy errors and encrypted visibility limits remain. A firewall does not patch a vulnerable host.

**Realistic example:** A host firewall blocks an unused service that a worm otherwise could reach.

### Defense 113. Intrusion prevention systems (IPS)

Draft provenance ID: 136. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Controls that inspect activity and can block traffic matching supported attack conditions.

**How it works:** Apply signatures or behavioral rules inline at an assessed enforcement point.

**Applicable conditions:** Useful against known exploit patterns with appropriate tuning and sufficient visibility.

**Important limitations:** False positives can interrupt service, and evasion or encrypted traffic can hide attacks. It does not replace patching.

**Realistic example:** An IPS rejects a recognized exploit request targeting an unpatched service while remediation is arranged.

### Defense 114. Security-Enhanced Linux (SELinux)

Draft provenance ID: 174. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A Linux mandatory access-control system enforcing policy beyond ordinary discretionary permissions.

**How it works:** Labels and policy rules constrain which resources and operations a process may use.

**Applicable conditions:** Useful for limiting container and host process access when enforcing mode and appropriate policy are maintained.

**Important limitations:** Permissive mode, overly broad policy and kernel vulnerabilities can undermine confinement. It does not make privileged containers universally safe.

**Realistic example:** A container process is denied access to host files outside its approved SELinux policy.

### Defense 115. Kernel resource namespaces

Draft provenance ID: 175. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Operating-system mechanisms providing separated views of processes, mounts, networks or other resources.

**How it works:** Assign workloads to appropriately configured namespaces to reduce unintentional sharing and visibility.

**Applicable conditions:** Useful as one component of container isolation on a supported patched host.

**Important limitations:** Namespaces do not alone provide a complete security boundary; capabilities, mounts, host sockets and kernel vulnerabilities matter.

**Realistic example:** A container has its own process and mount views while separate policy restricts privileged operations.

### Defense 116. Domain-based Message Authentication, Reporting and Conformance (DMARC)

Draft provenance ID: 114. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Email-domain policy and reporting based on aligned SPF or DKIM results.

**How it works:** A domain publishes policy and receivers assess alignment with the visible From domain under DMARC rules.

**Applicable conditions:** Useful against some unauthorized use of a protected domain in email, with carefully deployed enforcement.

**Important limitations:** It does not certify message content, stop look-alike domains or prevent abuse of a compromised legitimate account.

**Realistic example:** A company progresses to an enforced DMARC policy after reviewing legitimate mail flows and reports.

### Defense 117. Financial authorization and fraud controls

Draft provenance ID: 115. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Procedures that constrain how payments and account-detail changes are approved.

**How it works:** Use independent verification, separation of duties, transaction limits and reconciled records.

**Applicable conditions:** Useful when deceptive communications attempt to turn a valid business workflow into fraud.

**Important limitations:** Collusion, weak exception paths and compromised approvers can undermine the process. Approval does not replace account security.

**Realistic example:** A changed payee requires confirmation through a known supplier contact and a second authorized approver.

### Defense 118. Executive-focused security training

Draft provenance ID: 108. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Training adapted to high-value roles, authority pressure and sensitive business decisions.

**How it works:** Practice delegation, payment verification and secure handling of board or acquisition material with relevant staff.

**Applicable conditions:** Useful for executives and assistants targeted by tailored deception.

**Important limitations:** Role-specific training does not override the need for technical controls or independent transaction checks.

**Realistic example:** An executive assistant practices challenging an urgent request that claims normal approvals must be skipped.

### Defense 119. Out-of-band verification procedures

Draft provenance ID: 109. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Documented steps for confirming a sensitive request through evidence independent of its delivery channel.

**How it works:** Use established contact information, dual approval or separately authenticated records before accepting changed instructions.

**Applicable conditions:** Useful for transfers, credential recovery and privileged access changes.

**Important limitations:** A second channel controlled by the same attacker is not independent. Procedures need exceptions that cannot silently bypass verification.

**Realistic example:** Finance confirms altered supplier bank details using the supplier's pre-existing verified contact record.

### Defense 120. Restricted access to sensitive information

Draft provenance ID: 110. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Limiting access to valuable data according to verified business needs.

**How it works:** Apply resource-specific permissions, review grants and log sensitive retrieval or export.

**Applicable conditions:** Useful for reducing the reach of a compromised or deceived executive or other user.

**Important limitations:** It does not establish whether a communication is genuine or stop misuse of legitimately accessible data.

**Realistic example:** A transaction team limits acquisition documents to approved participants instead of a broad executive group.

### Defense 121. Service and port exposure control

Draft provenance ID: 141. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Restricting which services accept or initiate network connections through firewall policy.

**How it works:** Close unused listening services and apply assessed ingress and egress rules.

**Applicable conditions:** Useful for reducing unnecessary access paths to remote-control services.

**Important limitations:** A Trojan may use an allowed outbound connection or trusted service; port blocking alone is not malware cleanup.

**Realistic example:** A workstation policy denies unneeded inbound remote-control ports and monitors unexpected outbound sessions.

### Defense 122. Anomaly detection

Draft provenance ID: 142. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Identifying observations that differ from a defined expected pattern.

**How it works:** Compare activity with an assessed baseline or model and send meaningful deviations for investigation.

**Applicable conditions:** Useful for unusual destinations, process chains or identity activity when context is available.

**Important limitations:** An unusual event is not necessarily malicious, and attackers can imitate normal behavior. Baselines require maintenance.

**Realistic example:** A workstation contacting a new external control endpoint at unusual hours triggers review.

### Defense 123. Endpoint or workload isolation

Draft provenance ID: 143. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Separating a suspected compromised system from sensitive resources while preserving appropriate response access.

**How it works:** Restrict network paths, invalidate sessions where needed and use trusted systems for recovery decisions.

**Applicable conditions:** Useful for containing malware and avoiding sensitive work in a compromised browser or endpoint.

**Important limitations:** Isolation is not eradication; it can disrupt business and must preserve safety and evidence needs.

**Realistic example:** A suspected infected laptop is isolated from production access while responders collect evidence.

### Defense 124. Authorized sinkholing

Draft provenance ID: 144. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Redirecting selected malicious infrastructure traffic to a controlled defensive destination.

**How it works:** Use appropriate legal and technical authority to alter resolution or routing for a known command endpoint.

**Applicable conditions:** Useful for disrupting some botnet control channels and identifying affected clients.

**Important limitations:** Alternative command paths and embedded addresses can bypass it. Sinkholing does not remove malware and must not capture unrelated traffic.

**Realistic example:** A coordinated defender operation redirects a botnet domain to a monitored defensive server.

### Defense 125. Restrict or disable NTLM

Draft provenance ID: 158. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Reducing or eliminating an assessed Windows NTLM authentication path.

**How it works:** Inventory dependencies, audit usage and enforce appropriate restrictions while migrating required services.

**Applicable conditions:** Useful against NTLM-specific credential reuse when supported alternatives and compatibility have been verified.

**Important limitations:** It can break legacy services and does not stop Kerberos ticket/key abuse or all credential theft. Some paths may remain unless explicitly covered.

**Realistic example:** An organization retires NTLM for a tested service and verifies that fallback is no longer accepted.

### Defense 126. Kerberos authentication

Draft provenance ID: 159. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A ticket-based network authentication protocol using a trusted key distribution service.

**How it works:** Clients obtain and present service tickets according to domain identity and trust policy.

**Applicable conditions:** Useful in appropriately managed environments as part of reducing legacy authentication exposure.

**Important limitations:** Kerberos is not a universal pass-the-hash remedy; stolen keys or tickets, weak delegation and NTLM fallback remain risks.

**Realistic example:** A service accepts properly validated Kerberos tickets after its authentication dependencies are reviewed.

### Defense 127. Role-based access control (RBAC)

Draft provenance ID: 120. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Authorization in which permissions are assigned to roles and identities receive approved role memberships.

**How it works:** Enforce the role's permitted operations at resource boundaries and review membership lifecycle.

**Applicable conditions:** Useful for managing consistent job-based access in applications and cluster APIs.

**Important limitations:** Overbroad roles, inherited rights and compromised members can still cause harm. RBAC does not enforce every workload security setting.

**Realistic example:** A cluster user can inspect workloads but cannot create privileged administrative resources.

### Defense 128. Kubernetes workload admission security policy

Draft provenance ID: 180. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Rules that assess workload security settings before resources are accepted into a cluster.

**How it works:** Use supported controls such as Pod Security Admission and appropriate admission policy to restrict privileged workloads and unsafe host access.

**Applicable conditions:** Useful for new or changed workloads together with API authorization and runtime protection.

**Important limitations:** The removed PodSecurityPolicy API should not be deployed as a current feature. Admission policy does not fix every running workload or kernel flaw.

**Realistic example:** A cluster rejects a manifest requesting prohibited host privileges under its enforced workload standard.

### Defense 129. Supported software and device updates

Draft provenance ID: 132. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Maintaining components through verified supported releases that correct known defects.

**How it works:** Inventory versions, assess applicability, test where needed and verify deployment of the required update.

**Applicable conditions:** Useful when a known security flaw has a supported fix.

**Important limitations:** An update is not proof that a previously compromised device is clean; unsupported products may require replacement.

**Realistic example:** A camera fleet receives a tested vendor release addressing a remotely exploitable service flaw.

### Defense 130. Message-sender verification

Draft provenance ID: 105. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Checking a sender's identity and request using appropriate technical evidence and trusted channels.

**How it works:** Inspect authenticated domain signals and confirm sensitive requests independently when risk warrants it.

**Applicable conditions:** Useful for targeted messages that exploit familiarity or current business details.

**Important limitations:** A compromised legitimate mailbox can pass domain checks. Authentic sender identity does not prove benign intent.

**Realistic example:** An engineer confirms a sensitive document request with the known project lead through an established channel.

### Defense 131. Managed threat-protection controls

Draft provenance ID: 106. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A broad category of controls that identify or block malicious content and activity.

**How it works:** Specify the actual product capability, telemetry, prevention policy and response process rather than relying on the label.

**Applicable conditions:** Useful when a concrete threat path and supported detection or blocking function are identified.

**Important limitations:** The term is not a standardized guarantee. Unknown attacks, missing visibility and configuration gaps can defeat coverage.

**Realistic example:** A mail-and-endpoint deployment links a malicious attachment alert to containment of the affected workstation.

### Defense 132. Security simulation exercises

Draft provenance ID: 107. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Controlled practice of security decisions and response procedures.

**How it works:** Use authorized scenarios with defined learning goals, safe execution and constructive feedback.

**Applicable conditions:** Useful for rehearsing phishing reporting, verification and incident escalation before a real event.

**Important limitations:** A simulation does not authenticate a real request or prove future immunity. Exercises must not harm operations or shame individuals.

**Realistic example:** A team rehearses independent verification of a tailored supplier-payment request.

### Defense 133. Web destination and content filtering

Draft provenance ID: 121. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Rules controlling access to web destinations or selected web content.

**How it works:** Block known harmful sites or categories through an assessed proxy, resolver or endpoint enforcement point.

**Applicable conditions:** Useful for restricting access to a known compromised site while incident response proceeds.

**Important limitations:** New destinations, encrypted visibility limits and policy bypasses can reduce coverage. A permitted site can still be malicious.

**Realistic example:** A known watering-hole site is temporarily blocked for managed browsers during investigation.

### Defense 134. Endpoint detection and response (EDR)

Draft provenance ID: 122. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Collection and analysis of endpoint activity with investigation and response capabilities.

**How it works:** Correlate process, file, identity and network behavior and support actions such as containment.

**Applicable conditions:** Useful for investigating activity that signatures alone may miss when telemetry and staff coverage are sufficient.

**Important limitations:** Blind spots, tampering and alert overload remain possible. An installed agent is not evidence that every attack is prevented.

**Realistic example:** A browser exploit leads to unusual process behavior, prompting endpoint isolation and forensic review.

### Defense 135. Security scanning

Draft provenance ID: 123. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Inspection of files, systems or configurations for specified threats or weaknesses.

**How it works:** Use an appropriate vulnerability, malware or configuration scanner and verify findings in context.

**Applicable conditions:** Useful for identifying known problems before deployment or during investigation.

**Important limitations:** Scanning scope and signatures limit coverage; unknown behavior and unsafe device classes may be missed. A clean result is not proof of safety.

**Realistic example:** A removable file is scanned in a controlled environment before an approved transfer.

### Defense 136. Application allowlisting

Draft provenance ID: 137. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Execution policy permitting only approved applications or code identities.

**How it works:** Rules based on assessed publishers, hashes or other supported attributes limit what can run.

**Applicable conditions:** Useful on managed systems with controlled software needs and a maintained approval process.

**Important limitations:** Approved interpreters and signed vulnerable tools can be abused. Overbroad publisher rules or weak administration reduce protection.

**Realistic example:** A managed workstation refuses an unapproved fake support utility despite a user's attempt to run it.

### Defense 137. Behavior-based threat detection

Draft provenance ID: 138. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Detection based on suspicious actions and relationships rather than only known file identifiers.

**How it works:** Observe relevant behavior such as unusual persistence, injection or credential access and investigate correlations.

**Applicable conditions:** Useful for malware variants and abuse of legitimate tools where sufficient telemetry exists.

**Important limitations:** Heuristics can be bypassed or mistaken, and detections need operational response.

**Realistic example:** A signed tool's unusual chain of actions triggers investigation despite its apparently legitimate file signature.

### Defense 138. Antivirus protection

Draft provenance ID: 131. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Detection and remediation of recognized malicious files and related execution behavior.

**How it works:** Use updated signatures and other supported detection techniques with quarantine and investigation.

**Applicable conditions:** Useful as an endpoint layer against file-infecting malware and other supported threats.

**Important limitations:** Novel or concealed malware may evade detection, and removal may not restore trust after privileged compromise.

**Realistic example:** A file-infecting malware signature triggers quarantine and checks of other executable files.

### Defense 139. Safer web use

Draft provenance ID: 133. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Practices and browser protections that reduce exposure to deceptive or malicious web content.

**How it works:** Use trusted navigation, supported browsers and cautious handling of downloads and unexpected prompts.

**Applicable conditions:** Useful for everyday risk reduction in combination with endpoint and identity controls.

**Important limitations:** A familiar site can be compromised and careful users can still encounter browser exploits.

**Realistic example:** A user retrieves an application from a verified publisher route rather than an advertisement impersonating it.

### Defense 140. Upstream DDoS scrubbing

Draft provenance ID: 145. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Filtering attack traffic in sufficiently provisioned infrastructure before forwarding acceptable traffic to the protected service.

**How it works:** Route traffic through a mitigation service that distinguishes assessed attack patterns from legitimate demand.

**Applicable conditions:** Useful when local link capacity would otherwise be exhausted before on-premises controls can act.

**Important limitations:** Application-layer floods, routing setup and false positives require planning; no service has unlimited capacity.

**Realistic example:** A provider diverts a volumetric flood away from the customer's constrained access circuit.

### Defense 141. Network traffic analysis

Draft provenance ID: 146. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Examining flow, packet and application observations to understand behavior and anomalies.

**How it works:** Measure rates, sources, destinations and protocol behavior and correlate them with service symptoms.

**Applicable conditions:** Useful for diagnosing DoS/DDoS and informing appropriate filtering or escalation.

**Important limitations:** Analysis alone does not absorb or block a flood. Collection visibility and privacy constraints limit conclusions.

**Realistic example:** Operations staff distinguish a traffic surge from a distributed attack before activating mitigation.

### Defense 142. Internet service provider coordination

Draft provenance ID: 147. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Working with a connectivity provider on upstream visibility and mitigation.

**How it works:** Use established incident contacts to arrange routing, filtering or scrubbing before a constrained customer link.

**Applicable conditions:** Useful for attacks whose volume or source cannot be handled at the local edge.

**Important limitations:** Response capability, lead time and collateral effects vary by agreement and provider. It is not automatic attack prevention.

**Realistic example:** An organization activates its provider's agreed DDoS escalation procedure during a sustained flood.

### Defense 143. Transport Layer Security (TLS)

Draft provenance ID: 148. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A protocol protecting a network session's confidentiality and integrity with peer authentication as configured.

**How it works:** Negotiate supported cryptography and verify the intended certificate identity and trust chain.

**Applicable conditions:** Useful against interception on a protected path when endpoints and trust configuration are reliable.

**Important limitations:** It does not protect data after a malicious browser decrypts it or prove that a look-alike site's operator is benign.

**Realistic example:** A client rejects an intermediary's certificate because it is not valid for the intended server identity.

### Defense 144. Certificate or public-key pinning

Draft provenance ID: 149. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Restricting a client to an expected certificate or public-key identity beyond ordinary trust-store acceptance.

**How it works:** A managed application checks an approved pin set during its protected connection process.

**Applicable conditions:** Useful in narrowly controlled clients with a robust update, recovery and key-rollover design.

**Important limitations:** Bad rollover can cause outages; pinning is not generally suitable for arbitrary browser sites and does not cure endpoint compromise.

**Realistic example:** A controlled device client accepts only the planned service key set and its carefully staged successor.

### Defense 145. Virtual private network (VPN)

Draft provenance ID: 150. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** An authenticated encrypted tunnel carrying selected traffic between specified trusted endpoints across another network.

**How it works:** Encapsulate traffic across an untrusted segment after verifying the tunnel peer and enforcing routing policy.

**Applicable conditions:** Useful for protecting traffic between the client and trusted tunnel endpoint.

**Important limitations:** It does not authenticate every visited site, make a hostile Wi-Fi login safe or protect data after tunnel termination.

**Realistic example:** A remote employee forms a verified organizational tunnel before accessing internal services.

### Defense 146. Address Space Layout Randomization (ASLR)

Draft provenance ID: 156. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Randomizing memory placement to make exploitation that relies on predictable addresses harder.

**How it works:** The platform varies locations of code, libraries, stacks or other mapped regions according to its implementation.

**Applicable conditions:** Useful as a memory-exploitation mitigation with adequate entropy and compatible binaries.

**Important limitations:** Information leaks, limited entropy and code-reuse techniques can weaken it. It does not remove an out-of-bounds memory bug.

**Realistic example:** A process uses randomized library placement while developers repair a vulnerable parser.

### Defense 147. Stack protection canaries

Draft provenance ID: 157. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Guard values placed around certain stack data to detect selected overwrite patterns.

**How it works:** Compiler-generated checks detect unexpected guard changes before a protected function returns.

**Applicable conditions:** Useful as one layer against some stack-based buffer-overflow techniques.

**Important limitations:** Not every object or overwrite is covered, and a leaked guard may be bypassed. They do not establish memory safety.

**Realistic example:** A protected program aborts after an oversized input corrupts a stack guard.

### Defense 148. Managed browser extensions

Draft provenance ID: 184. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Browser add-ons providing defined capabilities under explicit permission and update controls.

**How it works:** Allow only justified extensions from assessed sources and monitor permissions and changes.

**Applicable conditions:** Useful for specific supported browser protections where the extension's authority is appropriate.

**Important limitations:** Extensions can themselves steal data or alter transactions. Adding an arbitrary extension is not a reliable defense against a compromised browser.

**Realistic example:** An administrator removes an unapproved extension with broad access to banking pages and investigates the endpoint.

### Defense 149. Threat-specific DNS security

Draft provenance ID: 183. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A family of controls protecting different parts of name resolution and DNS administration.

**How it works:** Specify whether the objective is DNSSEC validation, protected resolver transport, registrar security or resilient authoritative service.

**Applicable conditions:** Useful only when the chosen mechanism is tied to the actual DNS threat path.

**Important limitations:** Encrypted DNS does not authenticate unsigned zone data, and DNSSEC does not encrypt queries or prevent every registrar-account takeover.

**Realistic example:** A design separates signed-data validation from encrypted client-to-resolver transport rather than calling both one generic fix.

### Defense 150. Email threat filtering

Draft provenance ID: 103. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Inspection of message attributes and content to reduce delivery of harmful mail.

**How it works:** Evaluate attachments, URLs, sender signals and malicious patterns with quarantine and reporting workflows.

**Applicable conditions:** Useful at mail gateways and endpoints when rules and detection data are maintained.

**Important limitations:** Novel lures and compromised senders can pass checks; false positives require review. Delivery is not a trust certification.

**Realistic example:** A gateway quarantines a recognized malicious attachment before it reaches an employee mailbox.

### Defense 151. User security training

Draft provenance ID: 104. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Role-appropriate instruction for recognizing unsafe requests and following verified workflows.

**How it works:** Teach concrete actions and reporting paths using relevant examples and reinforcement.

**Applicable conditions:** Useful as a human layer alongside usable technical and organizational controls.

**Important limitations:** Training does not guarantee recognition or excuse unsafe system design. Outcomes should not depend on perfect vigilance.

**Realistic example:** Staff practice checking a document-sharing request through the known service rather than an unexpected link.

### Defense 152. Independent navigation instead of unexpected text links

Draft provenance ID: 111. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A user practice of reaching services through known applications or addresses rather than unverified SMS destinations.

**How it works:** Discard the untrusted destination and verify the claim through an established entry point.

**Applicable conditions:** Useful for reducing exposure to account, payment and delivery lures in texts.

**Important limitations:** A known application or device can still be compromised, and some legitimate services use texts. The practice is not a guarantee.

**Realistic example:** A customer opens the bank's known app rather than following an alarming text-message link.

### Defense 153. Mobile endpoint security tools

Draft provenance ID: 112. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Device protections that detect or restrict harmful mobile applications, destinations or configurations.

**How it works:** Use supported platform capabilities, management policies and appropriate threat detection.

**Applicable conditions:** Useful for managed devices with supported operating systems and a defined response process.

**Important limitations:** Sandboxing limits what a scanner can observe; social deception and new threats may remain. Tool claims need capability verification.

**Realistic example:** A managed phone warns about an unapproved risky application and reports its installation to administrators.

### Defense 154. SMS and text-message filtering

Draft provenance ID: 113. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Classification or blocking of suspicious text messages by device, carrier or service policy.

**How it works:** Use sender, content and abuse signals to identify likely unwanted or malicious messages.

**Applicable conditions:** Useful as one layer against mass text lures and known malicious patterns.

**Important limitations:** Spoofed sender information, novel wording and legitimate-looking threads can evade filtering; false positives are possible.

**Realistic example:** A device moves a known fraudulent delivery text into its spam folder.

### Defense 155. Certificate authority trust and identity validation

Draft provenance ID: 167. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A trust service and validation process binding public keys to asserted identities under a defined policy.

**How it works:** Clients verify certificate chains, intended names, validity and application-specific identity requirements.

**Applicable conditions:** Useful for authenticating enterprise Wi-Fi servers and other TLS peers when client trust is configured correctly.

**Important limitations:** A certificate from any CA is not sufficient for any identity. Misissued certificates, unsafe user overrides and compromised endpoints remain risks.

**Realistic example:** A Wi-Fi client rejects an authentication-server certificate not valid for its configured organization server.

### Defense 156. Rogue wireless infrastructure detection

Draft provenance ID: 168. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Finding wireless devices or configurations inconsistent with authorized infrastructure.

**How it works:** Combine sensor observations, inventory and network evidence to locate and investigate suspected rogue access points.

**Applicable conditions:** Useful for organizational wireless assessment and incident response.

**Important limitations:** Similar names do not prove malice, and detection does not guarantee prevention before a user connects.

**Realistic example:** An alert identifies an access point imitating a managed network name and prompts physical investigation.

### Defense 157. Disable unsafe automatic network association

Draft provenance ID: 171. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Client policy preventing untrusted or obsolete network profiles from being joined automatically.

**How it works:** Remove unnecessary remembered networks and require appropriately authenticated network configurations.

**Applicable conditions:** Useful against deceptive responders exploiting automatic association behavior.

**Important limitations:** A user can still select a malicious network manually; a remembered name alone never proves network identity.

**Realistic example:** A managed laptop no longer probes for and automatically joins an old public guest network.

### Defense 158. Context-aware output encoding

Draft provenance ID: 151. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Representing untrusted output so the receiving format treats it as data, not executable syntax.

**How it works:** Choose the encoder for the exact HTML, attribute or other supported output context and use safe rendering APIs.

**Applicable conditions:** Useful when displaying plain untrusted text inside a known safe context.

**Important limitations:** Encoding for one interpreter is not safe for another; some script or URL contexts should not accept interpolation at all.

**Realistic example:** An application encodes a comment before displaying it as plain HTML text.

### Defense 159. Content Security Policy (CSP)

Draft provenance ID: 152. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A browser-enforced policy restricting resource loading and script execution for a page.

**How it works:** Use carefully designed directives, nonces or hashes and avoid unnecessary unsafe execution allowances.

**Applicable conditions:** Useful as defense in depth against some script injection and unexpected resource loading.

**Important limitations:** It does not replace safe output handling; permissive policy or trusted-script abuse can undermine it.

**Realistic example:** A site permits only expected scripts with appropriate nonce handling while fixing the underlying injection defect.

### Defense 160. HTML and content sanitization

Draft provenance ID: 153. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Parsing and restricting intentionally permitted rich content to a defined safe subset.

**How it works:** Use a maintained sanitizer suitable for the browser context instead of ad hoc string removal.

**Applicable conditions:** Useful when an application deliberately allows limited formatting or markup.

**Important limitations:** Parser differences, unsafe configuration and later mutation can reintroduce script execution. Sanitization is not needed in place of simple text encoding.

**Realistic example:** A comment editor retains basic formatting but removes active content through a maintained HTML sanitizer.

### Defense 161. Path canonicalization and confinement checks

Draft provenance ID: 154. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Resolving path representations and verifying that access remains within an authorized resource scope.

**How it works:** Handle encodings, separators and platform rules, then use safe file APIs and a verified allowed root.

**Applicable conditions:** Useful when applications accept resource paths rather than opaque identifiers.

**Important limitations:** Naive string-prefix checks, symbolic links and check/use races can bypass confinement even after normalization.

**Realistic example:** A download service rejects a resolved file path that escapes its authorized export directory.

### Defense 162. Chroot filesystem confinement

Draft provenance ID: 155. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Changing a process's apparent filesystem root on supported Unix-like systems.

**How it works:** Limit normal path resolution to a designated tree with appropriate permissions and privilege reduction.

**Applicable conditions:** Useful as a containment layer in carefully configured services.

**Important limitations:** Chroot is not a complete sandbox; privileged processes and unsafe open descriptors may escape intended restrictions.

**Realistic example:** A minimally privileged service receives a restricted filesystem view alongside other isolation controls.

### Defense 163. Protected Management Frames (802.11w)

Draft provenance ID: 169. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Protection for specified robust Wi-Fi management frames when supported and negotiated.

**How it works:** Authenticate relevant management traffic to reduce forgery such as certain deauthentication messages.

**Applicable conditions:** Useful when infrastructure and clients enforce the required protected-management configuration.

**Important limitations:** Not all management frames are covered and radio jamming remains possible. Compatibility and transition settings need verification.

**Realistic example:** A modern wireless deployment requires protected management frames for compatible clients.

### Defense 164. Intrusion detection systems (IDS)

Draft provenance ID: 170. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Sensors that identify suspicious activity and raise alerts rather than inherently blocking it.

**How it works:** Inspect network or host telemetry using supported signatures, protocol checks or analytics.

**Applicable conditions:** Useful when sensor placement, visibility and incident response make alerts actionable.

**Important limitations:** Detection gaps and false positives remain; encrypted payloads may be unavailable. An IDS is not automatically an IPS.

**Realistic example:** A wireless sensor alerts on a burst of suspicious disconnect messages for investigation.

### Defense 165. Virtual local area networks (VLANs)

Draft provenance ID: 162. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Logical separation of local network traffic into defined broadcast domains.

**How it works:** Assign interfaces and apply appropriate inter-VLAN routing and access policy at controlled boundaries.

**Applicable conditions:** Useful for organizing and separating traffic when enforcement and switching configuration are correct.

**Important limitations:** A VLAN is not encryption or complete authorization. Misconfiguration and permitted routing can expose traffic across segments.

**Realistic example:** A guest device VLAN cannot directly reach an administrative segment because routing rules enforce that separation.

### Defense 166. Identity proofing and verification

Draft provenance ID: 119. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Establishing that a claimant corresponds to an asserted real-world or organizational identity.

**How it works:** Evaluate appropriate evidence and independent checks using a process proportionate to the risk.

**Applicable conditions:** Useful for enrollment, account recovery and issuing replacement credentials when identity must be re-established.

**Important limitations:** Proofing differs from authenticating a returning user and from authorizing a particular action. Public trivia is weak evidence.

**Realistic example:** An account-recovery team verifies the employee through approved evidence before issuing a replacement authenticator.

### Defense 167. Role-appropriate security instruction

Draft provenance ID: 118. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Training tied to the decisions and responsibilities people actually have.

**How it works:** Use realistic tasks, clear verification steps and reinforcement that fits operational workflows.

**Applicable conditions:** Useful for impersonation and misleading-information risks alongside enforceable controls.

**Important limitations:** A course completion record does not prove correct action under pressure or remove a technical weakness.

**Realistic example:** Reception staff practice a safe response to someone claiming a senior employee's identity.

### Defense 168. USB device control

Draft provenance ID: 126. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Policy limiting which USB devices or device classes may be used.

**How it works:** Block unapproved storage or other supported classes through operating-system and endpoint controls.

**Applicable conditions:** Useful against untrusted removable media when legitimate peripheral needs are assessed.

**Important limitations:** Storage-only rules may not block a device emulating a keyboard or network adapter. Physical access remains a separate concern.

**Realistic example:** A managed workstation refuses an unapproved removable storage device found in a hallway.

### Defense 169. Enforceable security policies

Draft provenance ID: 127. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Organizational rules specifying approved behavior, responsibilities and exceptions.

**How it works:** Translate policy into workable procedures and technical enforcement where possible, then monitor adherence.

**Applicable conditions:** Useful for removable media, data handling and requests involving trust.

**Important limitations:** A written rule alone cannot stop a device or authenticate a caller. Unsafe exception practices can defeat the rule.

**Realistic example:** A media-transfer policy requires approved devices and a controlled inspection route.

### Defense 170. Access-control vestibules

Draft provenance ID: 128. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Physical entry spaces designed to control passage through sequential doors.

**How it works:** Interlocks and authorization checks can limit entry to an assessed number of people at a time.

**Applicable conditions:** Useful for restricted facilities with appropriate supervision, safe egress and accessibility design.

**Important limitations:** Piggybacking detection and emergency behavior depend on the design; unsafe confinement is unacceptable.

**Realistic example:** A laboratory entry vestibule checks individual authorization before opening the interior door.

### Defense 171. Electronic badge access systems

Draft provenance ID: 129. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Systems that associate a presented credential with access permissions at a physical boundary.

**How it works:** Readers and controllers enforce door rights and retain relevant entry records.

**Applicable conditions:** Useful for managed facility access with prompt revocation and secure credential technology.

**Important limitations:** Shared or cloned badges, tailgating and weak recovery procedures can bypass identity assumptions.

**Realistic example:** A departed employee's badge rights are revoked across managed office entrances.

### Defense 172. Physical security personnel

Draft provenance ID: 130. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Trained people who monitor facilities, verify access and respond to security events.

**How it works:** Apply approved challenge, escort and response procedures with situational judgment.

**Applicable conditions:** Useful where human oversight complements barriers and electronic systems.

**Important limitations:** Staffing, fatigue, deception and unsafe confrontation risks limit coverage. Guards do not substitute for every technical barrier.

**Realistic example:** A guard verifies a visitor's sponsor through a known internal contact before entry.

### Defense 173. Look-alike domain monitoring

Draft provenance ID: 124. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Watching for registrations or changes resembling protected domains and identities.

**How it works:** Compare domain observations with known names and investigate suspicious use before issuing warnings or takedowns.

**Applicable conditions:** Useful for early discovery of typosquatting and brand impersonation.

**Important limitations:** Similarity is not proof of maliciousness, and monitoring does not block access before a response.

**Realistic example:** An alert identifies a newly registered one-letter variation of an organization's login domain.

### Defense 174. Browser typo and look-alike warnings

Draft provenance ID: 125. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** User-facing alerts when a destination resembles a known site or contains suspicious spelling.

**How it works:** A browser or security layer compares destination patterns and prompts the user to verify before proceeding.

**Applicable conditions:** Useful as a navigation aid alongside trusted bookmarks and domain verification.

**Important limitations:** Heuristics can miss deceptive names or warn on legitimate ones; users may ignore prompts.

**Realistic example:** A browser highlights a near-match domain and offers a route to the previously used genuine site.

### Defense 175. Hash-based message authentication code (HMAC)

Draft provenance ID: 160. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A keyed integrity and authenticity construction based on a cryptographic hash.

**How it works:** Parties sharing a secret compute and verify a MAC over the intended message and context.

**Applicable conditions:** Useful when shared-key authentication fits the protocol and keys are protected.

**Important limitations:** It does not encrypt data, provide public signature verification or automatically supply replay protection. It is not a generic collision repair for every protocol.

**Realistic example:** A service verifies a request MAC and separately checks the message's freshness.

### Defense 176. Appropriate modern cryptographic algorithms

Draft provenance ID: 161. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Selecting reviewed cryptographic primitives that provide the properties required by a protocol.

**How it works:** Replace deprecated constructions through a tested design with suitable security strength and implementation support.

**Applicable conditions:** Useful when old collision-sensitive or otherwise broken primitives remain in use.

**Important limitations:** An algorithm name alone does not make a protocol secure; modes, trust, keys and implementation details still matter.

**Realistic example:** A signing workflow migrates from a collision-broken hash to a supported reviewed construction.

### Defense 177. Reinforced doors and entry assemblies

Draft provenance ID: 172. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Physical barriers designed to resist specified forced-entry conditions.

**How it works:** Strengthen the door, frame, hinges, anchoring and locking assembly together.

**Applicable conditions:** Useful for delaying forced access as part of a risk-assessed facility design.

**Important limitations:** A strong panel with a weak frame can fail. Fire egress, accessibility and alternate routes remain important.

**Realistic example:** A facility upgrades a vulnerable service entrance with a rated integrated assembly.

### Defense 178. Physical intrusion alarms

Draft provenance ID: 173. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Sensors and notification systems that detect selected access or tamper events.

**How it works:** Door, motion or other detectors trigger monitored alerts with defined response responsibility.

**Applicable conditions:** Useful for recognizing and responding to attempted or completed forced entry.

**Important limitations:** An alarm does not physically stop entry, and false alarms or delayed response can limit benefit.

**Realistic example:** A forced-open door event reaches a staffed response function with the correct location.

### Defense 179. Suppress network-name advertisement

Draft provenance ID: 185. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A Wi-Fi configuration that omits the SSID from some routine broadcast advertisements.

**How it works:** The network may be absent from a simple visible list, while other management exchanges still reveal identifying information.

**Applicable conditions:** At most an administrative presentation choice, not a meaningful substitute for wireless authentication or encryption.

**Important limitations:** It does not make radio activity or the SSID secret, and probing behavior can create privacy issues. Do not teach it as a wardriving defense.

**Realistic example:** A wireless survey still identifies a network whose access point suppresses normal SSID advertising.

### Defense 180. Evidence-based fact checking

Draft provenance ID: 116. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Assessing a claim against original evidence and credible independent corroboration.

**How it works:** Check dates, context, source provenance and what the evidence actually supports; retain uncertainty where appropriate.

**Applicable conditions:** Useful for suspected misinformation, hoaxes and exaggerated incident claims.

**Important limitations:** Sources can be wrong or incomplete; popularity and repeated reporting may trace to one unreliable origin.

**Realistic example:** An analyst finds that an alleged current breach image actually documents a much older unrelated outage.

### Defense 181. Content moderation procedures

Draft provenance ID: 117. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Policy-based review and handling of material on a managed platform.

**How it works:** Apply stated standards through proportionate review, restriction, removal and appeal workflows.

**Applicable conditions:** Useful for reducing exposure to harmful or misleading content within a platform's authority.

**Important limitations:** Moderation is not an automatic truth detector and can be inconsistent or overbroad. Legal and contextual considerations matter.

**Realistic example:** A forum flags an unsupported security warning for review instead of automatically presenting it as verified guidance.

### Defense 182. Advanced Encryption Standard (AES)

Draft provenance ID: 163. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** A standardized symmetric block cipher used within suitable cryptographic constructions.

**How it works:** A secret key transforms fixed-size blocks; an appropriate mode defines how messages are encrypted and authenticated.

**Applicable conditions:** Useful when the algorithm, mode, nonce handling and key lifecycle fit the application.

**Important limitations:** AES alone is not authenticated encryption, password storage or a complete protocol. Bad mode or key use can defeat the system.

**Realistic example:** An application uses a reviewed AES-based authenticated mode rather than a proprietary cipher.

### Defense 183. Cryptographic key management

Draft provenance ID: 164. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Controls for generating, protecting, distributing, using, revoking and retiring keys.

**How it works:** Separate access, use suitable randomness and storage, track key versions and plan compromise response.

**Applicable conditions:** Useful throughout encrypted and signed system lifecycles, including planned migration and verified compromise response.

**Important limitations:** Protecting keys does not repair a broken algorithm or unsafe protocol. Losing keys may also make legitimate data unrecoverable.

**Realistic example:** A service rotates a compromised encryption key and tracks which data requires re-encryption.

### Defense 184. Reviewed cryptographic standards and designs

Draft provenance ID: 165. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Using appropriate established cryptographic constructions instead of unassessed proprietary inventions.

**How it works:** Match required properties to current standards and validated implementation practice, then test the complete protocol.

**Applicable conditions:** Useful when selecting or replacing an encryption or authentication design.

**Important limitations:** Compliance with a label does not prove correct configuration, safe randomness or suitability for every use.

**Realistic example:** A team rejects a custom substitution cipher and adopts an interoperable reviewed protocol design.

### Defense 185. Credential and key rotation

Draft provenance ID: 166. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED.

**Definition:** Replacing a secret under a defined lifecycle or compromise condition.

**How it works:** Reissue keys or credentials, revoke old use and update dependents through an authenticated process.

**Applicable conditions:** Useful after exposure, cryptoperiod limits or algorithm migration where the system design requires it.

**Important limitations:** Routine password changes without evidence are not universally helpful. Rotation does not fix a weak algorithm or malware stealing the replacement.

**Realistic example:** A leaked service key is revoked and replaced while affected consumers are updated safely.

## Individual mapping judgments — not applied to the authoritative relationships

### Mapping 1: attack 1 → defense 1

Virtual-machine escape → Hypervisor hardening

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Hypervisor patching, minimized virtual devices and restricted management reduce known guest-escape attack paths.

**Limitations / rationale:** Hardening cannot prove the absence of unknown host or firmware vulnerabilities.

### Mapping 2: attack 2 → defense 2

Rootkit → File and system integrity monitoring

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Protected integrity baselines can reveal altered boot or system components associated with a rootkit.

**Limitations / rationale:** A compromised kernel can deceive in-guest tools; baseline and measurement trust must be independent where needed.

### Mapping 3: attack 2 → defense 3

Rootkit → Secure Boot and startup trust

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Verified boot-chain policy can reject unauthorized startup components and reduce some bootkit persistence.

**Limitations / rationale:** Signed vulnerable components, compromised firmware and post-boot rootkits remain possible.

### Mapping 4: attack 3 → defense 4

Fileless or memory-resident malware → Process memory inspection

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Process memory inspection can find injected or memory-resident code not represented by a malicious executable file.

**Limitations / rationale:** Visibility and rapid execution limit coverage; fileless activity can still leave other artifacts.

### Mapping 5: attack 3 → defense 5

Fileless or memory-resident malware → Behavioral security analytics

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Behavior analytics can identify suspicious use of interpreters and legitimate utilities in a fileless execution chain.

**Limitations / rationale:** Legitimate automation can look unusual; alerts need context and response rather than automatic certainty.

### Mapping 6: attack 4 → defense 6

Reflected distributed denial of service → Source verification

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Interpret source verification here as source-network IP anti-spoofing to reject forged reflection requests.

**Limitations / rationale:** Checking an email sender does not stop reflection; victim-side filtering alone cannot control other originating networks.

### Mapping 7: attack 5 → defense 7

Replay of authentication material → Time-based one-time authentication codes

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Time-limited codes narrow the useful lifetime of captured authentication values when the verifier enforces appropriate checks.

**Limitations / rationale:** Codes can be relayed or reused inside a window without single-use enforcement; they do not protect arbitrary messages.

### Mapping 8: attack 5 → defense 8

Replay of authentication material → Authenticated nonces and freshness checks

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An authenticated fresh challenge or one-time nonce can bind a credential proof to its intended exchange.

**Limitations / rationale:** The receiver must verify freshness or non-reuse; simply including randomness is insufficient.

### Mapping 9: attack 6 → defense 9

Cloud-resource misconfiguration → Security configuration and access audits

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Configuration and access audits can discover public permissions and verify their remediation.

**Limitations / rationale:** An audit does not itself remove an exposed bucket policy and can miss changes between checks.

### Mapping 10: attack 6 → defense 10

Cloud-resource misconfiguration → Authenticated data encryption

**CORRECT / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Encryption protects some storage or transport exposure under appropriate key and access arrangements.

**Limitations / rationale:** It does not fix anonymous authorized reads when the service decrypts objects for public users; remove public permissions instead.

### Mapping 11: attack 7 → defense 11

WEP wireless-key recovery → Migration from WEP to supported WPA3

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Removing WEP and deploying a supported modern Wi-Fi configuration eliminates reliance on WEP's broken design.

**Limitations / rationale:** Client compatibility, configuration and implementation security still need assessment; jamming is unaffected.

### Mapping 12: attack 8 → defense 12

Offline password cracking → Cost-tuned password hashing

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Use a cost-tuned salted password KDF to increase the work required per offline password guess.

**Limitations / rationale:** A fast general-purpose hash, even a modern one, is not adequate password storage merely because it is called strong.

### Mapping 13: attack 9 → defense 13

Spyware → Anti-spyware protection

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Anti-spyware detection and remediation can identify and remove supported surveillance software.

**Limitations / rationale:** Novel or privileged surveillance may evade detection, and prior data theft cannot be undone by removal.

### Mapping 14: attack 9 → defense 14

Spyware → Privacy and permission settings

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Restricting application permissions can reduce accessible sensors and personal data before a low-privilege spyware program collects them.

**Limitations / rationale:** Privileged malware may bypass settings; permission review does not reliably remove an active infection.

### Mapping 15: attack 10 → defense 15

Shared-cloud side-channel leakage → Dedicated cloud hosting resources

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Verified dedicated physical resources can reduce a co-tenant's access to the shared resource causing a leak.

**Limitations / rationale:** Provider terminology differs; dedicated virtual placement may still share hardware, and same-host leakage can remain.

### Mapping 16: attack 11 → defense 16

Padding-oracle attack → Authenticated encryption with associated data (AEAD)

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Proper authenticated encryption rejects modified ciphertext before vulnerable application decryption paths expose padding information.

**Limitations / rationale:** Correct nonce handling and implementation matter; do not claim that arbitrary encryption with an unrelated checksum suffices.

### Mapping 17: attack 12 → defense 17

Chosen-plaintext cryptanalysis → Controlled security change

**CORRECT / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A controlled change process supports replacement of a cryptographically broken scheme after review and testing.

**Limitations / rationale:** Change management is not chosen-plaintext security. The mapping needs explicit migration context rather than a prevention claim.

### Mapping 18: attack 13 → defense 18

Wireless radio-frequency jamming → Radio frequency hopping

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Compatible frequency-agile radios may tolerate some narrow-band interference by using other permitted channels.

**Limitations / rationale:** Wideband or powerful jamming can affect all channels; this is not universal anti-jamming protection.

### Mapping 19: attack 13 → defense 19

Wireless radio-frequency jamming → Protected and tested backups

**REMOVE_PROPOSED / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Backups may support recovery if a disruption coincides with data loss.

**Limitations / rationale:** They do not restore radio availability or counter interference; do not teach backups as a jamming defense.

### Mapping 20: attack 14 → defense 20

Bluetooth bluesnarfing → Disable Bluetooth discoverability

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Reduced Bluetooth discovery can lower casual exposure while approved connections remain necessary.

**Limitations / rationale:** Known device addresses and exploitable services can remain reachable; patching or radio shutdown addresses different risks.

### Mapping 21: attack 15 → defense 21

Voice phishing → Independent callback verification

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent callback verification interrupts reliance on a spoofed caller identity before credentials or authority are released.

**Limitations / rationale:** A phone number supplied by the suspect caller is not independent verification.

### Mapping 22: attack 15 → defense 22

Voice phishing → Authenticated secure communication channels

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A trusted authenticated support channel can reduce exposure of sensitive information during verified assistance.

**Limitations / rationale:** An encrypted call can still be fraudulent; transport security alone does not defeat a convincing voice pretext.

### Mapping 23: attack 16 → defense 23

Pretexting → Challenge-response authentication

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An approved challenge-response identity process can test a pretexting requester's claimed identity.

**Limitations / rationale:** Public biographical questions are weak, and proof of identity does not authorize every requested disclosure.

### Mapping 24: attack 16 → defense 24

Pretexting → Privacy policies and handling rules

**CORRECT / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforced handling procedures can define which information staff may disclose to a verified requester.

**Limitations / rationale:** A privacy notice alone does not authenticate anyone or technically prevent pretexting.

### Mapping 25: attack 17 → defense 25

Forged authentication request → Input and schema validation

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Schema validation rejects malformed authentication messages before protocol processing.

**Limitations / rationale:** Well-formed forged assertions remain possible without signature, issuer and freshness checks.

### Mapping 26: attack 17 → defense 26

Forged authentication request → Authentication assertion checks

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Protocol-appropriate identity, signature, audience and freshness checks reject fabricated authentication assertions.

**Limitations / rationale:** The source attack label is broad; a scenario must name the actual assertion and missing verification.

### Mapping 27: attack 18 → defense 27

Brand impersonation → Operational security monitoring

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Monitoring domains, ads and abuse reports can discover impersonating content and support response.

**Limitations / rationale:** Detection is not authentication of every message and does not automatically remove a fraudulent site.

### Mapping 28: attack 18 → defense 28

Brand impersonation → Security awareness education

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Education helps users check trusted routes rather than trusting logos or familiar branding.

**Limitations / rationale:** People cannot reliably identify every impersonation; usable verification and technical controls remain necessary.

### Mapping 29: attack 19 → defense 29

Dumpster diving for information → Secure paper shredding

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate paper destruction removes readable sensitive records before they enter an uncontrolled waste stream.

**Limitations / rationale:** Storage media require technology-appropriate sanitization; careless custody can expose records before destruction.

### Mapping 30: attack 19 → defense 30

Dumpster diving for information → Locked waste containers

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Locked collection containers reduce access before controlled removal and destruction.

**Limitations / rationale:** They leave the contents recoverable if the lock or collection chain is bypassed.

### Mapping 31: attack 20 → defense 31

Shoulder surfing → Screen privacy filters

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A screen privacy filter reduces off-axis observation of displayed information.

**Limitations / rationale:** It does not stop a camera directly behind the user or observation of keyboard input.

### Mapping 32: attack 20 → defense 32

Shoulder surfing → Biometric authentication

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A suitable biometric sign-in can reduce typing of reusable secrets that an observer could record.

**Limitations / rationale:** It does not conceal an unlocked screen, prevent screen capture or solve every authentication-recovery path.

### Mapping 33: attack 21 → defense 33

Environmental disruption of computing → Environmental monitoring sensors

**RETAIN / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Calibrated sensors provide early measurements of heat, water, smoke or power conditions threatening equipment.

**Limitations / rationale:** Sensors do not repair the condition or determine whether the cause is deliberate.

### Mapping 34: attack 21 → defense 34

Environmental disruption of computing → Operational redundancy

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent power, cooling or service paths can preserve operation when an environmental component fails.

**Limitations / rationale:** Shared failure domains and untested failover can defeat redundancy; backups and redundancy are different controls.

### Mapping 35: attack 22 → defense 35

Bloatware and unnecessary software → Supported software removal tools

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Supported removal tools uninstall unneeded packages and associated services after dependency assessment.

**Limitations / rationale:** Not all bloatware is malware; privileged compromise may require a more trustworthy recovery process.

### Mapping 36: attack 22 → defense 36

Bloatware and unnecessary software → Clean system rebuilding

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A verified clean image can remove accumulated unwanted software when rebuilding is appropriate.

**Limitations / rationale:** Rebuilding is disruptive and may reinstall the same bundled programs if the image is not corrected.

### Mapping 37: attack 23 → defense 37

Quantum-enabled cryptographic threat → Post-quantum cryptography

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate standardized post-quantum public-key mechanisms address identified quantum-vulnerable public-key operations.

**Limitations / rationale:** Do not imply current quantum computers break every cipher, or that algorithm migration alone secures the whole protocol.

### Mapping 38: attack 24 → defense 38

Bluejacking → Disable unused Bluetooth

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Disabling an unused Bluetooth interface removes that device's unsolicited Bluetooth-message delivery path.

**Limitations / rationale:** It does not remove existing malware or protect other wireless interfaces.

### Mapping 39: attack 25 → defense 39

Unwanted advertising software → Browser advertising blockers

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Browser ad-request filtering reduces unwanted advertisements and some malvertising exposure.

**Limitations / rationale:** It does not uninstall all adware or establish that all permitted content is safe.

### Mapping 40: attack 25 → defense 40

Unwanted advertising software → Trusted acquisition sources

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Verified distribution sources reduce deceptive or bundled software acquisition.

**Limitations / rationale:** Legitimate publishers can distribute unwanted software or suffer compromise; reputation is not an integrity guarantee.

### Mapping 41: attack 26 → defense 41

Operating-system command injection → Context-specific escaping

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Correct context-specific escaping can reduce unsafe shell interpretation in constrained legacy paths.

**Limitations / rationale:** Prefer avoiding a shell; quoting errors and argument injection can remain even when some metacharacters are escaped.

### Mapping 42: attack 26 → defense 42

Operating-system command injection → Allowlisting permitted operations

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Explicit allowlists constrain permitted operations and inputs when combined with safe non-shell interfaces.

**Limitations / rationale:** An approved string can still be interpreted unsafely downstream; verify the complete command construction.

### Mapping 43: attack 27 → defense 43

SQL injection → Prepared SQL statements and bound parameters

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Bound query parameters keep untrusted values from changing SQL syntax.

**Limitations / rationale:** Dynamic identifiers and unsafe query paths still need controlled selection and review.

### Mapping 44: attack 27 → defense 44

SQL injection → Web application firewall (WAF)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A WAF can block recognized SQL injection patterns while code remediation is arranged.

**Limitations / rationale:** Bypasses and false positives remain; it is not a replacement for separating SQL instructions and data.

### Mapping 45: attack 28 → defense 45

Process memory injection → Data Execution Prevention (DEP)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Non-executable data pages obstruct injection that depends on executing bytes in those pages.

**Limitations / rationale:** Code reuse, executable mappings and other injection paths remain; DEP does not remove the vulnerability.

### Mapping 46: attack 28 → defense 46

Process memory injection → Secure software construction

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Memory-safe construction and safe process interfaces can remove the defect enabling a specific injection path.

**Limitations / rationale:** The actual path must be identified; a general secure-coding label cannot certify every process boundary.

### Mapping 47: attack 29 → defense 47

Logic bomb → Independent code review

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent source review can identify suspicious destructive triggers before acceptance.

**Limitations / rationale:** Review may miss obfuscation, dependencies or code introduced after review in the build process.

### Mapping 48: attack 29 → defense 48

Logic bomb → Resource access controls

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Restricting changes to sensitive code and scheduled jobs reduces opportunities to plant destructive triggers.

**Limitations / rationale:** An already authorized maintainer may still abuse permitted access; access controls need separation of duties and oversight.

### Mapping 49: attack 30 → defense 49

Malicious insider activity → User behavior analytics

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** User behavior analytics can flag unusual access or exports for investigation.

**Limitations / rationale:** Intent cannot be inferred reliably from anomaly alone; privacy and legitimate role changes require context.

### Mapping 50: attack 30 → defense 50

Malicious insider activity → Least privilege

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Least privilege limits the resources and actions an insider or stolen account can abuse.

**Limitations / rationale:** Required legitimate access can still be misused, so this is impact reduction rather than complete prevention.

### Mapping 51: attack 31 → defense 51

Web session hijacking → Session-cookie security attributes

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate Secure, HttpOnly and SameSite cookie attributes reduce distinct token exposure paths.

**Limitations / rationale:** No attribute makes a stolen live token universally unusable; XSS and endpoint compromise remain relevant.

### Mapping 52: attack 31 → defense 52

Web session hijacking → Session expiration and idle timeouts

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Server-enforced idle and absolute lifetime limits reduce the usable window of a stolen session.

**Limitations / rationale:** An attacker can act before expiration or keep some sessions active; invalidation and reauthentication need additional design.

### Mapping 53: attack 32 → defense 10

On-path interception → Authenticated data encryption

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authenticated encryption protects data across a path where an intermediary could observe or alter it.

**Limitations / rationale:** Unauthenticated encryption does not establish peer identity, and compromised endpoints remain outside that guarantee.

### Mapping 54: attack 32 → defense 53

On-path interception → Mutual peer authentication

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Mutual authentication checks both endpoint identities to resist active peer impersonation.

**Limitations / rationale:** Trust configuration, identity binding and key protection are essential; a protocol label is not proof of correct validation.

### Mapping 55: attack 33 → defense 54

DNS cache poisoning → DNS Security Extensions (DNSSEC)

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Correct DNSSEC validation authenticates signed DNS data against the configured chain of trust.

**Limitations / rationale:** Unsigned data, registrar compromise and traffic confidentiality are different problems.

### Mapping 56: attack 33 → defense 55

DNS cache poisoning → Hardened and trusted DNS resolvers

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Hardened resolvers with appropriate validation and controlled access reduce cache-poisoning exposure.

**Limitations / rationale:** A resolver's reputation alone does not establish that every response is authenticated.

### Mapping 57: attack 34 → defense 56

ARP poisoning → Dynamic ARP Inspection

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Switch ARP validation checks advertisements against trusted local address bindings.

**Limitations / rationale:** Trust-port errors and unhandled static hosts can bypass protection or interrupt service.

### Mapping 58: attack 34 → defense 57

ARP poisoning → Static network address bindings

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Managed fixed ARP bindings prevent unwanted dynamic replacement for selected stable peers.

**Limitations / rationale:** Manual drift and compromised legitimate devices remain concerns; this does not scale automatically.

### Mapping 59: attack 35 → defense 58

Amplified reflection DDoS → BCP 38 source-address filtering

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Source-network anti-spoofing rejects forged requests before they enlist reflection amplifiers.

**Limitations / rationale:** Deployment elsewhere is required to stop abuse from other networks; not every DDoS uses spoofed sources.

### Mapping 60: attack 35 → defense 59

Amplified reflection DDoS → Network firewall rules

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Relevant boundary rules can close exposed amplifiers or block identifiable abusive service traffic.

**Limitations / rationale:** The rule must be on an effective path; victim-side filtering cannot restore bandwidth already saturated upstream.

### Mapping 61: attack 36 → defense 25

Abuse of a serverless function → Input and schema validation

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Validate function events and inputs before they influence resource selection or execution.

**Limitations / rationale:** Valid input can still invoke an overprivileged function, and dependency flaws require additional controls.

### Mapping 62: attack 36 → defense 60

Abuse of a serverless function → Identity and access management (IAM)

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Scoped service identities and resource policies reduce the reachable data and actions of a compromised function.

**Limitations / rationale:** IAM does not repair vulnerable code and overbroad trust relationships can defeat intended boundaries.

### Mapping 63: attack 37 → defense 61

Attack against WPA-protected Wi-Fi → Configured WPA3 wireless security

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A correctly configured modern Wi-Fi deployment removes weaknesses associated with obsolete protocol modes.

**Limitations / rationale:** WPA3 does not repair every access-point implementation flaw or make transition configurations uniformly safe.

### Mapping 64: attack 37 → defense 62

Attack against WPA-protected Wi-Fi → Device firmware security updates

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Applicable verified firmware fixes address known wireless implementation vulnerabilities.

**Limitations / rationale:** Patches must match affected devices, and compromise before patching may require additional response.

### Mapping 65: attack 38 → defense 63

Implementation side-channel attack → Constant-time cryptographic implementation

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Reviewed constant-time sensitive operations reduce certain secret-dependent timing and cache leaks.

**Limitations / rationale:** The deployed compiler and platform matter; power, fault and other side channels need separate treatment.

### Mapping 66: attack 38 → defense 64

Implementation side-channel attack → Hardware security module (HSM)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An assessed HSM can confine keys and sensitive operations within a hardened boundary.

**Limitations / rationale:** Not every HSM or operation is free of side channels, and authorized misuse of the key can still occur.

### Mapping 67: attack 39 → defense 65

Exploitable race condition → Mutual-exclusion locking (mutex)

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Consistent locking protects a correctly scoped shared-state invariant from unsafe concurrent interleaving.

**Limitations / rationale:** All participants must use the lock, and deadlocks or cross-process resource changes require design.

### Mapping 68: attack 39 → defense 66

Exploitable race condition → Atomic operations and transactions

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A suitable atomic operation or transaction keeps the complete check-and-update invariant indivisible.

**Limitations / rationale:** Atomic individual reads are insufficient when the security decision spans multiple operations.

### Mapping 69: attack 40 → defense 67

Credential stuffing → Credential breach monitoring

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Confirmed exposure reports can trigger credential invalidation and investigation before further stuffing attempts.

**Limitations / rationale:** Breach intelligence is incomplete and delayed; observing exposure does not itself prevent a login.

### Mapping 70: attack 40 → defense 68

Credential stuffing → Unique passwords per service

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Different passwords for different services break the cross-service reuse prerequisite of credential stuffing.

**Limitations / rationale:** A credential stolen from the target service or a compromised password manager remains exposed.

### Mapping 71: attack 41 → defense 69

Password spraying → Correlated failed-login monitoring

**RETAIN / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Correlation across accounts and time can identify low-rate password spraying missed by per-account thresholds.

**Limitations / rationale:** An alert needs response and sufficient telemetry; distributed slow attempts can remain difficult to distinguish.

### Mapping 72: attack 41 → defense 70

Password spraying → Multi-factor authentication (MFA)

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate additional authentication factors reduce takeover with a guessed password alone.

**Limitations / rationale:** Phishable factors, weak recovery and already stolen sessions can undermine protection; prefer phishing-resistant methods.

### Mapping 73: attack 42 → defense 71

Protocol downgrade attack → Disable obsolete protocols and features

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Removing deprecated versions and weak fallback choices prevents negotiation of those specific options.

**Limitations / rationale:** Remaining implementations can still have flaws; compatibility and authenticated negotiation need testing.

### Mapping 74: attack 42 → defense 72

Protocol downgrade attack → HTTP Strict Transport Security (HSTS)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** HSTS reduces browser HTTP fallback for the protected origin after valid policy learning or appropriate preload.

**Limitations / rationale:** It does not prevent every TLS protocol downgrade and does not authenticate an unrelated look-alike domain.

### Mapping 75: attack 43 → defense 73

Unauthorized wireless access point → Wireless intrusion detection and prevention

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Wireless sensors and inventory comparison can find unapproved access points and support assessed response.

**Limitations / rationale:** Detection can miss radios or misclassify legitimate equipment; automated disruption needs legal and operational review.

### Mapping 76: attack 43 → defense 74

Unauthorized wireless access point → MAC-address filtering

**REMOVE_PROPOSED / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** MAC lists can assist limited local device administration.

**Limitations / rationale:** Spoofable MAC addresses do not authenticate an access point or reliably prevent unauthorized AP deployment; do not teach this as rogue-AP prevention.

### Mapping 77: attack 44 → defense 75

Keystroke logging → On-screen virtual keyboards

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An on-screen keyboard may bypass a logger that observes only physical key events.

**Limitations / rationale:** Screen capture, pointer capture and browser hooks can still collect the input; do not present it as endpoint security.

### Mapping 78: attack 44 → defense 76

Keystroke logging → Anti-malware protection

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Anti-malware detection can find and quarantine supported software keyloggers.

**Limitations / rationale:** Hardware loggers and privileged or novel software require different inspection and recovery steps.

### Mapping 79: attack 45 → defense 77

Denial of service → Request rate limiting

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforced quotas before expensive work reduce request-exhaustion paths within the service's control.

**Limitations / rationale:** Distributed sources and constrained upstream links can defeat local request-based protection.

### Mapping 80: attack 45 → defense 78

Denial of service → Load balancing and capacity distribution

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Additional independently provisioned service instances can tolerate some workload pressure or instance failures.

**Limitations / rationale:** Shared dependencies and total capacity remain finite; balancing is not a complete DoS prevention mechanism.

### Mapping 81: attack 46 → defense 79

Online brute-force password guessing → Account lockouts and progressive login restrictions

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Lockouts or progressive restrictions slow online guesses on the protected authentication path.

**Limitations / rationale:** Rigid lockouts can be abused for denial of service and do not stop offline cracking or all distributed spraying.

### Mapping 82: attack 46 → defense 80

Online brute-force password guessing → CAPTCHA and automation challenges

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Automation challenges can add friction to some online guessing tools.

**Limitations / rationale:** Solvers, relays and bypasses exist; CAPTCHA alone is not a sufficient authentication or guessing defense.

### Mapping 83: attack 47 → defense 81

Protocol message replay → Authenticated sequence numbers

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authenticated sequence values and receiver state reject already accepted protocol messages.

**Limitations / rationale:** Reset, wraparound and session binding must not reopen acceptance of captured values.

### Mapping 84: attack 47 → defense 82

Protocol message replay → One-time authentication passwords or codes

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A genuinely one-time code can prevent reuse of a particular authentication value when it is bound and checked correctly.

**Limitations / rationale:** It does not provide replay protection for arbitrary application commands or prevent live relay before use.

### Mapping 85: attack 48 → defense 8

Replay against an IoT command protocol → Authenticated nonces and freshness checks

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authenticated fresh challenges or checked one-time nonces prevent acceptance of captured device commands.

**Limitations / rationale:** Device reset, storage limits and concurrent sessions must not reopen the replay window.

### Mapping 86: attack 48 → defense 83

Replay against an IoT command protocol → Authenticated timestamps and freshness windows

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authenticated timestamps restrict the age of accepted commands with a defined time window.

**Limitations / rationale:** Repeated messages inside the window remain possible without additional replay tracking; clock rollback must be handled.

### Mapping 87: attack 49 → defense 84

Cross-site request forgery → Request-bound anti-CSRF tokens

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Interpret Tokens specifically as server-validated request-bound anti-CSRF values in this mapping.

**Limitations / rationale:** Generic session or bearer tokens are not automatically anti-CSRF protection; XSS or leaked tokens can defeat it.

### Mapping 88: attack 49 → defense 85

Cross-site request forgery → SameSite cookie policy

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate SameSite policy reduces cookie sending in selected cross-site contexts.

**Limitations / rationale:** It is not sufficient for every CSRF situation; unsafe endpoints and same-site attacks remain concerns.

### Mapping 89: attack 50 → defense 86

RFID credential cloning → Cryptographically authenticated RFID

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Use cryptographic tag authentication with protected keys and fresh challenges, rather than static identifier acceptance.

**Limitations / rationale:** Encrypted stored data alone does not prevent cloning or relay; reader and protocol design must be assessed.

### Mapping 90: attack 50 → defense 87

RFID credential cloning → Radio shielding

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate shielding limits opportunities for unauthorized radio reading while the credential is enclosed.

**Limitations / rationale:** It does not protect a credential during legitimate use or invalidate a copy already obtained.

### Mapping 91: attack 51 → defense 88

Dictionary-based password guessing → Strong password selection

**CORRECT / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Prefer long unique passwords and common-value blocklists over the legacy idea of predictable complexity recipes.

**Limitations / rationale:** Composition rules alone can produce guessable patterns; phishing and credential theft are different attack paths.

### Mapping 92: attack 51 → defense 89

Dictionary-based password guessing → Per-password salting

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Unique salts prevent shared offline precomputation against stored verifiers.

**Limitations / rationale:** Salts do not block online dictionary guesses or eliminate offline guessing of an individual weak password.

### Mapping 93: attack 52 → defense 90

Rainbow-table password recovery → Uniquely salted password verifiers

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Per-record random salts make one reusable rainbow-table computation impractical across a user database.

**Limitations / rationale:** Use an appropriate password KDF too; salts do not create entropy in a weak password.

### Mapping 94: attack 52 → defense 91

Rainbow-table password recovery → Password KDF work factors (key stretching)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Cost-tuned password derivation increases the cost of computing candidates or tables.

**Limitations / rationale:** Cost alone does not diversify records; unique salts are needed to prevent shared precomputation.

### Mapping 95: attack 53 → defense 92

Default credential exploitation → Secure initial and compromised-credential changes

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Require removal of shared factory defaults during secure provisioning or after confirmed exposure.

**Limitations / rationale:** Do not reinterpret this as arbitrary periodic password changes without evidence; predictable replacement patterns can remain weak.

### Mapping 96: attack 53 → defense 93

Default credential exploitation → System hardening

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Hardening removes unused default accounts and restricts reachable management interfaces.

**Limitations / rationale:** A baseline must actually check credentials and effective access; generic hardening does not prove every default is gone.

### Mapping 97: attack 54 → defense 94

Birthday-bound collision search → SHA-3 hashing

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An appropriately chosen SHA-3 variant supplies modern collision resistance for suitable designs.

**Limitations / rationale:** Output size and intended use matter; it is not a generic password-storage or message-authentication replacement.

### Mapping 98: attack 54 → defense 95

Birthday-bound collision search → Adequate cryptographic output length

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Sufficient output size raises generic birthday collision-search cost for an otherwise sound hash construction.

**Limitations / rationale:** A longer output cannot rescue an algorithm with a practical structural collision weakness.

### Mapping 99: attack 55 → defense 96

Quid pro quo social engineering → Independent request verification

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent verification of a support or reward offer checks authority before the requested disclosure or installation.

**Limitations / rationale:** A vague instruction to verify is insufficient without a trusted evidence route and authorization check.

### Mapping 100: attack 55 → defense 97

Quid pro quo social engineering → Social-engineering response training

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Practice recognizing exchanges of benefits for secrets can improve refusal and reporting decisions.

**Limitations / rationale:** Training does not prove the actual requester is legitimate or prevent malware execution by itself.

### Mapping 101: attack 56 → defense 27

Piggybacking into a restricted area → Operational security monitoring

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Physical-access monitoring can reveal unexpected accompaniment or movement after entry.

**Limitations / rationale:** It does not necessarily stop an unauthorized visitor at the door; observation needs a safe response process.

### Mapping 102: attack 56 → defense 98

Piggybacking into a restricted area → Visitor escort procedures

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Visitor escort procedures limit movement to approved routes and responsible accompaniment.

**Limitations / rationale:** Compliance, staffing and safe challenge practices determine effectiveness; an unattended visitor can still cross interior boundaries.

### Mapping 103: attack 57 → defense 99

Lock picking → High-security mechanical locks

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A rated installed lock with controlled keys increases resistance to specified manipulation techniques.

**Limitations / rationale:** Weak frames, alternate entrances and stolen authorized keys can bypass the cylinder.

### Mapping 104: attack 57 → defense 100

Lock picking → Electronic physical access security

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Electronic access monitoring can detect an unexpected opening or add independent entry verification.

**Limitations / rationale:** An electronic label does not imply mechanical pick resistance and an alert may occur after entry.

### Mapping 105: attack 58 → defense 101

Security hoax → Security-claim source verification

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent source checking interrupts action based on a fabricated security instruction.

**Limitations / rationale:** Evidence can be incomplete; verification must include date, applicability and the actual requested action.

### Mapping 106: attack 58 → defense 102

Security hoax → Incident response plans

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An exercised response plan gives staff a safe route to triage questionable incident claims.

**Limitations / rationale:** A plan alone does not establish that the claim is true or block harmful instructions.

### Mapping 107: attack 59 → defense 19

Ransomware and extortion → Protected and tested backups

**RETAIN / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Tested isolated or immutable backups enable data recovery without depending on the extortionist.

**Limitations / rationale:** Backups do not prevent encryption, undo data theft or guarantee that restored systems are free of persistence.

### Mapping 108: attack 59 → defense 103

Ransomware and extortion → Security gateways

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A specified mail or web gateway can reduce ransomware delivery through its inspected channel.

**Limitations / rationale:** The broad gateway label is not a universal barrier; direct access, stolen credentials and unknown payloads can bypass it.

### Mapping 109: attack 59 → defense 104

Ransomware and extortion → Vulnerability patch management

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Applicable patching removes known exploitation paths used by some ransomware intrusions.

**Limitations / rationale:** Credential abuse and social engineering can remain, and patching does not reverse existing compromise.

### Mapping 110: attack 60 → defense 105

Software supply-chain compromise → Supplier and system security assessments

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Supplier and build-practice assessments identify risks and enforceable requirements before reliance on a dependency.

**Limitations / rationale:** A favorable assessment cannot guarantee future publisher or build integrity.

### Mapping 111: attack 60 → defense 106

Software supply-chain compromise → Verified digital signatures

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Trusted signature verification detects tampering after signing and binds a release to an accepted publisher key.

**Limitations / rationale:** A compromised build or signing key can produce a validly signed malicious release; signatures do not prove benign code.

### Mapping 112: attack 61 → defense 107

Exploitation of a zero-day vulnerability → Heuristic threat detection

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Heuristic or behavior-based detection can identify exploit-like actions before a precise signature exists.

**Limitations / rationale:** False positives and unseen techniques remain; do not claim that heuristics detect every zero-day.

### Mapping 113: attack 61 → defense 108

Exploitation of a zero-day vulnerability → Threat intelligence

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Assessed intelligence guides hunting and protective priorities as new exploit evidence emerges.

**Limitations / rationale:** Intelligence can be incomplete or stale and does not itself block an unknown vulnerability.

### Mapping 114: attack 62 → defense 109

Attack against operational technology → Air-gap and strong network isolation

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Strong verified network isolation removes direct remote paths where the operational design permits it.

**Limitations / rationale:** Media, maintenance laptops and supply-chain routes can cross the boundary; a claimed air gap is not immunity.

### Mapping 115: attack 62 → defense 110

Attack against operational technology → Industrial and SCADA network firewalls

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Industrial boundary policy restricts approved control-system paths and supported protocol operations.

**Limitations / rationale:** Unsafe filtering can cause physical-process disruption; safety engineering and operational validation are necessary.

### Mapping 116: attack 63 → defense 96

Malicious software update → Independent request verification

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent release and publisher verification supports a trustworthy update decision.

**Limitations / rationale:** A generic verification instruction needs concrete evidence and cannot certify that an authentic publisher was not compromised.

### Mapping 117: attack 63 → defense 106

Malicious software update → Verified digital signatures

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Signature verification with an independently trusted key detects package tampering after signing.

**Limitations / rationale:** A correctly signed update can still be malicious if the publisher or signing pipeline was compromised.

### Mapping 118: attack 64 → defense 111

Network worm → Network segmentation

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforced zone boundaries limit lateral reach between network segments.

**Limitations / rationale:** Permitted paths and shared administration can bridge zones; segmentation does not eradicate infected systems.

### Mapping 119: attack 64 → defense 112

Network worm → Network firewalls

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Service-access rules reduce reachable propagation paths used by a worm.

**Limitations / rationale:** Allowed vulnerable services and internal paths may still permit spread; firewall policy does not patch hosts.

### Mapping 120: attack 64 → defense 113

Network worm → Intrusion prevention systems (IPS)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** IPS signatures or protocol checks can block recognized worm exploit traffic.

**Limitations / rationale:** Novel exploits, encryption and evasion reduce coverage; false positives can disrupt legitimate service.

### Mapping 121: attack 65 → defense 114

Container breakout → Security-Enhanced Linux (SELinux)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforcing appropriate SELinux policy restricts resources a container process can access beyond ordinary permissions.

**Limitations / rationale:** Permissive mode, broad policy and kernel vulnerabilities can undermine confinement.

### Mapping 122: attack 65 → defense 115

Container breakout → Kernel resource namespaces

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Namespaces reduce shared resource views as one component of container isolation.

**Limitations / rationale:** They are not a complete security boundary; host sockets, privileges and kernel defects can permit breakout.

### Mapping 123: attack 66 → defense 96

Business email compromise → Independent request verification

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Check changed payment or disclosure instructions through established business evidence and contacts.

**Limitations / rationale:** A generic instruction to verify must be turned into a defined independent process.

### Mapping 124: attack 66 → defense 116

Business email compromise → Domain-based Message Authentication, Reporting and Conformance (DMARC)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforced DMARC reduces certain unauthorized uses of a protected mail domain.

**Limitations / rationale:** It does not stop fraud through a compromised legitimate mailbox or a look-alike domain and does not validate invoice intent.

### Mapping 125: attack 66 → defense 117

Business email compromise → Financial authorization and fraud controls

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent financial approvals and payee-change checks constrain the transaction even if email is deceptive.

**Limitations / rationale:** Collusion, unsafe exceptions and compromised approvers can still undermine the workflow.

### Mapping 126: attack 67 → defense 118

Executive-targeted phishing → Executive-focused security training

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Role-specific practice helps executives and assistants recognize authority and confidentiality pretexts.

**Limitations / rationale:** Senior staff still need enforceable verification procedures and technical controls; training alone is insufficient.

### Mapping 127: attack 67 → defense 119

Executive-targeted phishing → Out-of-band verification procedures

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An independently verified request and dual approval can interrupt high-value impersonation before a transfer or disclosure.

**Limitations / rationale:** The second channel must not be supplied by or controlled through the suspicious communication.

### Mapping 128: attack 67 → defense 120

Executive-targeted phishing → Restricted access to sensitive information

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Limiting sensitive-data access reduces what a compromised executive workflow can expose.

**Limitations / rationale:** It does not authenticate the incoming request and cannot prevent misuse of legitimately permitted data.

### Mapping 129: attack 68 → defense 70

Remote access Trojan → Multi-factor authentication (MFA)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** MFA can reduce an attacker's ability to obtain remote access with a stolen password alone.

**Limitations / rationale:** It does not stop a Trojan already running or an attacker using an existing victim session or outbound tunnel.

### Mapping 130: attack 68 → defense 121

Remote access Trojan → Service and port exposure control

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Restrict unnecessary remote-control service exposure and assess outbound connection policy.

**Limitations / rationale:** A Trojan may use permitted protocols and destinations, so closing inbound ports is not sufficient.

### Mapping 131: attack 68 → defense 122

Remote access Trojan → Anomaly detection

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Unusual process or connection behavior can indicate covert remote control for investigation.

**Limitations / rationale:** Legitimate remote administration may look unusual, and attackers can blend into permitted activity.

### Mapping 132: attack 69 → defense 27

Botnet activity → Operational security monitoring

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Correlated endpoint and network observations can identify devices contacting botnet infrastructure.

**Limitations / rationale:** Indicators can be stale and monitoring alone does not remove the bot or block every control route.

### Mapping 133: attack 69 → defense 123

Botnet activity → Endpoint or workload isolation

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Isolating affected devices limits their ability to receive commands or attack other resources.

**Limitations / rationale:** Isolation does not eradicate malware and must preserve safe response and operational requirements.

### Mapping 134: attack 69 → defense 124

Botnet activity → Authorized sinkholing

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authorized sinkholing can redirect supported command channels and identify infected clients.

**Limitations / rationale:** Alternative channels and embedded addresses may survive; authority and collateral effects must be assessed.

### Mapping 135: attack 70 → defense 9

Privilege escalation → Security configuration and access audits

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Permission and configuration reviews can identify escalation paths and verify remediation.

**Limitations / rationale:** A periodic audit is not continuous enforcement or a patch for an unknown kernel vulnerability.

### Mapping 136: attack 70 → defense 50

Privilege escalation → Least privilege

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Reducing standing privileges and controlling elevation limits attack opportunity and impact.

**Limitations / rationale:** Required privileges can still be abused; escalation defects in trusted components require direct remediation.

### Mapping 137: attack 71 → defense 125

Pass-the-hash authentication abuse → Restrict or disable NTLM

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Assessed restriction or retirement of NTLM removes the specific accepted path for NTLM-hash authentication abuse.

**Limitations / rationale:** Compatibility and fallback need verification; other stolen credentials or Kerberos material remain risks.

### Mapping 138: attack 71 → defense 126

Pass-the-hash authentication abuse → Kerberos authentication

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A correctly planned Kerberos migration can reduce reliance on NTLM when fallback is actually restricted.

**Limitations / rationale:** Kerberos alone is not a complete pass-the-hash defense and does not prevent stolen-key or stolen-ticket attacks.

### Mapping 139: attack 72 → defense 127

Kubernetes workload or cluster compromise → Role-based access control (RBAC)

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriately scoped cluster API roles restrict who can create or change powerful resources.

**Limitations / rationale:** RBAC does not inspect every unsafe pod setting and overbroad role grants can permit escalation.

### Mapping 140: attack 72 → defense 128

Kubernetes workload or cluster compromise → Kubernetes workload admission security policy

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Use supported workload admission controls such as Pod Security Admission and assessed admission policies.

**Limitations / rationale:** The removed PodSecurityPolicy API is not a current deployment recommendation; runtime and kernel risks remain.

### Mapping 141: attack 73 → defense 111

IoT devices used in DDoS → Network segmentation

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforced network zones limit access to and movement from compromised IoT fleets.

**Limitations / rationale:** Segmentation does not remove bots and cannot automatically absorb traffic aimed at an external victim.

### Mapping 142: attack 73 → defense 129

IoT devices used in DDoS → Supported software and device updates

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Applicable verified updates remove known device vulnerabilities used for bot recruitment.

**Limitations / rationale:** Default credentials, unsupported devices and persistence after compromise may still need separate treatment.

### Mapping 143: attack 74 → defense 130

Spear phishing → Message-sender verification

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent verification of identity and intent can interrupt a tailored request before sensitive action.

**Limitations / rationale:** Familiar context and a genuine compromised mailbox can still mislead; domain authentication is not enough.

### Mapping 144: attack 74 → defense 131

Spear phishing → Managed threat-protection controls

**CORRECT / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Specify the actual mail or endpoint capability used to inspect the spear-phishing delivery path.

**Limitations / rationale:** Threat Protection is too broad to imply a standardized or universally effective defense without a stated mechanism.

### Mapping 145: attack 74 → defense 132

Spear phishing → Security simulation exercises

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authorized simulations rehearse response to tailored lures and expose workflow weaknesses.

**Limitations / rationale:** An exercise does not verify a real sender or block an actual payload.

### Mapping 146: attack 75 → defense 133

Watering-hole compromise → Web destination and content filtering

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Blocking a known compromised destination reduces visits while remediation and investigation proceed.

**Limitations / rationale:** Previously unclassified or selectively served content can evade filters, and legitimate workflow disruption must be managed.

### Mapping 147: attack 75 → defense 134

Watering-hole compromise → Endpoint detection and response (EDR)

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Endpoint telemetry can reveal exploitation following a visit to a trusted but compromised site.

**Limitations / rationale:** Detection may occur after execution and depends on sensor visibility and timely response.

### Mapping 148: attack 75 → defense 135

Watering-hole compromise → Security scanning

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Relevant web or endpoint scanning can identify recognized malicious content or exposed vulnerabilities.

**Limitations / rationale:** A clean scan is point-in-time evidence, not proof that selectively served or novel content is safe.

### Mapping 149: attack 76 → defense 28

Trojan horse malware → Security awareness education

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Education helps users avoid deceptive installers and report suspicious software offers.

**Limitations / rationale:** A convincing or trusted-source Trojan can still bypass human judgment.

### Mapping 150: attack 76 → defense 136

Trojan horse malware → Application allowlisting

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An assessed execution allowlist can prevent unapproved disguised programs from running.

**Limitations / rationale:** Approved signed tools or interpreters can be abused and approval rules require maintenance.

### Mapping 151: attack 76 → defense 137

Trojan horse malware → Behavior-based threat detection

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Behavioral detections can reveal a Trojan's actions even when its file appears plausible.

**Limitations / rationale:** False positives and evasion remain, and detection needs containment and recovery follow-through.

### Mapping 152: attack 77 → defense 129

Computer virus → Supported software and device updates

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Applicable updates remove known vulnerabilities that some infected content exploits.

**Limitations / rationale:** Viruses can also run through user authorization; updates do not guarantee removal of an existing infection.

### Mapping 153: attack 77 → defense 138

Computer virus → Antivirus protection

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Antivirus can recognize and quarantine supported infected files and execution behavior.

**Limitations / rationale:** Novel or concealed infection can be missed and prior compromise may require more than quarantine.

### Mapping 154: attack 77 → defense 139

Computer virus → Safer web use

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Safer navigation and download handling reduce some exposure to infected programs.

**Limitations / rationale:** Legitimate sites and publishers can be compromised; user caution is not a complete malware boundary.

### Mapping 155: attack 78 → defense 140

Distributed denial of service → Upstream DDoS scrubbing

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Sufficiently provisioned upstream scrubbing filters flood traffic before the victim's constrained link.

**Limitations / rationale:** Capacity, routing and application-layer filtering limits remain; there is no unlimited mitigation guarantee.

### Mapping 156: attack 78 → defense 141

Distributed denial of service → Network traffic analysis

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Traffic measurements help distinguish attack patterns and select an appropriate mitigation.

**Limitations / rationale:** Analysis does not itself block traffic or restore exhausted network capacity.

### Mapping 157: attack 78 → defense 142

Distributed denial of service → Internet service provider coordination

**RETAIN / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An established ISP response route enables filtering or routing changes outside the customer's limited edge.

**Limitations / rationale:** Provider capability, contract and response time vary; coordination must be prepared before an incident.

### Mapping 158: attack 79 → defense 143

Man-in-the-middle interception → Transport Layer Security (TLS)

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Correctly validated TLS protects the intended transport session against intermediary observation and alteration.

**Limitations / rationale:** Misissued trust, user overrides, compromised endpoints and application-level identity errors remain concerns.

### Mapping 159: attack 79 → defense 144

Man-in-the-middle interception → Certificate or public-key pinning

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Well-managed pins can narrow accepted service identities in controlled clients.

**Limitations / rationale:** Rollover errors can cause outages, and pinning does not make a compromised endpoint trustworthy.

### Mapping 160: attack 79 → defense 145

Man-in-the-middle interception → Virtual private network (VPN)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A verified VPN protects traffic across the segment between its authenticated endpoints.

**Limitations / rationale:** It does not authenticate every destination after tunnel termination or make a deceptive Wi-Fi enrollment page safe.

### Mapping 161: attack 80 → defense 46

Buffer overflow → Secure software construction

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Bounds-safe interfaces and memory-safe construction remove the defective write rather than just complicating exploitation.

**Limitations / rationale:** Unsafe interoperability and unchecked paths still need review and boundary testing.

### Mapping 162: attack 80 → defense 146

Buffer overflow → Address Space Layout Randomization (ASLR)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** ASLR makes exploit addresses less predictable where sufficient randomization is available.

**Limitations / rationale:** Information leaks, low entropy and code reuse can reduce benefit; the overflow still exists.

### Mapping 163: attack 80 → defense 147

Buffer overflow → Stack protection canaries

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Compiler canaries detect some protected stack overwrites before control returns.

**Limitations / rationale:** Not all writes or objects are covered, and leaked guard values can be bypassed.

### Mapping 164: attack 81 → defense 123

Browser-resident session manipulation → Endpoint or workload isolation

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Isolating a compromised browser or endpoint and invalidating sessions reduces further transaction exposure during response.

**Limitations / rationale:** Containment does not eradicate the implant; sensitive work must move to a trusted environment.

### Mapping 165: attack 81 → defense 148

Browser-resident session manipulation → Managed browser extensions

**CORRECT / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Review and remove unapproved or excessive-permission extensions as a specific browser-hardening measure.

**Limitations / rationale:** Adding an arbitrary extension is not protection against a compromised browser, and extensions may be the attack source.

### Mapping 166: attack 82 → defense 27

DNS infrastructure abuse → Operational security monitoring

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** DNS query, response and administration observations can reveal selected anomalous behavior or unauthorized changes.

**Limitations / rationale:** The broad DNS attack category needs a concrete threat; monitoring is not prevention of all DNS failures.

### Mapping 167: attack 82 → defense 149

DNS infrastructure abuse → Threat-specific DNS security

**CORRECT / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Specify DNSSEC validation, encrypted transport, registrar security or resilience according to the actual threat scenario.

**Limitations / rationale:** Secure DNS is not one universal control; encryption and data authentication solve different problems.

### Mapping 168: attack 83 → defense 70

Phishing → Multi-factor authentication (MFA)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Strong MFA can reduce takeover from a phished password alone.

**Limitations / rationale:** Some factors can be phished, and phishing can pursue payments or malware rather than authentication.

### Mapping 169: attack 83 → defense 150

Phishing → Email threat filtering

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Mail inspection can quarantine supported malicious links, attachments and sender patterns before delivery.

**Limitations / rationale:** New lures and compromised legitimate senders can pass; false positives require managed handling.

### Mapping 170: attack 83 → defense 151

Phishing → User security training

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Relevant training improves recognition, verification and reporting of phishing requests.

**Limitations / rationale:** It is a complementary human layer, not proof that every attack will be recognized.

### Mapping 171: attack 84 → defense 152

SMS phishing → Independent navigation instead of unexpected text links

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Independent navigation to a known service avoids trusting an unexpected SMS destination.

**Limitations / rationale:** The trusted device or service can still be compromised; users need an accessible verification route.

### Mapping 172: attack 84 → defense 153

SMS phishing → Mobile endpoint security tools

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Supported mobile protections can flag some malicious destinations, apps or unsafe device conditions.

**Limitations / rationale:** They cannot establish the truth of every text request and platform sandboxing limits visibility.

### Mapping 173: attack 84 → defense 154

SMS phishing → SMS and text-message filtering

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Text filtering reduces delivery of recognized spam or malicious-message patterns.

**Limitations / rationale:** Spoofed senders and novel wording can bypass filtering; a delivered message is not verified as safe.

### Mapping 174: attack 85 → defense 155

Evil-twin wireless network → Certificate authority trust and identity validation

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Validating the expected enterprise authentication-server identity against appropriate CA trust resists a false network server.

**Limitations / rationale:** A certificate from any trusted issuer is not sufficient without the expected identity; user overrides can defeat validation.

### Mapping 175: attack 85 → defense 156

Evil-twin wireless network → Rogue wireless infrastructure detection

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Wireless observations and inventory checks can identify infrastructure imitating a trusted network.

**Limitations / rationale:** Detection can occur after association and does not itself guarantee credential protection.

### Mapping 176: attack 86 → defense 145

KARMA-style wireless impersonation → Virtual private network (VPN)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A trusted VPN can protect subsequent traffic over an untrusted network segment.

**Limitations / rationale:** It does not prevent unsafe automatic association, authenticate the AP or protect credentials typed into a fake pre-tunnel page.

### Mapping 177: attack 86 → defense 157

KARMA-style wireless impersonation → Disable unsafe automatic network association

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Disabling unsafe automatic association and removing obsolete profiles reduces opportunistic response-based network impersonation.

**Limitations / rationale:** A user can still manually join a false network; strong configured network authentication remains important.

### Mapping 178: attack 87 → defense 158

Cross-site scripting → Context-aware output encoding

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Context-correct encoding or safe text APIs prevent untrusted plain text becoming executable browser syntax.

**Limitations / rationale:** The encoder must match the output context; unsafe script or URL interpolation may need redesign instead.

### Mapping 179: attack 87 → defense 159

Cross-site scripting → Content Security Policy (CSP)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A restrictive correctly deployed CSP can reduce selected script-execution paths as defense in depth.

**Limitations / rationale:** Permissive policy or trusted-script abuse can bypass protection; unsafe output handling still needs repair.

### Mapping 180: attack 87 → defense 160

Cross-site scripting → HTML and content sanitization

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A maintained HTML sanitizer can enforce an intentionally allowed rich-markup subset.

**Limitations / rationale:** Configuration, parser differences and post-sanitization mutation can reintroduce unsafe behavior.

### Mapping 181: attack 88 → defense 161

Path traversal → Path canonicalization and confinement checks

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Resolve paths using platform-aware rules and verify confinement through safe APIs and appropriate authorization.

**Limitations / rationale:** Naive prefix tests, symbolic links and check/use races can defeat incomplete normalization-based designs.

### Mapping 182: attack 88 → defense 162

Path traversal → Chroot filesystem confinement

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A correctly configured reduced-privilege chroot confines ordinary path resolution to a chosen tree.

**Limitations / rationale:** It is not a complete sandbox; privileged operations and unsafe descriptors can undermine it.

### Mapping 183: attack 89 → defense 163

Forged Wi-Fi deauthentication → Protected Management Frames (802.11w)

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Enforced Protected Management Frames authenticate specified robust management traffic against forgery.

**Limitations / rationale:** They do not cover all wireless frames or prevent radio jamming; negotiation and compatibility need checking.

### Mapping 184: attack 89 → defense 164

Forged Wi-Fi deauthentication → Intrusion detection systems (IDS)

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Wireless intrusion sensors can alert on suspicious disconnect patterns for investigation.

**Limitations / rationale:** An IDS does not automatically block frames, and interference or legitimate events can resemble an attack.

### Mapping 185: attack 90 → defense 10

Packet capture and sniffing → Authenticated data encryption

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate authenticated encryption protects payload contents from unauthorized passive observers on the covered path.

**Limitations / rationale:** Metadata may remain visible and compromised endpoints see plaintext; capture itself may be authorized and legitimate.

### Mapping 186: attack 90 → defense 165

Packet capture and sniffing → Virtual local area networks (VLANs)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Correctly enforced VLAN boundaries reduce some local access to unrelated traffic.

**Limitations / rationale:** VLANs do not encrypt packets or replace authorization, and permitted routing or misconfiguration can expose traffic.

### Mapping 187: attack 91 → defense 127

Identity impersonation → Role-based access control (RBAC)

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Role-scoped permissions limit what an impersonated or compromised identity can access.

**Limitations / rationale:** RBAC does not prove the identity is genuine; broad or stale role membership can still enable misuse.

### Mapping 188: attack 91 → defense 166

Identity impersonation → Identity proofing and verification

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Risk-appropriate identity verification can reject a false claimant before sensitive enrollment or recovery.

**Limitations / rationale:** Verified identity does not automatically authorize the requested action; evidence and fallback quality matter.

### Mapping 189: attack 91 → defense 167

Identity impersonation → Role-appropriate security instruction

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Training helps staff challenge claimed authority and use approved verification routes.

**Limitations / rationale:** Awareness alone does not authenticate a person or enforce resource permissions.

### Mapping 190: attack 92 → defense 135

Baiting with removable media → Security scanning

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Controlled scanning can detect supported malicious files before an approved media transfer.

**Limitations / rationale:** Unknown malware and USB devices emulating keyboards may not be detected by file scanning.

### Mapping 191: attack 92 → defense 168

Baiting with removable media → USB device control

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Endpoint device policy can block unapproved removable storage or other supported USB classes.

**Limitations / rationale:** Coverage must match the device class; storage-only rules do not necessarily block malicious peripheral emulation.

### Mapping 192: attack 92 → defense 169

Baiting with removable media → Enforceable security policies

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A workable media policy defines approved devices, inspection and reporting routes.

**Limitations / rationale:** Written instructions alone do not stop a connected device; technical enforcement and usable alternatives matter.

### Mapping 193: attack 93 → defense 170

Tailgating into a controlled area → Access-control vestibules

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** A safe access-control vestibule can require individual passage and verification at the boundary.

**Limitations / rationale:** Emergency egress, accessibility and actual occupancy detection must be assessed.

### Mapping 194: attack 93 → defense 171

Tailgating into a controlled area → Electronic badge access systems

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Individual badge checks support controlled entry and revocation.

**Limitations / rationale:** A reader at one door does not necessarily stop someone following a badge holder through it.

### Mapping 195: attack 93 → defense 172

Tailgating into a controlled area → Physical security personnel

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Trained personnel can observe entry and safely challenge unverified accompaniment.

**Limitations / rationale:** Coverage, fatigue, social pressure and emergency conditions can limit effectiveness.

### Mapping 196: attack 94 → defense 28

Typosquatting → Security awareness education

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Education encourages trusted navigation and careful checking of domain names.

**Limitations / rationale:** Users cannot reliably detect every visual similarity or encoded hostname variation.

### Mapping 197: attack 94 → defense 173

Typosquatting → Look-alike domain monitoring

**RETAIN / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Registration and domain monitoring can discover look-alike infrastructure for investigation and response.

**Limitations / rationale:** Similarity does not prove malice and discovery alone does not block an early victim visit.

### Mapping 198: attack 94 → defense 174

Typosquatting → Browser typo and look-alike warnings

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Browser look-alike warnings add a prompt to verify an unusual destination.

**Limitations / rationale:** Heuristics can miss new patterns or be ignored; they are not authoritative domain-ownership verification.

### Mapping 199: attack 95 → defense 175

Hash collision exploitation → Hash-based message authentication code (HMAC)

**CORRECT / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** HMAC supplies shared-key message authentication for a protocol designed to use it.

**Limitations / rationale:** It is not a generic replacement for a collision-sensitive public signature or unkeyed integrity design; do not claim universal collision prevention.

### Mapping 200: attack 95 → defense 176

Hash collision exploitation → Appropriate modern cryptographic algorithms

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Replacing a broken primitive with an appropriate reviewed construction addresses its known collision-security deficiency.

**Limitations / rationale:** A new name or longer digest alone does not establish the complete protocol's security.

### Mapping 201: attack 96 → defense 177

Forced physical entry → Reinforced doors and entry assemblies

**RETAIN / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** An appropriately installed door assembly increases resistance to specified forced-entry attempts.

**Limitations / rationale:** Locks, frames, anchoring and alternate routes matter; life-safety and accessibility requirements must remain intact.

### Mapping 202: attack 96 → defense 178

Forced physical entry → Physical intrusion alarms

**QUALIFY / DETECTION**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Intrusion alarms can notify responders when a physical barrier is forced or opened unexpectedly.

**Limitations / rationale:** Detection may occur after entry and needs timely response; it does not strengthen the barrier itself.

### Mapping 203: attack 97 → defense 10

Wireless network surveying (wardriving) → Authenticated data encryption

**CORRECT / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Authenticated wireless encryption protects content against unauthorized reading even when network surveying is possible.

**Limitations / rationale:** It does not prevent detecting or mapping radio networks; authorized wardriving is not inherently malicious.

### Mapping 204: attack 97 → defense 179

Wireless network surveying (wardriving) → Suppress network-name advertisement

**REMOVE_PROPOSED / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Suppressing some SSID advertisements only changes simple discovery presentation.

**Limitations / rationale:** Management exchanges still reveal network identity; hiding SSID is not meaningful protection from surveying or unauthorized access.

### Mapping 205: attack 98 → defense 167

False or misleading information → Role-appropriate security instruction

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Instruction can teach source assessment, uncertainty and responsible sharing.

**Limitations / rationale:** Training does not directly correct a false claim or establish the facts of a particular event.

### Mapping 206: attack 98 → defense 180

False or misleading information → Evidence-based fact checking

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Examine primary evidence, context and independent corroboration before treating a claim as true.

**Limitations / rationale:** Evidence may remain uncertain; false information alone does not establish intentional deception.

### Mapping 207: attack 98 → defense 181

False or misleading information → Content moderation procedures

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Moderation can reduce circulation of material violating an organization's stated platform policy.

**Limitations / rationale:** Moderation is not a universal truth test and can remove legitimate speech if applied poorly.

### Mapping 208: attack 99 → defense 182

Known-plaintext cryptanalysis → Advanced Encryption Standard (AES)

**QUALIFY / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** AES in an appropriate reviewed construction is designed to tolerate known plaintext rather than relying on secret message formats.

**Limitations / rationale:** The mode, nonce and key use still matter; AES alone is not a complete encryption system.

### Mapping 209: attack 99 → defense 183

Known-plaintext cryptanalysis → Cryptographic key management

**QUALIFY / INDIRECT_SUPPORT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Protected keys and appropriate lifecycles prevent weaknesses outside the cipher from exposing encrypted data.

**Limitations / rationale:** Key management does not repair a cryptanalytic flaw in the chosen construction.

### Mapping 210: attack 100 → defense 184

Ciphertext-only cryptanalysis → Reviewed cryptographic standards and designs

**RETAIN / DIRECT**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Established reviewed constructions avoid dependence on unassessed proprietary ciphertext-obscurity assumptions.

**Limitations / rationale:** Correct implementation, randomness and key use still require verification; metadata leakage is a separate property.

### Mapping 211: attack 100 → defense 185

Ciphertext-only cryptanalysis → Credential and key rotation

**QUALIFY / PARTIAL**. Status: EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED. Original edge remains unchanged.

**Mechanism / applicability:** Appropriate key lifecycle controls can limit exposure after compromise or within a designed cryptoperiod.

**Limitations / rationale:** Rotation does not repair a broken cipher and arbitrary periodic password changes are not a universal defense.
