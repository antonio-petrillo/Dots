global_settings = require("settings")

function on_system(callbacks)
   callback = callbacks[global_settings.system]
   if callback ~= nil then
      if type(callback) == "function" then
         callback()
      end
   end
end

require("monitor")
require("autostart")
require("env")
require("locknfeel")
require("input")
require("rules")

require("bindings")
