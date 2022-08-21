local api = require "/tmp/GuiH"
local gui = api.new(term.current())
local main = {gui=gui}

function main:body()
    self.main_bg = self.gui.new.rectangle{
         x=5,y=5,width=15,height=8,
         color=colors.red,
         graphic_order=-math.huge
    }
end

function main:prompt()
     self.prompt_input = self.gui.new.inputbox{
         x=6,y=6,width=13,
         background_color=colors.white,
         text_color=colors.black
     }
end

function main:start()
    self:body()
    self:prompt()
    self.gui.execute()
end

return main