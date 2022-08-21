local Class = require "IPvCC.class"

Packet = Class:new()
function Packet:__new(sendPort, replyPort, to, data)
    self.to = to
    self.from = os.getComputerID()
    self.data = data
    self.sendPort = sendPort
    self.replyPort = replyPort
end

function Packet:fromTable(sendPort, replyPort, to, from, data)
    self.to=to
    self.from=from
    self.data=data
    self.sendPort = sendPort
    self.replyPort = replyPort
end


function Packet:toTable()
    return {
        to=self.to,
        from=self.from,
        data=self.data,
        sendPort=self.sendPort,
        replyPort=self.replyPort
    }
end

return Packet