Class = {}

function Class:new(super)
    local class, metatable, properties = {}, {}, {}
    class.metatable = metatable
    class.properties = properties

    function metatable:__index(key)
        local prop = properties[key]
        if prop then
            return prop.get(self)
        elseif class[key] ~= nil then
            return class[key]
        elseif super then
            return super.metatable.__index(self, key)
        else
            return nil
        end
    end

    function metatable:__newindex(key, value)
        local prop = properties[key]
        if prop then
            return prop.set(self, value)
        elseif super then
            return super.metatable.__newindex(self, key, value)
        else
            rawset(self, key, value)
        end
    end

    function class:new(...)
        local obj = setmetatable({}, self.metatable)
        if obj.__new then
            obj:__new(...)
        end
        return obj
    end

    return class
end

local IPvCC = {interfaces={}}


function IPvCC.checkInterfaces()
    for _, side in pairs(rs.getSides()) do
        if peripheral.getType(side) == "modem" then
           IPvCC.interfaces[side] = ModemInterface:new(side)
        end
    end
end

function IPvCC.deleteInterfaceFiles()
    for _, side in pairs(rs.getSides()) do
        if peripheral.getType(side) == "modem" then
           local statsPath = "/sys/class/net/"..side.."/"
           fs.delete(statsPath.."/stats")
        end
    end
end



local function is_instance(o, class)
    while o do
        o = o.metatable
        if class.metatable == o then return true end
    end
    return false
end



Interface = Class:new()
IPvCC["Interface"] = Interface
function Interface:__new()
    self.layer = nil
    self.infoString = ""
    self.tx = 0
    self.rx = 0
end

function Interface:open(port) end
function Interface:close(port) end
function Interface:update() end


ModemInterface = Class:new(Interface)
IPvCC["ModemInterface"] = ModemInterface
function ModemInterface:__new(side)
    self.modem = peripheral.wrap(side)
    self.layer = ModemLayer:new()
    self.layer.interface = self
    self.side = side
    self.tx = 0
    self.rx = 0

    local statsPath = "/sys/class/net/"..self.side
    if fs.exists(statsPath.."/stats") then
        local h = fs.open(statsPath.."/stats", "r")
        local stats = textutils.unserialiseJSON(h.readAll())
        h.close()
        if stats ~= nil then
            self.tx = stats.tx
            self.rx = stats.rx
        end
    end

    self:update()
end

function ModemInterface:update()
    self.infoString = [[

        id ]]..os.getComputerID()..[[

        RX packets:]]..self.rx..[[      
        TX packets:]]..self.tx..[[   
        ]]

    local statsPath = "/sys/class/net/"..self.side
    fs.makeDir(statsPath)
    local h = fs.open(statsPath.."/address", "w")
    h.write(os.getComputerID())
    h.close()
    h = fs.open(statsPath.."/stats", "w")
    h.write(textutils.serialiseJSON({rx=self.rx, tx=self.tx}))
    h.close()
end

function ModemInterface:open(port)
    self.modem.open(port)
end
function ModemInterface:close(port)
    self.modem.close(port)
end


Packet = Class:new()
IPvCC["Packet"] = Packet
function Packet:__new(sendPort, replyPort, to, data)
    self.to = to
    self.from = os.getComputerID()
    self.data = data
    self.sendPort = sendPort
    self.replyPort = replyPort
end

function Packet:fromTable(sendPort, replyPort, to, from, data)
    self.to=to
    self.from=from
    self.data=data
    self.sendPort = sendPort
    self.replyPort = replyPort
end


function Packet:toTable()
    return {
        to=self.to,
        from=self.from,
        data=self.data,
        sendPort=self.sendPort,
        replyPort=self.replyPort
    }
end


--[[
MediaLayers are used for 
1. Transmission and reception of raw bit streams 
over a physical medium
2. Transmission of data frames between two nodes 
connected by a physical layer
3. Structuring and managing a multi-node network, 
including addressing, routing and traffic control

**See also:**
https://en.wikipedia.org/wiki/OSI_model#Layer_architecture
]]--
MediaLayer = Class:new()
IPvCC["MediaLayer"] = MediaLayer
function MediaLayer:__new()
    self.type = nil
end


--[[
Transmits a Packet across a medium,

**Arguments**

packet: The Packet that will be sent.

**Throws**

"Not implemented"
]]--
function MediaLayer:transmit(packet)
    error("Not implemented")
end


--[[
Recivies a Packet from a medium,

**Returns**

packet: A Packet that was sent to us.

**Throws**

"Not implemented"
]]--
function MediaLayer:recive()
    error("Not implemented")
end


ModemLayer = Class:new(MediaLayer)
IPvCC["ModemLayer"] = ModemLayer
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
                packet.sendPort,
                packet.replyPort,
                packet:toTable()
            )
            self.interface.tx = self.interface.tx + 1
            self.interface:update()
        end
    end
end

function ModemLayer:recive()
    local _, side, sendPort, replyPort, packet, _
    if is_instance(self.interface, ModemInterface) then
        _, side, sendPort, replyPort, packet, _ = os.pullEvent("modem_message")
        if not self.interface.side == side then
            return
        end
    else
        return
    end

    local from = packet["from"]
    local to = packet["to"]
    local data = packet["data"]

    assert(type(from) == "number", "Received Packet.from must be a number")
    assert(type(to) == "number", "Received Packet.to must be a number")
    assert(type(data) == "table", "Received Packet.data must be a table")
    local packet = Packet:new()
    packet:fromTable(sendPort,replyPort,to,from,data)

    os.queueEvent("IPvCC|packet", packet)
    self.interface.rx = self.interface.rx + 1
    self.interface:update()
end

return IPvCC