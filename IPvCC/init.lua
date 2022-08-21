local IPvCC = require "IPvCC.core"
IPvCC.INet = {}
IPvCC.types = {}

--Small types

IPvCC.Class = require "IPvCC.class"
IPvCC.types.Packet = require "IPvCC.types.Packet"

--INet stuff

IPvCC.INet.Datagram = require "IPvCC.protocols.ip.Datagram"

--Interfaces

IPvCC.types.Interface = require "IPvCC.types.Interface"
IPvCC.types.ModemInterface = require "IPvCC.types.ModemInterface"

--Layers

IPvCC.types.MediaLayer = require "IPvCC.types.MediaLayer"
IPvCC.types.ModemLayer = require "IPvCC.types.ModemLayer"

return IPvCC