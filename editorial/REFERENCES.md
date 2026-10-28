# Technical cross-check references

Consulted 2026-10-27. These primary sources were used to check important scope and
terminology distinctions, not copied to manufacture hundreds of near-identical
entries. The candidate prose is original editorial writing. A reference here
does not mean its publisher has approved this game or reviewed every record.
Some references provide broader context; the itemized mapping text states the
actual narrower claim. Independent SME and owner acceptance remain outstanding.

- [NIST SP 800-63B-4](https://pages.nist.gov/800-63-4/sp800-63b.html): password,
  authenticator, replay and authentication boundaries; not a claim that all game
  environments have identical compliance obligations.
- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html):
  online guessing, account controls and authentication design.
- [OWASP Password Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html):
  salts, work factors and password verifiers rather than fast generic hashing.
- [MITRE Pass the Hash](https://attack.mitre.org/techniques/T1550/002/): stolen
  authentication material versus plaintext recovery; Kerberos is not a blanket
  cure for credential abuse.
- [MITRE Reflection Amplification](https://attack.mitre.org/techniques/T1498/002/)
  and [BCP 38 / RFC 2827](https://www.rfc-editor.org/info/rfc2827/): spoofed-source
  reflection and source-network filtering.
- [OWASP Cryptographic Storage](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html):
  authenticated encryption and construction/implementation distinctions.
- [NIST post-quantum standards announcement](https://www.nist.gov/news-events/news/2024/08/nist-releases-first-3-finalized-post-quantum-encryption-standards):
  standardized migration rather than claims that current quantum systems break
  all cryptography.
- [OWASP TLS Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Transport_Layer_Security_Cheat_Sheet.html):
  transport security, peer identity and endpoint limitations.
- [OWASP OS Command Injection Defense](https://cheatsheetseries.owasp.org/cheatsheets/OS_Command_Injection_Defense_Cheat_Sheet.html):
  avoid shells, separate arguments, and do not confuse interpreter contexts.
- [OWASP SQL Injection Prevention](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html):
  query parameters versus supplementary filters.
- [OWASP XSS Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross_Site_Scripting_Prevention_Cheat_Sheet.html):
  context-aware encoding, sanitization and defense in depth.
- [OWASP CSRF Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html):
  request-bound values and SameSite limitations.
- [OWASP Session Management](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html):
  separate cookie attributes, token lifetimes and stolen-session concerns.
- [AWS S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html):
  correcting public permissions is different from encryption at rest.
- [NIST SP 800-82 Rev. 3](https://csrc.nist.gov/pubs/sp/800/82/r3/final): OT risk
  includes reliability, performance and safety constraints.
- [Kubernetes Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
  and [Pod Security Admission](https://kubernetes.io/docs/concepts/security/pod-security-admission/):
  supported workload security controls rather than the removed PodSecurityPolicy
  API.
- [MITRE Browser Session Hijacking](https://attack.mitre.org/techniques/T1185/):
  browser-resident compromise is different from network-path interception.

Two attempted retrievals were unavailable (CISA ransomware guide returned 403;
the RFC 8446 page returned 429). They are not represented as successfully read
evidence here. Recovery and TLS text still requires owner/SME review along with
the entire candidate package.
