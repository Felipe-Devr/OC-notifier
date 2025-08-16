local internet = require("internet");
local config = require("config");
local computer = require("computer");

local messageQueue = {};
local lastMessageStamp = computer.uptime();

function Notify(type, message)
  table.insert(messageQueue, { type = type, content = message });
  ProcessQueue();
end

function ProcessQueue()
  if #messageQueue == 0 then return; end
  local message = messageQueue[1];

  if math.floor(computer.uptime() - lastMessageStamp) < config.messageTimeouts[message.type] then return; end

  lastMessageStamp = computer.uptime();
  table.remove(messageQueue, 1);
  internet.request(config.webhook, message);
end

function FormatTime(hours, minutes, seconds)
  local function formatNumber(number)
    if (number < 10) then return "0" .. number; end;
    return tostring(number);
  end
  return formatNumber(hours) .. ":" .. formatNumber(minutes) .. ":" .. formatNumber(seconds);
end

function Split(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

function GetIgnored()
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

function Has(list, item)
  for _, value in ipairs(list) do
    if value == item then
      return true;
    end
  end
  return false
end
