local settings = {
   layouts = { "master", "monocle", "scrolling", },

   initial_layout = function(self)
      return self.layouts[1]
   end,
}

hl.config({
      xwayland = {
         force_zero_scaling = true,
      }
})

hl.config({
    master = {
        new_status = "master",
    },
    scrolling = {
        fullscreen_on_one_column = true,
    },
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true,
    },
})

return settings
