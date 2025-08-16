--- Libraries

local config = require("config");
local event = require("event");
local os = require("os");
local component = require("component");
local maintenance = nil;

if config.webhook == "Place-Your-WebHook-URL-Here" then
   print("Default webhook URL is being used. Please set a valid webhook URL.");
   return;
end

print("-- Starting notifier script --")
require("ae2");

Exit = false

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

print("-- Press e to stop the script --");

while true do
   print(Exit)
   if Exit then
      break;
   end
   
   MonitorAE();
   if not component.isAvailable("redstone") then
      print("Unable to connect to the redstone component. Disabling maintenance module.")
   else
      maintenance = require("maintenance")

      maintenance.Monitor();
   end
   os.sleep(0.8)

end

if maintenance ~= nil then
   maintenance.OnStop();
end
event.ignore('key_up', onKbEvent);
