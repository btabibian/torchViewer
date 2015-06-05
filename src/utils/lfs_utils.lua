local lfs = require"lfs"

lfs_utils = {}

function lfs_utils.find_files(path,pattern)
  result = {}
  i = 1
  for file_name in lfs.dir(path .."/") do
    if file_name:match(pattern) ~= nil then
      result[i] = {file_name,file_name:match(pattern)} 
    end
  end
  return result
end

return lfs_utils
