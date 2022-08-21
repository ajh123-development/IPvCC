local myPath = shell.dir()
shell.setDir("/")
IPvCC = require "IPvCC"
shell.setDir(myPath)

IPvCC.checkInterfaces()
for id, interface in pairs(IPvCC.interfaces) do
    print(id, "Link encap:", interface.layer.type, interface.infoString)
end