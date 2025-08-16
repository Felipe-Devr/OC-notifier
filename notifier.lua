--- Libraries

local config = require("config");
local event = require("event");
local os = require("os");
local maintenance = require("maintenance")

if config.webhook == "Place-Your-WebHook-URL-Here" then
   print("Default webhook URL is being used. Please set a valid webhook URL.");
   return;
end

print("-- Starting notifier script --")
require("ae2");

local exit = false;

local function onKbEvent(name, address, char, code, playerName) 

   print(char);
   if char == 101 then
      print("Stopping notifier script");
      exit = true
   elseif char == 109 then
      print("Disabling discovery mode")
   end

end

event.listen('key_up', onKbEvent)

print("-- Press e to stop the script --");

while not exit do
   MonitorAE();
   maintenance.Monitor();
   os.sleep(0.8)
end

event.ignore('key_up', onKbEvent);