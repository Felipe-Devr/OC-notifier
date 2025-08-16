local component = require("component");
local fs = require("filesystem");
local term = require("term");
local text = require("text");
local shell = require("shell");
local redstone = component.redstone;
require("utils");

local signalsFilePath = string.format("%s/signals.txt", shell.resolve("./"));

local function loadSignals()
  
  if not fs.exists(signalsFilePath) then
    local wfp = fs.open(signalsFilePath, "w");

    if wfp == nil then
      print("Unable to create signals file. Please check your filesystem.");
      return {};
    end
    wfp:write(" ");
    wfp:close();
    return {};
  end
  local rfp = fs.open(signalsFilePath, "r");

  if rfp == nil then
    print("Unable to open signals file. Please check your filesystem.");
    return {};
  end
  local contents = rfp:read(fs.size(signalsFilePath));
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
  signals = loadSignals(),
  signalFrequencies = {},
  discoveryIdx = 1,
  detectionIdx = 1,
}

function maintenance.addSignal(freq, name)
  maintenance.signals[freq] = name;

  for frequency, _ in pairs(maintenance.signals) do
    table.insert(maintenance.signalFrequencies, frequency);
  end
end

function maintenance.Monitor()
  if not maintenance.mode then
    -- Detection mode
    local idx = maintenance.detectionIdx;
    local signal = maintenance.signalFrequencies[idx];
    local name = maintenance.signals[signal];

    redstone.setWirelessFrequency(tonumber(signal) or -1);

    if redstone.getWirelessInput() then
      Notify({
        content = string.format("**%s**\nNeeds Maintenance.", name),
        avatar_url =
        "https://ftbwiki.org/images/c/cc/Block_Maintenance_Hatch_%28GregTech_5%29.png",
        username = "Maintenance Notifier"
      });
    end
    if maintenance.detectionIdx > #maintenance.signalFrequencies then
      maintenance.detectionIdx = 1;
    else
      maintenance.detectionIdx = maintenance.detectionIdx + 1;
    end
  else
    -- Discovery mode
    local idx = maintenance.discoveryIdx;
    if #maintenance.signals > 0 and Has(maintenance.signals, tostring(idx)) then
      goto continue
    end
    redstone.setWirelessFrequency(idx);

    if redstone.getWirelessInput() then
      print("Found a wireless signal with frequency " .. idx);
      print("Assign a signal name (Dont use commas): ")
      maintenance.reading = true;
      local name = term.read();

      if name == nil or name == "" or type(name) == "boolean" then
        print("Invalid name. Skipping signal.");
        goto continue;
      end
      maintenance.reading = false;
      maintenance.addSignal(tostring(idx), text.trim(name));
    end
    ::continue::
    if (maintenance.discoveryIdx == 5000) then
      maintenance.discoveryIdx = 1;
    else
      maintenance.discoveryIdx = maintenance.discoveryIdx + 1;
    end
  end
end

function maintenance.OnStop()
  local file, _ = fs.open(signalsFilePath, "w");

  if file == nil then
    print("Unable to open signals file. Please check your filesystem.");
    return;
  end
  local saved = "";

  for signal, name in pairs(maintenance.signals) do
    saved = string.format("%s%s,%s,", saved, signal, name);
  end
  file:write(saved);
  file:close();
end

function maintenance.Toggle()
  maintenance.mode = not maintenance.mode;
end

return maintenance;
