local Class = require "IPvCC.class"

--[[
    An Interface is an object that will
    transmit and recive a packet from a
    MediaLayer.
]]--
Interface = Class:new()

function Interface:__new()
    self.layer = nil
    self.infoString = ""
    self.tx = 0
    self.rx = 0
    self.errors = 0
end

--[[
    Opens a port for reciving data from.
    A port can be any number in this range,
    0 to 65536.
]]--
function Interface:open(port) end

--[[
    Closes a port for reciving data from.
    A port can be any number in this range,
    0 to 65536.
]]--
function Interface:close(port) end

--[[
    Updates the stats and files for this
    interface.
]]--
function Interface:update() end

return Interface