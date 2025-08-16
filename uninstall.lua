local shell = require("shell");
local files = {
   'notifier.lua',
   'config.lua',
   'ae2.lua',
   'notifier.lua',
   'utils.lua',
   'uninstall.lua'
}

for idx = 1, #files do
   shell.execute(string.format("rm %s", files[idx]));
   print(string.format("Removed %s", files[idx]));
end
