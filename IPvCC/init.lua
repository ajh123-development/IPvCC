local IPvCC = require "IPvCC.core"
IPvCC["INet"] = {}
IPvCC["types"] = {}


--Small types
local Class = require "IPvCC.class"
IPvCC["Class"] = Class

local Packet = require "IPvCC.types.Packet"
IPvCC["types"]["Packet"] = Packet


--INet stuff
local Datagram = require "IPvCC.protocols.ip.Datagram"
IPvCC["INet"]["Datagram"] = Datagram


--Interfaces
local Interface = require "IPvCC.types.Interface"
IPvCC["types"]["Interface"] = Interface

local ModemInterface = require "IPvCC.types.ModemInterface"
IPvCC["types"]["ModemInterface"] = ModemInterface


--Layers
local MediaLayer = require "IPvCC.types.MediaLayer"
IPvCC["types"]["MediaLayer"] = MediaLayer

local ModemLayer = require "IPvCC.types.ModemLayer"
IPvCC["types"]["ModemLayer"] = ModemLayer

return IPvCC