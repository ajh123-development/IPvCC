local myPath = shell.dir()
shell.setDir("/")
IPvCC = require "IPvCC"
shell.setDir(myPath)

IPvCC.checkInterfaces()
local mesage = IPvCC.types.Packet:new(10, 80, 0, {msg="Hello"})
IPvCC.interfaces["back"].layer:transmit(mesage)