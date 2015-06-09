-- this progam is an interface between outputs of torch program.
-- for each viewer there is a handler
-- author: Behzad Tabibian


local turbo = require("turbo")
local modelModel = require("model_viewer.lua")
local torchModel = require("torch_viewer.lua")

cmd = torch.CmdLine()

cmd:text() 
cmd:option('-file_format','lm_model_mdl_samplebtch.00_loss.t7','input file format')
cmd:option('-input_dir','dir','input directory')
cmd:option('-port',8890,'port number for web app')
cmd:text()
 
opt = cmd:parse(arg)

plMatch = 'btch'
plLoss = 'loss'
torchModel:setDefaults(plMatch, plLoss, opt.file_format, opt.input_dir)
modelModel:setDefaults(plMatch, plLoss, opt.file_format, opt.input_dir)
app = turbo.web.Application:new({

{"/model/(%d+)/(%d+)$", torchModel},
{"/model/(%d+)$", modelModel}
})

app:listen(opt.port)
turbo.ioloop.instance():start()
