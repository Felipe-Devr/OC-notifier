local function loadConfiguration()
   return {
      webhook = '.Place-Your-WebHook-URL-Here',
      ignoredCpus = { -- When only one cpu number is placed, the program will ignore backwards that number. When multiple are placed, it will ignore all of the selected 
        -- 1
      },
      messageTimeouts = {
         AE2 = 1,
         Maintenance = 5
      }
   }
end

return loadConfiguration()
