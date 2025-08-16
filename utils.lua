local internet = require("internet");
local config = require("config");

function Notify(message)
   internet.request(config.webhook, {
      content = message,
      avatar_url = "https://static.wikia.nocookie.net/ftb_gamepedia/images/7/70/ME_Controller_AE2.png/revision/latest",
      username = "AE2 Crafting Notifier"
   });
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
  for str in string.gmatch(str, "([^"..sep.."]+)") do
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
