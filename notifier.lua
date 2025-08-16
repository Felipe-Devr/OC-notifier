--- Libraries

local config = require("config");
local event = require("event");
local ae2 = require("ae2");

if config.webhook == "Place-Your-WebHook-URL-Here" then
   print("Default webhook URL is being used. Please set a valid webhook URL.");
   return;
end

print("-- Starting notifier script --")
print("-- Press e to stop the script --");
local exit = false;

local function onKbEvent(name, address, char, code, playerName) 

   if char == 101 then
      exit = true
   elseif char == 109 then
      print("Disabling discovery mode")
   elseif char == 100 then
      print("Enabling discovery mode")
   end

end

event.listen('key_up', onKbEvent)

repeat
   MonitorAE();
until exit

event.ignore('key_up', onKbEvent);