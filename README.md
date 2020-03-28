<p align="center"><img src="/images/vertical-blue-logo.png" alt="IoTGoat" width="250" height="350" /></p>

# Description

The IoTGoat Project is a deliberately insecure firmware based on [OpenWrt](https://openwrt.org/) and maintained by [OWASP](http://owasp.org/) to educate users how to test for the most common vulnerabilities found in IoT devices. The vulnerability challenges are based on the OWASP IoT Top 10 noted below, as well as "easter eggs" from project contributors. For a list of vulnerability challenges, see the [IoTGoat challenges wiki](https://github.com/scriptingxss/IoTGoat/wiki/IoTGoat-challenges) page. 

| [OWASP IoT Top 10 2018](https://www.owasp.org/images/1/1c/OWASP-IoT-Top-10-2018-final.pdf) | Description |
| :--- | :--- |
| I1 Weak, Guessable, or Hardcoded Passwords | Use of easily bruteforced, publicly available, or unchangeable credentials, including backdoors in firmware or client software that grants unauthorized access to deployed systems. |
| I2 Insecure Network Services | Unneeded or insecure network services running on the device itself, especially those exposed to the internet, that compromise the confidentiality, integrity/authenticity, or availability of information or allow unauthorized remote control. |
| I3 Insecure Ecosystem Interfaces | Insecure web, backend API, cloud, or mobile interfaces in the ecosystem outside of the device that allows compromise of the device or its related components. Common issues include a lack of authentication/authorization, lacking or weak encryption, and a lack of input and output filtering. |
| I4 Lack of Secure Update Mechanism | Lack of ability to securely update the device. This includes lack of firmware validation on device, lack of secure delivery \(un-encrypted in transit\), lack of anti-rollback mechanisms, and lack of notifications of security changes due to updates. |
| I5 Use of Insecure or Outdated Components | Use of deprecated or insecure software components/libraries that could allow the device to be compromised. This includes insecure customization of operating system platforms, and the use of third-party software or hardware components from a compromised supply chain |
| I6 Insufficient Privacy Protection | User’s personal information stored on the device or in the ecosystem that is used insecurely, improperly, or without permission. |
| I7 Insecure Data Transfer and Storage | Lack of encryption or access control of sensitive data anywhere within the ecosystem, including at rest, in transit, or during processing |
| I8 Lack of Device Management | Lack of security support on devices deployed in production, including asset management, update management, secure decommissioning, systems monitoring, and response capabilities. |
| I9 Insecure Default Settings | Devices or systems shipped with insecure default settings or lack the ability to make the system more secure by restricting operators from modifying configurations. |
| I10 Lack of Physical Hardening | Lack of physical hardening measures, allowing potential attackers to gain sensitive information that can help in a future remote attack or take local control of the device. |

## Getting started

Multiple methods exist to get started with hacking IoTGoat. 

1. For those looking to extract the filesystem, analyze configurations and binaries statically, download the latest precompiled firmware release from https://github.com/scriptingxss/IoTGoat/releases. Refer to OWASP's [Firmware Security Testing Methodology](https://github.com/scriptingxss/owasp-fstm/) to help with identifying vulnerabilities. 
   
2. For dynamic web testing and binary runtime analysis, the quickest way to get started is downloading the [latest "IoTGoat-x86.vmdk" (VMware)](https://github.com/scriptingxss/IoTGoat/releases) and create a custom virtual machine using the IoTGoat disk image. Refer to OWASP's [Web Security Testing Guide](https://github.com/OWASP/wstg/tree/master/document) and [ASVS](https://github.com/OWASP/ASVS) projects for additional guidance on identifying web application vulnerabilities

3. Alternaitvely, emulate firmware with opensource tools (e.g. [Firmadyne](https://github.com/firmadyne/firmadyne) and [FAT](https://github.com/attify/firmware-analysis-toolkit)) that leverage QEMU to virtualize IoTGoat locally.

#### Project leaders

* Aaron Guzman (@scriptingxss)
* Fotios Chantzis
* Paulino Calderon

### Contributors

* Parag Mhatre (@paraaagggg)
* Abhinav Mohanty (cyanide284)
* Jason Andress (@jandress)
* @0x48piraj

## License

[The MIT License (MIT)](./LICENSE.md)