fs.delete("/tmp/IPvCC/")
print("Packaging directories...")
fs.makeDir("/IPvCC/programs")

fs.move("/IPvCC/*.lua", "/IPvCC_programs/")
fs.move("/IPvCC/IPvCC", "/IPvCC/")

print("Finished installing IPvCC")