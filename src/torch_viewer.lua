-- This viewer deals with a particular torch output file, i.e. t7
-- input files should be a table containing multiple batches. 
-- Each batch is table containing three Torch tensors, i.e. x,y, pred.
-- author: Behzad Tabibian
local turbo = require("turbo")
local torch = require("torch")
local lfs = require"lfs"
local lfs_utils = require 'utils.lfs_utils'

local TorchModelHandler = class("TorchModelHandler", turbo.web.RequestHandler)

-- main handler of the viewer.
-- input url: /model/[modelNumberi]/[index]?batch=batchNumber&ind=recordId
-- returns a json with batch info,record value etc. 
function TorchModelHandler:get(modelNumber,index)

  model_str = self.file_format:gsub("mdl",modelNumber):gsub(self.plMatch,index):gsub(self.plLoss,"[%%d%%.]*")    
  files = lfs_utils.find_files(self.input_dir,model_str)
  if #files == 0 then
    self:write() 
    return
  end

  vals = {}
  local filename = files[1][1]
  print(self.input_dir.."/"..filename)
  tensor = torch.load(self.input_dir.."/"..filename)
  batch_count = #tensor
  vals['batch_count'] = batch_count

  -- batch level
  local batch_arg = self:get_argument("batch","None",true)
  if batch_arg == "None" then
    self:write(vals)
    return
  end
  batch_i = tonumber(batch_arg)
  batch_len = tensor[batch_i].x:size(1)
  vals['batch_length'] = batch_len
  vals['batch_i'] = batch_i

  -- record level
  local ind_arg = self:get_argument("ind","None",true)
  if ind_arg == "None" then
    self:write(vals)
    return
  end
  ind_i = tonumber(ind_arg)
  vals['ind_i'] = ind_i
  if batch_len < ind_i then
     print('error detected')
     error(turbo.web.HTTPError(400, "Index out of bounds"))
     return
  end
  vals['x'] = tensor[batch_i].x[ind_i]:totable()
  vals['y'] = tensor[batch_i].y[ind_i]:totable()
  vals['pred'] = tensor[batch_i].pred[ind_i]:totable()
  self:write(vals)
end

function TorchModelHandler:setDefaults(plMatch, plLoss, file_format, input_dir)
  self.plMatch = plMatch
  self.plLoss = plLoss
  self.file_format = file_format
  self.input_dir = input_dir
end

return TorchModelHandler
