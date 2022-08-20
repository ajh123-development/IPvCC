IPvCC = require "IPvCC"
IPvCC.checkInterfaces()

IPvCC.interfaces["back"]:open(10)

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
IPvCC.interfaces["back"]:close(10)