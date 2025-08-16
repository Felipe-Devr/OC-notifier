local computer = require("computer")
local component = require("component");
local utils = require("utils");

local controllers = {};
local busyCpuCache = {};
local ignored = GetIgnored();


for address in component.list("me_controller") do
  table.insert(controllers, component.proxy(component.get(address)));
end



function MonitorAE()
  print("-- Monitoring " .. #controllers .. " ME controllers --")

  if (#ignored > 0) then
    print("-- Ignoring CPUs: " .. table.concat(ignored, ", ") .. " --");
  else
    print("-- No CPUs are being ignored --");
  end
  for i = 1, #controllers do
    local cpus = controllers[i].getCpus()

    if (#ignored > #cpus) then return; end;

    for j = 1, #cpus do
      if Has(ignored, j) then goto continue; end

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
        local seconds = _seconds - (minutes * 60);
        local time = FormatTime(hours, minutes, seconds);

        if procData.result == nil then
          Notify("AE2", {
            content = string.format("**CPU %d**\nFinished crafting\nElapsed: %s\nUnable to get the result item.", j, time),
            avatar_url =
            "https://static.wikia.nocookie.net/ftb_gamepedia/images/7/70/ME_Controller_AE2.png/revision/latest",
            username = "AE2 Crafting Notifier"
          });
        else
          Notify("AE2", {
            content = string.format("**CPU %d**\nFinished crafting\nElapsed: %s\nResult: x%d %s", j, time,
              procData.result.size, procData.result.label),
            avatar_url =
            "https://static.wikia.nocookie.net/ftb_gamepedia/images/7/70/ME_Controller_AE2.png/revision/latest",
            username = "AE2 Crafting Notifier"
          });
        end
        busyCpuCache["CPU " .. j] = nil;
      end
      ::continue::
    end
  end
end
