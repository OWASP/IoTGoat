# IoTGoat
 IoT Goat will be a deliberately insecure firmware based on OpenWrt. The project’s goal is to teach users about the most common vulnerabilities typically found in IoT devices. The vulnerabilities will be based on the top 10 vulnerabilities as documented by OWASP: https://www.owasp.org/index.php/OWASP_Internet_of_Things_Project

<h3> Getting started </h3>

To get started with developing IoTGoat challenges, download the following release of [OpenWrt.
](https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-ext4.img.gz)
or run the following commands to download, decompress, and convert the virtual machine image to a vmdk format for VMWare.

1)
```
$ wget https://downloads.openwrt.org/releases/18.06.2/targets/x86/generic/openwrt-18.06.2-x86-generic-combined-ext4.img.gz
$ gunzip openwrt-18.06.2-x86-generic-combined-ext4.img.gz
$ qemu-img convert -f raw -O vmdk openwrt-18.06.2-x86-generic-combined-ext4.img lede1806.vmdk
```
###### Note: Other virtualization methods are available. Please see https://openwrt.org/docs/guide-user/virtualization/start
2) Once the image is converted to a vmdk image, open VMWare and "Create a custom virtual machine"

3) Select "Other Linux 2.6.x kernel” or “Other Linux 3.x kernel" as the guest operating system an E1000 NIC adapter which may need to be changed via the ".vmx" file as demonstrated below.  

4) Within the virtual machine settings, select “Hard Disk” and change the bus type to use an “IDE" virtual disk (not SCSI).

![IDE](/images/IDE.png)

5) Modify the Virtual Machine’s “.vmx” file to use the E1000 NIC by inserting “ethernetN.virtualDev = "e1000””

![vmxiotgoat](/images/vmx.png)

###### Note: In OS X, you will need to right click the VMWare image and select “Show in Finder” then right click and select “Show Package Contents” where you should now be able to see the “.vmx” file.

6) Save the file

7) Open VMWare and create another network adapter for internet access (one adapter is fo the LAN, and one adapter is for WAN communication)
Ensure your Network adapter settings are set to NAT

![Network Adapters](/images/networkadapter.png)

8) Boot up the Virtual Machine (may need to press enter) and and verify an IP address is pulled
###### Note: In OS X, VMware fusion should prompt your password for network connections.

![ifconfig](/images/ifconfig.png)


To test network access, start up another VM in the same NAT network adapter configuration such as a Kali Linux machine.
Execute the following command on the Kali Linux machine or another virtual machine with a NAT configured adapter
```
# ifconfig eth0 add 192.168.1.101 broadcast 192.168.1.255
```
Ping the OpenWrt virtual machine
```
# ping 192.168.1.1 (should reply)
```
Open a web browser to access the OpenWRT Luci management interface at 192.168.1.1

Access the SSH interface of the OpenWrt virtual machine via the following command (By default it is not password protected).
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
