local shell = require("shell");

local scriptFiles = {
	'config.lua',
	'notifier.lua',
	'uninstall.lua'
}

local endPoint = "https://raw.githubusercontent.com/Felipe-Devr/OC-notifier/main/"

local function downloadFile(fileName) 
	local url = string.format("%s%s", endPoint, fileName);

	shell.execute(string.format("wget -f %s", url));
end

-- DOWNLOAD
for i=1, #scriptFiles do
	downloadFile(scriptFiles[i])
end

shell.execute("rm init.lua");