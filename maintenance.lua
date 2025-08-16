local component = require("component");
local utils = require("utils");
local maintenance = {}
local receiver = component.redstone;


function maintenance.Monitor() 
	print(receiver)
	print(receiver.getWirelessFrequency());
end

function maintenance.SetMode(mode)
	maintenance.mode = mode;
end

return maintenance;