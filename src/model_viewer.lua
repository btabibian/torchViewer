-- This viewer looks into a directory and finds files related to model specified
-- athor: Behzad Tabibian

local turbo = require("turbo")
local lfs = require"lfs"
local lfs_utils = require 'utils.lfs_utils'

local CheckPointHandler = class("CheckPointHandler", turbo.web.RequestHandler)
function CheckPointHandler:get(modelNumber)
  model_str = self.file_format:gsub("mdl",modelNumber)

  local temp = model_str:gsub(self.plMatch,"([%%d%%.]*)"):gsub(self.plLoss,"([%%d%%.]*)")
  local out = {}
  local ind = -1
  local files = lfs_utils.find_files(self.input_dir,temp)
  local fi_list = {}
  for i in pairs(files) do
    local fi = files[i][1]
    local filename = fi
    local temp_batch = model_str:gsub(self.plMatch,"([%%d%%.]*)"):gsub(self.plLoss,"[%%d%%.]*")
    local ind_current = tonumber(fi:match(temp_batch))
    fi_list[i] = ind_current
    if ind_current > ind then
      ind = ind_current
    end
  end
  self:write({latest_ind = ind,file_count = #files,indecies = fi_list})
end

function CheckPointHandler:setDefaults(plMatch, plLoss, file_format, input_dir)
  self.plMatch = plMatch
  self.plLoss = plLoss
  self.file_format = file_format
  self.input_dir = input_dir
end

return CheckPointHandler
