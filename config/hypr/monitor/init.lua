local found = false
for _, system in ipairs(global_settings.systems) do
   found = found or system == global_settings.system
end


if found then
   require("monitor." .. global_settings.system)
end
