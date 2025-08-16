--- Libraries

local internet = require("internet");
local component = require("component");
local event = require("event");
local computer = require("computer")

--- Program Configuration
local configuration = {
	webhook =
	"Insert-Your-Webhook-Link"
}


local function notify(message)
	internet.request(configuration.webhook, {
		content = message,
		avatar_url = "https://static.wikia.nocookie.net/ftb_gamepedia/images/7/70/ME_Controller_AE2.png/revision/latest",
		username = "AE2 Crafting Notifier"
	});
end

local function formatTime(hours, minutes, seconds)
	local timestring = "";

	local function formatNumber(number)
		if (number < 10) then return "0" .. number; end;
		return tostring(number);
	end
	return formatNumber(hours) .. ":" .. formatNumber(minutes) .. ":" .. formatNumber(seconds);
end

local controllers = {};
local busyCpuCache = {};


for address in component.list("me_controller") do
	table.insert(controllers, component.proxy(component.get(address)));
end

print("-- Starting notifier script --")
print("-- Monitoring " .. #controllers .. " ME controllers --")
print("-- Ctrl-Alt + C to stop the script --")

repeat
	for i = 1, #controllers do
		local cpus = controllers[i].getCpus()

		for j = 1, #cpus do
			local cpuData = cpus[j]
			if cpuData.busy and busyCpuCache["CPU " .. j] == nil then
				busyCpuCache["CPU " .. j] = {
					startTime = computer.uptime(),
					result = cpuData.cpu.finalOutput()
				}
			end

			if busyCpuCache["CPU " .. j] ~= nil and not cpuData.busy then
				local procData = busyCpuCache["CPU " .. j]
				local _seconds = math.floor(computer.uptime() - procData.startTime);
				local _minutes = math.floor(_seconds / 60);
				local hours = math.floor(_minutes / 60);
				local minutes = _minutes - (hours * 60);

				local time = formatTime(hours, minutes, _seconds - (minutes * 60));

				if procData.result == nil then
					notify("**CPU " ..
					j .. "**\nFinished crafting\nElapsed: " .. time .. "\nUnable to get the crafting result.");
				else
					notify("**CPU " ..
					j ..
					"**\nFinished crafting\nElapsed: " ..
					time .. "\nResult: x" .. procData.result.size .. " " .. procData.result.label);
				end
				busyCpuCache["CPU " .. j] = nil;
			end
		end
	end
until event.pull(0.5) == "interruped"
