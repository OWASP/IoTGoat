#!/usr/bin/env python3

diff = open('diff', 'r').read()
diff = diff.replace("> ", "")
diff = diff.replace("< ", "").split('\n')
base = open('firmware-base.config', 'r').read()
base = base.split('\n')
new = list(set(base) - set(diff))
new_base = []
for i in base: # cheap way for preserving order
    for j in new:
        if i==j:
            new_base.append(j)
clean_base = "\n".join(new_base)
if len(base) != len(new_base):
    print("[*] Duplicates found and removed")
    f = open('firmware-base.config', 'w')
    f.write(clean_base)
    f.close()
    print("[+] Cleaned up firmware-base.config")
    print("[*] Exiting")
else:
    print("[+] No duplicates found, Exiting ...")