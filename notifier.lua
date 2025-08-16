--- Libraries

local config = require("config");
local event = require("event");

if config.webhook == "Place-Your-WebHook-URL-Here" then
   print("Default webhook URL is being used. Please set a valid webhook URL.");
   return;
end

print("-- Starting notifier script --")
print("-- Press Alt-Ctrl+C to stop the script --");

local function onKbEvent(name, address, char, code, playerName) 

   print(char, code);

end

event.listen('key_up', onKbEvent)

repeat
   MonitorAE();
until event.pull(0.5) == "interruped"

event.ignore('key_up', onKbEvent);