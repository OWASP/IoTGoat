# No 1: Weak, Guessable, or Hardcoded Passwords.
There are many ways to develop a Weak, Guessable, or Hardcoded Passwords challenge. Each challenge lesson should include:
Explain the vulnerability
Assignments to learn how to exploit the vulnerability
Decribe the possible mitigation scenarios
Examples challenges and their level of difficulty include:

1. Recompile uhttpd and insert a hardcoded backdoor user and password that grants admin rights on the web interface. (Hard)
2. Add a hardcoded encryption key within a network service that uses encryption. (Medium)
3. Configure a  web page that is only accessible via direct browsing that responds with a password value. (Easy)
4. Grant administrative rights if a predefined secret packet header is requested. (Medium/Hard)

For challenge number 3, a basic example is provided below.

- Configure OpenWrt with an easy password for a low privileged user - `iotgoatuser`
- Create an IoTGoat Lua module to call our code
- Configure a webpage that responds with a debug user's hardcoded password double Base64 when directly accessing the endpoint.
- Create a Lua page and use `iotgoathardcodedpassword` as the password then Base64 encode to `aW90Z29hdGhhcmRjb2RlZHBhc3N3b3Jk` and double encode the password to `YVc5MFoyOWhkR2hoY21SamIyUmxaSEJoYzNOM2IzSms=` for the HTTP response

## Creating a user
Issue the following commands to add the iotgoatuser.
```
root@OpenWrt:~# opkg install shadow-useradd
root@OpenWrt:~# useradd iotgoatuser
password for iotgoatuser: (insert iotgoathardcodedpassword)
root@OpenWrt:~# mkdir /home
root@OpenWrt:~# mkdir /home/iotgoatuser
root@OpenWrt:~# chown iotgoatuser /home/iotgoatuser
root@OpenWrt:~# cat /etc/passwd
root:x:0:0:root:/root:/bin/ash
daemon:*:1:1:daemon:/var:/bin/false
ftp:*:55:55:ftp:/home/ftp:/bin/false
network:*:101:101:network:/var:/bin/false
nobody:*:65534:65534:nobody:/var:/bin/false
dnsmasq:x:453:453:dnsmasq:/var/run/dnsmasq:/bin/false
iotgoatuser:x:1000:1000:iotgoatuser:/home/iotgoatuser:/bin/ash
```

After a lower privileged user is created, build a basic web page with the double Base64 encoded password of the "iotgoatuser" user just created. This can be accomplished in several ways, however the following example involves creating an IoTGoat LuCI module with a tab to separate challenges.

## Building a LuCI module

First, ensure Lua is installed. <br>   
`root@OpenWrt:~# opkg install uhttpd-mod-lua`

Next, build a controller for our customized IoTGoat module. <br>
`root@OpenWrt:~# mkdir /usr/lib/lua/luci/view/iotgoat`

Create the IoTGoat controller Lua file using the example below. Ensure the controller file is in the same path used below.  
```
root@OpenWrt:~# cat /usr/lib/lua/luci/controller/iotgoat/iotgoat.lua
module("luci.controller.iotgoat.iotgoat", package.seeall)
local http = require("luci.http")
function index()
    entry({"admin", "iotgoat"}, firstchild(), "IoTGoat", 60).dependent=false  
    entry({"admin", "iotgoat", "supersecret"}, template("iotgoat/secret"), "")
end
```
With the controller file created, a view "template" htm file is needed within the `/usr/lib/lua/luci/view/iotgoat` as seen with the command below. <br>

`root@OpenWrt:~# mkdir /usr/lib/lua/luci/view/iotgoat`

Based on the controller details we provided above (i.e. (template("iotgoat/secret")), the view template file needs to be named `secret.htm` but the URL will end in supersecret. We will create the secrets web page the will call an additional local web page at `/lua/app/s/s.htm` as seen in the example provided below.

```
root@OpenWrt:~# cat /usr/lib/lua/luci/view/iotgoat/secret.htm
<%+header%>                                                          
<h1><%:Hello World%></h1>
Nothing to see here :D
<script type="text/javascript">
var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function() {
    if (xhr.readyState == XMLHttpRequest.DONE) {
        console.log(xhr.responseText);
    }
}
xhr.open('GET', '/lua/app/s/s.htm', true);
xhr.send(null);
</script>                                            
<%+footer%>
```
Create the accompanying htm page with the following double Base64 contents. <br>

```root@OpenWrt:~# cat /www/lua/app/s/s.htm
YVc5MFoyOWhkR2hoY21SamIyUmxaSEJoYzNOM2IzSms=```


For additional details on creating modules, see https://openwrt.org/docs/guide-developer/luci

## Testing

Navigate to the OpenWrt web interface and observe the newly created IoTGoat tab. Three should not be dropdown items beneath. For now, this is by design as we want our secret page to be inaccessible from normal browsing.

![IoTGoat Tab](/images/iotgoattab.png)

Try accessing the supersecret URL directly: https://192.168.1.1/cgi-bin/luci/admin/iotgoat/supersecret. The following image should be displayed.

![IoTGoat Secret Page](/images/iotgoatsecretpage.png)

In plain sight, no values appear to be shown. Although, open developer tools within the browser and observe the network and console tabs. You should be see the following.

![IoTGoat Response](/images/iotgoatsecretresponse.png)

![JavaScript Console](/images/console.png)

Our hardcoded password value is displayed in the response and console. A follow up challenge could leverage these credentials due to a vulnerable network service disclosing usernames. Fortunately, the iotgoatuser  is lower privileged and restricted to perform certain functions.

## Mitigation
To mitigate this vulnerability, the following could be done:
- Treat all web pages as public facing
-  Remove exposed web pages used for debugging purposes such as the s.htm file.
- Do not rely on obscurity for encoding secrets or password values within applications
- Ensure secrets are logged to the console
- Ensure user passwords are complex

and more...
