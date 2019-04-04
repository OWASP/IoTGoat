<h1> Build Environment</h1>

Multiple methods exist to get started with developing challenges - building custom firmware or leveraging a virtual machine. Depending on the type of challenge, a full custom firmware may be needed. This page will assist with getting your build environment setup for developing, testing, and submitting your developed challenges.

<h2> Building Custom Firmware </h2>

It is recommended to have the following workstation prerequisites for your build environment:

- 10GB free hard drive space
- A supported [GNU/Linux and Unix like distribution](GNU/Linux and Unix like distribution) with known prerequisites installed (Ubuntu will be used for demonstrations)
- Clone the IoTGoat GitHub repository with the OpenWrt 18.06.2 version forked <br>
`# git clone https://github.com/scriptingxss/IoTGoat.git`

Enter the OperWrt fork folder <br>
`# cd IoTGoat/OpenWrt/`
</br>
Run the following commands to obtain package definitions and install symlinks for packages: <br>
`# ./scripts/feeds update -a`
<br>
`# ./scripts/feeds install -a`
<br>
`# make menuconfig`

At this time, hardware discussions are in progress for future IoTGoat versions. For now,  proceed with building a Raspberry Pi firmware image by selecting from the following options:

```Model | SoC | Target | Subtarget
------------ | -------------
A | BCM2835 @ 700MHz | BCM27XX | BCM2708
B | BCM2835 @ 700MHz | BCM27XX | BCM2708
CM | BCM2835 @ 700MHz | BCM27XX | BCM2708
A+ | BCM2835 @ 700MHz | BCM27XX | BCM2708
B+ | BCM2835 @ 700MHz | BCM27XX | BCM2708
Zero | BCM2835 @ 1GHz | BCM27XX | BCM2708
2B |  	BCM2836 @ 900MHz | BCM27XX | BCM2709
3B |  	BCM2837 @ 1.2GHz | BCM27XX | BCM2710
```
In this case, we have chosen Target System (Broadcom BCM27xx) and Subtarget BCM2708

![Target Settings](/images/owrttarget.png)
You may also wish to select the LuCi package in order to install the web interface.
Make modifications according to the target challenge such as:
Base system > busybox > Networking Utilities > ftpd settings
![FTP](/images/ftpd.png)

When ready, select "Save", "ok" then exit.

To build your custom firmware, run the following command:
###### Note: Building firmware can take several hours depending on your internet connection.
<br>

`# make -j1 V=s`

After the firmware is successfully built, the image will be located in: <br>
`bin/targets/brcm2708/bcrm2708/`
</br>

There will be multiple firmware images stored in this directory depending on the settings in "Target Images". There should be a "openwrt-brcm2708-bcm2708-rpi-squashfs-factory.img.gz" firmware build.

<h3> Verifying Compiled Changes </h3>
To begin verifying changes, decompress the squashfs image by issuing the following gunzip command: <br>
`# gunzip -d openwrt-brcm2708-bcm2708-rpi-squashfs-factory.img.gz`
</br>

Next, running binwalk on the firmware file. <br>


```
# binwalk openwrt-brcm2708-bcm2708-rpi-squashfs-factory.img

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
4253711       0x40E80F        Copyright string: “copyright does *not* cover user programs that use kernel”
4253946       0x40E8FA        Copyright string: “copyrighted by the Free Software”
4254058       0x40E96A        Copyright string: “copyrighted by me and others who actually wrote it.”
4254443       0x40EAEB        Copyright string: “Copyright (C) 1989, 1991 Free Software Foundation, Inc.”
4256293       0x40F225        Copyright string: “copyright the software, and”
```
</br>
Extract the filesystem contents, and check if your custom configurations were successfully built into the firmware using binwalk. <br>

```
# binwalk -e openwrt-brcm2708-bcm2708-rpi-squashfs-factory.img

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
4253711       0x40E80F        Copyright string: “copyright does *not* cover user programs that use kernel”
4253946       0x40E8FA        Copyright string: “copyrighted by the Free Software”
4254058       0x40E96A        Copyright string: “copyrighted by me and others who actually wrote it.”
4254443       0x40EAEB        Copyright string: “Copyright (C) 1989, 1991 Free Software Foundation, Inc.”

```
Extracted filesystem contents will be titled with the following filename `_openwrt-brcm2708-bcm2708-rpi-squashfs-factory.img.extracted`. Package modifications were made to include clear-text vulnerable protocols such as FTP and Telnet into this example firmware build. These package binaries will be found in the following extracted filesystem location:

```
# ls bin/targets/brcm2708/bcm2708/_openwrt-brcm2708-bcm2708-rpi-squashfs-factory.img.extracted/squashfs-root/usr/sbin
addpart  dnsmasq    ftpd           ip6tables-save     mkfs.ext2     odhcp6c          telnetd
adduser  dropbear   fw_printenv        iptables         mkfs.ext3     odhcpd          uhttpd
brctl     e2fsck     fw_setenv           iptables-restore  mkfs.ext4     odhcpd-update  wpad
chroot     fsck.ext2  hostapd           iptables-save     mkfs.f2fs     opkg-key       wpa_supplicant
crond     fsck.ext3  ip6tables           iw         ntpd           partx          xtables-legacy-multi
delpart  fsck.ext4  ip6tables-restore  mke2fs         ntpd-hotplug  pppd
```
Further validation may be required for dynamic testing oriented challenges. Ensure to leverage emulation where possible using firmadyne, and similar qemu like tools.

