hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", "2")

on_system({
      desk = function() hl.env("GBM_BACKEND", "nvidia-drm") end,
})
