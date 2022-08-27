package.path = "/?/init.lua;/?.lua;" .. package.path
IPvCC = require("IPvCC")

IPvCC.checkInterfaces()

for k, _ in pairs(IPvCC.interfaces) do
    IPvCC.interfaces[k]:open(2)
end



local function recive()
    while true do
        IPvCC.interfaces["back"].layer:recive()
    end
end

local function check()
    while true do
        local _, packet = os.pullEvent("IPvCC|packet")
        if packet.to == os.getComputerID() then
            print(packet.from, textutils.serialiseJSON(packet.data))
        end
    end
end

parallel.waitForAll(recive, check)
for k, _ in pairs(IPvCC.interfaces) do
    IPvCC.interfaces[k]:close(2)
end