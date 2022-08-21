local Class = require "IPvCC.class"
local Core = require "IPvCC.core"

local Packet = {}

Packet.Packet = Class:new()
function Packet:__new(sendPort, replyPort, to, data)
    if not Core.is_instance(data, Packet.Packable) then
        error("data must be Packable")
    end
    assert(type(sendPort) == "number", "sendPort must be a number")
    assert(type(replyPort) == "number", "replyPort must be a number")
    assert(type(to) == "number", "to must be a number")
    self.to = to
    self.from = os.getComputerID()
    self.data = data
    self.sendPort = sendPort
    self.replyPort = replyPort
end

function Packet.Packet:fromTable(sendPort, replyPort, to, from, data)
    if not Core.is_instance(data, Packet.Packable) then
        error("data must be Packable")
    end
    assert(type(sendPort) == "number", "sendPort must be a number")
    assert(type(replyPort) == "number", "replyPort must be a number")
    assert(type(to) == "number", "to must be a number")
    assert(type(from) == "number", "from must be a number")
    self.to=to
    self.from=from
    self.data=data
    self.sendPort = sendPort
    self.replyPort = replyPort
end

function Packet.Packet:toTable()
    return {
        to=self.to,
        from=self.from,
        data=self.data,
        sendPort=self.sendPort,
        replyPort=self.replyPort
    }
end

local packets = {}
Packet.Packable = Class:new()
function Packet.Packable:__new(id, data, headers)
    if id == "table" then
        error("id cannot be \"table\"")
    end
    assert(type(id) == "string", "id must be a string")
    assert(type(headers) == "table", "headers must be a table")
    if not Core.is_instance(data, Packet.Packable) then
        assert(type(data) == "table", "data must be a table or Packable")
    end
    self.data = data
    self.id = id
    self.headers = headers
    packets[id] = self.new_empty
end

function Packet.Packable:toTable()
    if Core.is_instance(self.data, Packet.Packable) then
        return {
            type=self.id,
            headers=self.headers,
            data=self.data:toTable()
        }
    end
    return {
        type=self.id,
        headers=self.headers,
        data={
            type="table",
            data=self.data
        }
    }
end

function Packet.packableFromTable(data)
    assert(type(data) == "table", "data must be a table")
    if data["data"]["type"] == "table" then
        local packet = Packet.Packable:new_empty()
        packet.id = data["type"]
        packet.headers = data["headers"]
        packet.data = data["data"]["data"]
        return packet
    else
        local constructor = packets[data["type"]]
        if constructor == nil then return nil end
        local packet = constructor()
        packet.id = data["type"]
        packet.headers = data["headers"]
        packet.data = data["data"]
    end
end

return Packet