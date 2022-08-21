local Class = require "IPvCC.class"

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

return MediaLayer