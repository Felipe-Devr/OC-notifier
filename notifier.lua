--- Libraries

local internet = require("internet");
local component = require("component");

--- Program Configuration
local configuration = {
	weebhook =
	"https://discord.com/api/webhooks/1406120859193708544/Ww_ZBuBI9Fk4Ew6JqCT1HLZs-FuTdxQf8Rx8G2lI3fAne1BrBLgLJ5t4WWmCCr_-NbLb"
}


local function notify(message)
	internet.request(configuration.weebhook, {
		content = message
	});
end

local controllers = {};
local busyCpuCache = {};


for address in component.list("me_controller") do
	table.insert(controllers, component.proxy(component.get(address)));
end

while true do
	for i = 1, #controllers do
		local controller = controllers[i];
		print(controller.getCpus)
		for cpuData in controller.getCpus() do
			--[[ if cpuData.busy then
			busyCpuCache[cpuData.name] = true;
		end

		if busyCpuCache[cpuData.name] and not cpuData.busy then
			notify("CPU " .. cpuData.name .. " finished")
		end ]] --
		end
	end
end
