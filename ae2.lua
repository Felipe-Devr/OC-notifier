local computer = require("computer")
local component = require("component");
local utils = require("utils");

local controllers = {};
local busyCpuCache = {};
local ignored = GetIgnored();


for address in component.list("me_controller") do
  table.insert(controllers, component.proxy(component.get(address)));
end

print("-- Monitoring " .. #controllers .. " ME controllers --")

if (#ignored > 0) then
  print("-- Ignoring CPUs: " .. table.concat(ignored, ", ") .. " --");
else
  print("-- No CPUs are being ignored --");
end

function MonitorAE()
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
          Notify("**CPU " ..
            j .. "**\nFinished crafting\nElapsed: " .. time .. "\nUnable to get the crafting result.");
        else
          Notify("**CPU " ..
            j ..
            "**\nFinished crafting\nElapsed: " ..
            time .. "\nResult: x" .. procData.result.size .. " " .. procData.result.label);
        end
        busyCpuCache["CPU " .. j] = nil;
      end
      ::continue::
    end
  end
end
