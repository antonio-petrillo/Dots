local settings = {
   layouts = {
      "master",
      "monocle",
      -- "scrolling",
      -- "dwindle",
   },

   initial_layout = function(self)
      return self.layouts[1]
   end,

   systems = { "f13", "desk" },
   system = "f13",
}

local handle = io.popen("hostname")
if handle ~= nil then
    settings.system = handle:read("*a"):gsub("\n$", "")
    handle:close()
end

hl.config({
      xwayland = {
         force_zero_scaling = true,
      }
})

hl.config({
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true,
    },
})

return settings
