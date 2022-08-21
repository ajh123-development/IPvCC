fs.delete("tmp/IPvCC/")
print("Packaging directories...")
fs.delete("IPvCC_programs")
fs.makeDir("IPvCC_programs")

fs.move("IPvCC/ifconfig.lua", "IPvCC_programs/ifconfig.lua")
fs.move("IPvCC/testSend.lua", "IPvCC_programs/testSend.lua")
fs.move("IPvCC/testRecv.lua", "IPvCC_programs/testRecv.lua")

fs.move("IPvCC/IPvCC", "IPvCC")
fs.delete("IPvCC/setup")

print("Finished installing IPvCC")