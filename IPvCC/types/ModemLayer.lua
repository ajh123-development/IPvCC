local Class = require "IPvCC.class"
local ModemInterface = require "IPvCC.types.ModemInterface"
local is_instance = require "IPvCC.core".is_instance
local MediaLayer = require "IPvCC.types.MediaLayer"

ModemLayer = Class:new(MediaLayer)

function ModemLayer:__new(o)
    o = o or {}
    setmetatable(o, ModemLayer)
    self.interface = nil
    self.type = "Modem"
    return o
end

function ModemLayer:transmit(packet)
    if is_instance(packet, Packet) then
        local to = packet.to
        local data = packet.data
        assert(type(to) == "number", "Packet.to must be a number")
        assert(type(data) == "table", "Packet.data must be a table")
        packet.from = os.getComputerID()
        if is_instance(self.interface, ModemInterface) then
            self.interface.modem.transmit(
                1,
                2,
                packet:toTable()
            )
            self.interface.tx = self.interface.tx + 1
            self.interface:update()
        end
    end
end

function ModemLayer:recive()
    local _, side, _, _, packet, _
    if is_instance(self.interface, ModemInterface) then
        _, side, _, _, packet, _ = os.pullEvent("modem_message")
        if not self.interface.side == side then
            return
        end
    else
        return
    end

    local sendPort = packet["sendPort"]
    local replyPort = packet["replyPort"]
    local from = packet["from"]
    local to = packet["to"]
    local data = packet["data"]

    local function decode()
        assert(type(from) == "number", "Received Packet.from must be a number")
        assert(type(to) == "number", "Received Packet.to must be a number")
        assert(type(data) == "table", "Received Packet.data must be a table")
        local packet = Packet:new()
        packet:fromTable(sendPort,replyPort,to,from,data)

        os.queueEvent("IPvCC|packet", packet)
        self.interface.rx = self.interface.rx + 1
        self.interface:update()
    end
    if not pcall(decode) then
        self.interface.errors = self.interface.errors + 1
    end
end

return ModemLayer