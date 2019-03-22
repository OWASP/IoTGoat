# Example
No 1: Weak, Guessable, or Hardcoded Passwords.

1. Recompile uhttpd and insert a hardcoded backdoor user and password that grants admin rights on the web interface.
2. Add a hardcoded encryption key within a network service that uses encryption.
3. Configure a  web page that is only accessible via direct browsing that responds with a password value.
4. Grant administrative rights if a predefined secret packet header is requested.

A basic example for number 3 above is below.

- Configure OpenWrt with an easy password for a low privliged user
- Configure a webpage with debug base64 hardcoded creds.. can do something with lua .. use iotgoathardcodedpassword (aW90Z29hdGhhcmRjb2RlZHBhc3N3b3Jk and double encoded - YVc5MFoyOWhkR2hoY21SamIyUmxaSEJoYzNOM2IzSms=)

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

After a lower privliged user is created, create a basic web page with the double base64 encoded password of the "iotgoatuser"
```
root@OpenWrt:~# opkg install uhttpd-mod-lua
root@OpenWrt:~# uci set uhttpd.main.lua_prefix=/lua
root@OpenWrt:~# uci set uhttpd.main.lua_handler=/www/supersecret.lua
root@OpenWrt:~# cat /www/supersecret.lua
function handle_request(env)
        uhttpd.send("Status: 200 OK\r\n")
        uhttpd.send("Content-Type: text/plain\r\n\r\n")
        uhttpd.send("YVc5MFoyOWhkR2hoY21SamIyUmxaSEJoYzNOM2IzSms=\n")
end
root@OpenWrt:~# /etc/init.d/uhttpd restart
root@OpenWrt:~# wget -qO- http://127.0.0.1/lua/
YVc5MFoyOWhkR2hoY21SamIyUmxaSEJoYzNOM2IzSms=
```
