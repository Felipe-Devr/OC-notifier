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

local exit = false;

local function onKbEvent(name, address, char, code, playerName)
   print(maintenance)
   if maintenance ~= nil and maintenance.reading then
      return;
   end
   if char == 101 then
      print("Stopping notifier script");
      exit = true
   elseif char == 109 then
      print("Disabling discovery mode")
   end
end

event.listen('key_up', onKbEvent)

print("-- Press e to stop the script --");

while true do
   if exit then
      if maintenance ~= nil then
         maintenance.OnStop();
      end
      print("Exiting notifier script");
      return;
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

event.ignore('key_up', onKbEvent);
