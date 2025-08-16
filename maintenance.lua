local component = require("component");
local fs = require("filesystem");
local term = require("term");
local os = require("os");
local redstone = component.redstone;
require("utils");


local function loadSignals()
	
	if not fs.exists("signals.txt") then
		local wfp = fs.open("signals.txt", "w");

		if wfp == nil then
			print("Unable to create signals file. Please check your filesystem.");
			return {};
		end
		wfp:write(" ");
		wfp:close();
		return {};
	end
	local rfp = fs.open("signals.txt", "r");

	if rfp == nil then
		print("Unable to open signals file. Please check your filesystem.");
		return {};
	end
	local contents = rfp:read(fs.size("signals.txt"));
	print(contents)

	rfp:close();
	local signals = Split(contents, ",");
	local loaded = {};

	for i = 1, #signals, 2 do
		local signal = signals[i];
		local name = signals[i + 1];
		
		loaded[signal] = name;
	end
	return loaded;
end

local maintenance = {
	reading = false,
	mode = true, 
	signals = loadSignals()
}


function maintenance.Monitor()
	
	if not maintenance.mode then
		-- Detection mode
		for i = 1, #maintenance.signals do
			local signal = maintenance.signals[i];

			redstone.setWirelessFrequency(signal);

			if redstone.getWirelessInput() then
				Notify(signal .. "Needs maintenance");
			end
		end
	elseif maintenance.mode then
		-- Discovery mode
		for i = 1, 100 do
			if #maintenance.signals > 0 and Has(maintenance.signals, tostring(i)) then
				goto continue
			end
			redstone.setWirelessFrequency(i);

			if redstone.getWirelessInput() then
				print("Found a wireless signal with frequency " .. i);
				print("Assign a signal name: ")
				maintenance.reading = true;
				local name = term.read();

				print(name)
				if name == nil or name == "" then
					print("Invalid name. Skipping signal.");
					goto continue;
				end
				maintenance.reading = false;
				maintenance.signals[tostring(i)] = name;
			end
			os.sleep(1.5);
			::continue::
		end
	end

end

function maintenance.OnStop()
	local file, _ = fs.open("signals", "w");
	
	if file == nil then
		print("Unable to open signals file. Please check your filesystem.");
		return;
	end
	local string = "";

	for signal, name in pairs(maintenance.signals) do
		string = string .. signal .. "," .. name .. ",";
	end
	file:write(string);
	file:close();
end

function maintenance.toggle()
	maintenance.mode = not maintenance.mode;
end

return maintenance;
