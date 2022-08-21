fs.delete("/IPvCC")

local function getRunningPath()
    local runningProgram = shell.getRunningProgram()
    local programName = fs.getName(runningProgram)
    return runningProgram:sub( 1, #runningProgram - #programName )
end

shell.setAlias("ifconfig", "/"..getRunningPath().."/ifconfig.lua")

IPvCC = require "IPvCC"
IPvCC.deleteInterfaceFiles()

fs.copy( getRunningPath().."/IPvCC", "/IPvCC")