For guidance on installing the image to an SD card in order to boot a Raspberry Pi, see:
**https://www.raspberrypi.org/documentation/installation/installing-images/**

<h2> Virtual Machine Method </h2>

To get started with developing IoTGoat challenges inside a virtual machine, download the following release of [OpenWrt.
](https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-ext4.img.gz)
Alternatively, run the following commands to download, decompress, and convert the virtual machine image to a vmdk format for VMWare.


```
$ wget https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-ext4.img.gz
$ gunzip openwrt-18.06.2-x86-generic-combined-ext4.img.gz
$ qemu-img convert -f raw -O vmdk openwrt-18.06.2-x86-generic-combined-ext4.img lede1806.vmdk
```
###### Note: Other virtualization methods are available. Please see https://openwrt.org/docs/guide-user/virtualization/start

Once the image is converted to a vmdk image, open VMWare and "Create a custom virtual machine"

Select "Other Linux 2.6.x kernel” or “Other Linux 3.x kernel" as the guest operating system an E1000 NIC adapter which may need to be changed via the ".vmx" file as demonstrated below.  

Within the virtual machine settings, select “Hard Disk” and change the bus type to use an “IDE" virtual disk (not SCSI).

![IDE](/images/IDE.png)

Modify the Virtual Machine’s “.vmx” file to use the E1000 NIC by inserting “ethernetN.virtualDev = "e1000””

![vmxiotgoat](/images/vmx.png)

###### Note: In OS X, you will need to right click the VMWare image and select “Show in Finder” then right click and select “Show Package Contents” where you should now be able to see the “.vmx” file.

Save the file

Open VMWare and create another network adapter for internet access (one adapter is fo the LAN, and one adapter is for WAN communication)
Ensure your Network adapter settings are set to NAT

![Network Adapters](/images/networkadapter.png)

Boot the Virtual Machine (may need to press enter) and verify an IP address is pulled
###### Note: In OS X, VMware fusion should prompt your password for network connections.

![ifconfig](/images/ifconfig.png)

### Verifying OpenWrt Virtual Machine Access

Test network access to interface with OpenWrt, start another virtual machine in the same NAT network adapter configuration as the OpenWrt VM such as a Kali Linux machine.
Execute the following command on the Kali Linux machine or another virtual machine with a NAT configured adapter to assign an IP addreess within the 192.168.1.0/24 range.
###### Note: You may need to disconnect your primary internet connection interface if your gateway router is already 192.168.1.1. Sometimes disconnecting and reconnecting works.

```
# ifconfig eth0 add 192.168.1.101 broadcast 192.168.1.255
```
You should now see a virtual interface named eth0:0. <br>
```
eth0:0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.101  netmask 255.255.255.255  broadcast 192.168.1.255
        inet6 fd82:93cd:b7b::218  prefixlen 128  scopeid 0x0<global>
        inet6 fd82:93cd:b7b:0:20c:29ff:fe4c:8397  prefixlen 64  scopeid 0x0<global>
        inet6 fd82:93cd:b7b:4:20c:29ff:fe4c:8397  prefixlen 64  scopeid 0x0<global>
        inet6 fd82:93cd:b7b:0:c984:fb5a:37d5:6bba  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::20c:29ff:fe4c:8397  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:4c:83:97  txqueuelen 1000  (Ethernet)
        RX packets 110  bytes 11499 (11.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 62  bytes 5907 (5.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Ping the OpenWrt virtual machine
```
# ping 192.168.1.1 -c 3
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.444 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.601 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.512 ms

--- 192.168.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 45ms
rtt min/avg/max/mdev = 0.444/0.519/0.601/0.064 ms
```
Open a web browser to access the OpenWRT Luci management interface at 192.168.1.1

Access the SSH interface of the OpenWrt virtual machine via the following command (By default it is not password protected). <br>

```
# ssh root@192.168.1.1

BusyBox v1.28.4 () built-in shell (ash)
  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 18.06.2, r7676-cddd7b4c77
 -----------------------------------------------------
```

Begin working on [challenges](/challenges/challenges.md)

<h2> Submitting Challenges For Review (GSoC Students) </h2>
Whether your developed challenge was built into a custom firmware, or using a virtualized method, step by step instructions are required to merge challenges into the core IoTGoat firmware release. To manage changes, fill out the following details  in the [IoTGoat Challenge Submission Form](https://forms.gle/nZDJ4eeUfpNUKbVn9) and notify the project leaders by email or submitting a pull request:

- Describe the challenge and its objective(s).
- What is the challenge level of difficulty - Easy, Medium, or Hard
- Does the challenge require a custom firmware build?
- Explain step by step instructions for changes submitted. Include build steps, configuration changes, dependencies required, etc.
- Explain the step-by-step solution(s) for solving the challenge.
- Upload custom firmware build(s) or VMWare snapshot(s) for review.
- Include addition details not captured in the above questions.    

If you are not a GSoC student, submit a pull request and/or email project leaders.

See [Examples][05341ce4] for additional details.

  [05341ce4]: https://github.com/scriptingxss/IoTGoat/tree/master/Examples "Examples"
