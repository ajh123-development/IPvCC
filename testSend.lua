package.preload.IPvCC=loadfile('/IPvCC/init.lua')
IPvCC = require("IPvCC")

IPvCC.checkInterfaces()
local mesage = IPvCC.types.Packet:new(10, 80, 0, {msg="Hello"})
IPvCC.interfaces["back"].layer:transmit(mesage)