local Class = require "IPvCC.class"
local Core = require "IPvCC.core"
local Packable = require "IPvCC.types.Packet".Packable

local Datagram = Class:new(Packable)

function Datagram:__new(toIp, fromIp, data)
    if Core:IsIPv4(toIp) ~= 1 then error("toIp is not a valid IPv4 address") end
    if Core:IsIPv4(fromIp) ~= 1 then error("fromIp is not a valid IPv4 address") end
    assert(type(data) == "table", "data must be a table")
end


return Datagram