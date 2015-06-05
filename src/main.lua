local turbo = require("turbo")
local torchModel = require("model_viewer.lua")

cmd = torch.CmdLine()

cmd:text() 
cmd:option('-file_format','lm_[model]_sample[batch]_[loss].t7','input file format')
cmd:option('-input_dir','dir','input directory')
cmd:text()
 
opt = cmd:parse(arg)

torchModel.file_format = opt.file_format
torchModel.input_dir = opt.input_dir
torchModel.plMatch = 'btch'
torchModel.plLoss = 'loss'

app = turbo.web.Application:new({

{"/model/(%d+)/(%d+)$", torchModel},
{"/model/(%d+)$", torchModel}
})

app:listen(8888)
turbo.ioloop.instance():start()
