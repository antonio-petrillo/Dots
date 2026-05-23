local SUPER = "SUPER"

local function noop()
end

local function per_layout(bindings)
   return function()
      local layout = hl.get_config("general.layout")
      local callback = bindings[layout]
      if callback ~= nil then
         if type(callback) == "function" then
            callback()
         else
            layout_msg(callback)
         end
      else
         -- noop()
         hl.notification.create({ text = "TESTING: No binding in " .. layout, duration = 1000 })
      end
   end
end

hl.bind(SUPER .. " + SPACE", function()
           local current = hl.get_config("general.layout")
           local len = #global_settings.layouts
           for index, layout in ipairs(global_settings.layouts) do
              if layout == current then
                 local next_layout = global_settings.layouts[index % len + 1]
                 hl.notification.create({ text = "Change layout to: " .. next_layout, duration = 1000 })
                 hl.config({ general = { layout = next_layout }})
              end
           end
end)


hl.bind(SUPER .. " + H", per_layout({
              master = "mfact -0.05",
}))

hl.bind(SUPER .. " + J", per_layout({
              master = "cyclenext",
              monocle = "cyclenext"
}))

hl.bind(SUPER .. " + K", per_layout({
              master = "cycleprev",
              monocle = "cycleprev"
}))

hl.bind(SUPER .. " + L", per_layout({
              master = "mfact +0.05",
}))

hl.bind(SUPER .. " + SHIFT + H", per_layout({
              master = "addmaster",
}))

hl.bind(SUPER .. " + SHIFT + J", per_layout({
              master = "swapnext",
}))

hl.bind(SUPER .. " + SHIFT + K", per_layout({
              master = "swapprev",
}))

hl.bind(SUPER .. " + SHIFT + L", per_layout({
              master = "removemaster",
}))

hl.bind(SUPER .. " + CONTROL + H", per_layout({
              master = "swapwithmaster",
}))

hl.bind(SUPER .. " + CONTROL + J", per_layout({
              master = "rollprev",
}))

hl.bind(SUPER .. " + CONTROL + K", per_layout({
              master = "rollnext",
}))

hl.bind(SUPER .. " + CONTROL + L", per_layout({
              master = "focusmaster",
}))

hl.bind(SUPER .. " + left", per_layout({
              master = "mfact -0.05",
              monocle = "cyclenext"
}))

hl.bind(SUPER .. " + down", per_layout({
              master = "cyclenext",
              monocle = "cyclenext"
}))

hl.bind(SUPER .. " + up", per_layout({
              master = "cycleprev",
              monocle = "cycleprev"
}))

hl.bind(SUPER .. " + right", per_layout({
              master = "mfact +0.05",
              monocle = "cycleprev"
}))

hl.bind(SUPER .. " + SHIFT + left", per_layout({
              master = "addmaster",
}))

hl.bind(SUPER .. " + SHIFT + down", per_layout({
              master = "swapnext",
}))

hl.bind(SUPER .. " + SHIFT + up", per_layout({
              master = "swapprev",
}))

hl.bind(SUPER .. " + SHIFT + right", per_layout({
              master = "removemaster",
}))

hl.bind(SUPER .. " + CONTROL + left", per_layout({
              master = "swapwithmaster",
}))

hl.bind(SUPER .. " + CONTROL + down", per_layout({
              master = "rollprev",
}))

hl.bind(SUPER .. " + CONTROL + up", per_layout({
              master = "rollnext",
}))

hl.bind(SUPER .. " + CONTROL + right", per_layout({
              master = "focusmaster",
}))
