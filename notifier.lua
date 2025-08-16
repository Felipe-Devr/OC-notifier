--- Libraries

local config = require("config");
local event = require("event");
local os = require("os");
local component = require("component");
local term = require("term");
local maintenance = nil;

if config.webhook == "Place-Your-WebHook-URL-Here" then
   print("Default webhook URL is being used. Please set a valid webhook URL.");
   return;
end

print("-- Starting notifier script --")
require("ae2");

Exit = false
local maintenanceThread = nil;

local function onKbEvent(name, address, char, code, playerName)
   if maintenance ~= nil and maintenance.reading then
      return;
   end
   if char == 101 then
      print("Stopping notifier script");
      Exit = true;
   elseif char == 109 and maintenance ~= nil then
      maintenance.Toggle();
      if maintenance.mode then
         print("Maintenance module set to DISCOVERY mode");
      else
         print("Maintenance module set to DETECTION mode");
      end
   end
end

event.listen('key_up', onKbEvent)


while true do
   if Exit then
      break;
   end

   print("-- Press e to stop the script --");

   MonitorAE();
   if not component.isAvailable("redstone") then
      print("Unable to connect to the redstone component. Disabling maintenance module.")
   else
      maintenance = require("maintenance")
      print("-- Press m to toggle maintenance mode --");

      maintenance.Monitor();
   end
   
   if (maintenance ~= nil and not maintenance.reading) or maintenance == nil then
      term.clear();
   end
   os.sleep(0.8)
end

if maintenance ~= nil and maintenanceThread ~= nil then
   maintenance.OnStop();
end
event.ignore('key_up', onKbEvent);
