local turbo = require("turbo")
local lfs = require"lfs"
local lfs_utils = require 'utils.lfs_utils'

local TorchModelHandler = class("TorchModelHandler", turbo.web.RequestHandler)
function TorchModelHandler:get(modelNumber,index)
    model_str = self.file_format:gsub("mdl",modelNumber)
    
    if index == nil then
      local temp = model_str:gsub(self.plMatch,"([%%d%%.]*)"):gsub(self.plLoss,"([%%d%%.]*)")
      out = ""
      ind = -1
      files = lfs_utils.find_files(self.input_dir,temp)
      if #files > 0 then
        local filename = files[1][1]
        local temp_batch = model_str:gsub(self.plMatch,"([%%d%%.]*)"):gsub(self.plLoss,"[%%d%%.]*")
        ind_current = tonumber(filename:match(temp_batch))
        print(ind_current)
        if ind_current > ind then
          ind = ind_current
        end
      end
      out = out .. "latest batch:" .. ind .."\n"
      self:write(out)
      
    else
      model_str = self.file_format:gsub("mdl",modelNumber):gsub(self.plMatch,index):gsub(self.plLoss,"[%%d%%.]*")
         
      files = lfs_utils.find_files(self.input_dir,model_str)
      if #files > 0 then
        local filename = files[1][1]
        fi = filename:match(model_str) 
        io.input(self.input_dir .."/".. fi)
        t = io.read("*all")
        self:write("file size:" .. tostring(#t))
      end
    end
end

return TorchModelHandler

