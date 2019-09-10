module("luci.controller.iotgoat.iotgoat", package.seeall)
local http = require("luci.http")
function index()
    entry({"admin", "iotgoat"}, firstchild(), "IoTGoat", 60).dependent=false
    entry({"admin", "iotgoat", "cmdinject"}, template("iotgoat/cmd"), "", 1)
    entry({"admin", "iotgoat", "cam"}, template("iotgoat/camera"), "Camera", 2)
    entry({"admin", "iotgoat", "door"}, template("iotgoat/door"), "Doorlock", 3)
    entry({"admin", "iotgoat", "webcmd"}, call("webcmd"))
end

function webcmd()
    local cmd = http.formvalue("cmd")
    if cmd then
        local fp = io.popen(tostring(cmd).." 2>&1")
        local result =  fp:read("*a")
        fp:close()
        result = result:gsub("<", "&lt;")
        http.write(tostring(result))
    else
        http.write_json(http.formvalue())
    end
end
