### Challenges

Examples of vulnerabilities included in IoTGoat consist of the following.

No 1: Weak, Guessable, or Hardcoded Passwords:

- [x] Hardcoded user credentials compiled into firmware. 

No 2: Insecure Network Services:
- [x] Vulnerable miniupnp configuration allowing unauthorized devices permission to modify network configurations such as firewall rules. This attack can be demonstrated using the [Miranda tool](https://tools.kali.org/information-gathering/miranda)
- [x] Legacy network services listening upon start up. 
- [x] Dnsmasq is vulerable to heap and stack overflows. See Dnsmasq setup instructions.

No 3: Insecure Ecosystem Interfaces:

- [x] A "secret" developer diagnostics page that is not directly accessible and exposes shell access to users. 
- [x] Persistent backdoor daemon configured to run during start up. 
- [x] Multiple cross-site scripting (XSS) vulnerabilities

No 4: Lack of Secure Update Mechanism:
- [x] Insecure package update configuration defaults including CVE-2020-7982.
- [ ] Insecure firmware over the air update system.

No 5: Use of Insecure or Outdated Components:
- [x] Several insecure and outdated software components in use by default such as Dnsmasq 2.7.3.

No 6: Insufficient Privacy Protection:
- [x] PII data captured and stored insecurely. 

No 7: Insecure Data Transfer and Storage:
- [x] Improperly configured encryption settings enabled.

No 8: Lack of Device Management:
- [x] System logs, monitoring, or auditing capabilities enabled.

No 9: Insecure Default Settings:
- [x] Many included in IoTGoat such as missing secure headers to prevent framing as well as CSRF protections on sensitive requests. 

No 10: Lack of Physical Hardening:
Hardware challenges will be introduced in future versions of IoTGoat. 