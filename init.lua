local shell = require("shell");

local scriptFiles = {
   'config.lua',
   'notifier.lua',
   'ae2.lua',
   'utils.lua',
   'maintenance.lua',
   'uninstall.lua'
}

local endPoint = "https://raw.githubusercontent.com/Felipe-Devr/OC-notifier/main/"

local function downloadFile(fileName)
   local url = string.format("%s%s", endPoint, fileName);

   shell.execute(string.format("wget -f %s", url));
end

-- DOWNLOAD
shell.execute("mkdir notifier && cd notifier");
for i = 1, #scriptFiles do
   downloadFile(scriptFiles[i])
end


shell.execute("cd ..");
print("Notifier downloaded successfully, now configure it and run it with 'notifier/notifier.lua'");
shell.execute("rm init.lua");

