--- Libraries

local internet = require("internet");
local component = require("component");
local event = require("event");

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

repeat
	for i = 1, #controllers do
		local cpus = controllers[i].getCpus()

		for j = 1, #cpus do
			local cpuData = cpus[j]
			if cpuData.busy and busyCpuCache[cpuData.name] == nil then
				table.insert(busyCpuCache, cpuData.name)
			end

			if busyCpuCache[cpuData.name] ~= nil and not cpuData.busy then
				print("We got one!")
				notify("CPU " .. cpuData.name .. " finished")
				table.remove(busyCpuCache, cpuData.name);
			end
		end
	end
until event.pull(1) == "interruped"
