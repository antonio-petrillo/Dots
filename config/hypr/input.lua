hl.config({
    input = {
        kb_layout  = "us, us",
        kb_variant = ", intl",
        kb_model   = "",
        kb_options = "ctrl:nocaps, grp:ctrls_toggle",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.


        touchpad = {
            natural_scroll = false,
            disable_while_typing = true,
            tap_to_click = true,
            middle_button_emulation = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
