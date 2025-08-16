--- Libraries

local internet = require("internet");
local config = require("config");
local component = require("component");
local event = require("event");
local computer = require("computer")

-- Program functions

if config.webhook == "Place-Your-WebHook-URL-Here" then
   print("Default webhook URL is being used. Please set a valid webhook URL.");
   return;
end

local function notify(message)
   internet.request(config.webhook, {
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


local function getIgnored()
   local ignored = {}

   if #config.ignoredCpus >= 1 then
      local endIndex = config.ignoredCpus[1];

      if (#config.ignoredCpus > 1) then
         endIndex = #config.ignoredCpus;
      end
      
      for i = 1, endIndex do
         table.insert(ignored, i);
      end
   end
   return ignored
end

local function has(list, item)
   for _, value in ipairs(list) do
      if value == item then
         return true;
      end
   end
   return false
end


local controllers = {};
local busyCpuCache = {};
local ignored = getIgnored();

for address in component.list("me_controller") do
   table.insert(controllers, component.proxy(component.get(address)));
end

print("-- Starting notifier script --")
print("-- Monitoring " .. #controllers .. " ME controllers --")

if (#ignored > 0) then
   print("-- Ignoring CPUs: " .. table.concat(ignored, ", ") .. " --");
else
   print("-- No CPUs are being ignored --");
end

print("-- Press Alt-Ctrl+C to stop the script --");

repeat
   for i = 1, #controllers do
      local cpus = controllers[i].getCpus()

      if (#ignored > #cpus) then return; end;

      for j = 1, #cpus do
         if has(ignored, j) then goto continue; end

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
         ::continue::
      end
   end
until event.pull(0.5) == "interruped"
