fs.delete("tmp/IPvCC")
print("Packaging directories...")
fs.delete("IPvCC_programs")
fs.makeDir("IPvCC_programs")

fs.move("IPvCC/ifconfig.lua", "IPvCC_programs/ifconfig.lua")
fs.move("IPvCC/testSend.lua", "IPvCC_programs/testSend.lua")
fs.move("IPvCC/testRecv.lua", "IPvCC_programs/testRecv.lua")
fs.move("IPvCC/router.lua", "IPvCC_programs/router.lua")

fs.delete("IPvCC/setup")
fs.move("IPvCC/IPvCC", "tmp/IPvCC")
fs.delete("IPvCC")
fs.move("tmp/IPvCC", "IPvCC")
fs.delete("tmp/IPvCC")

print("Finished installing IPvCC")