local computer = require("computer")
local shell = require("shell")
local fs = require("filesystem")
local serialization = require("serialization")

local function memReport()
    print("Free Memory: "..computer.freeMemory())
end

local function globalReport()
    local globalsPath = "/usr/test/png-view/oldGlobals"
    local globalsFile = fs.open(globalsPath, "r")
    if (globalsFile) then
        local oldGlobals = serialization.unserialize(globalsFile:read(10000))
        for k,v in pairs(_G) do
            if (oldGlobals[k] ~= tostring(v)) then
                print("New global key", k, "value", v)
            end
        end
        globalsFile:close()
    end
    local globalString = {}
    for k,v in pairs(_G) do
        globalString[k] = tostring(v)
    end
    globalsFile = fs.open(globalsPath, "w")
    globalsFile:write(serialization.serialize(globalString))
end

shell.execute("png-view")
memReport()
globalReport()