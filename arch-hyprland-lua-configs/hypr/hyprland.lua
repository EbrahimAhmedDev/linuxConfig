-- ==============================================================================
-- Hyprland Configuration in Lua (hyprland.lua)
-- Based on Josean Martinez's Arch Linux Setup + Arabic Layout & Right Split
-- ==============================================================================

local hl = require("hyprland")

-- 1. الشاشة (Monitors)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

-- 2. البرامج الأساسية (Programs)
local terminal = "kitty"
local fileManager = "nemo"
local browser = "chromium"
local music = "spotify"
local notion = browser .. " --app=https://notion.so"
local launcher = "rofi -show drun -show-icons"
local runner = "rofi -show run"

-- 3. التشغيل التلقائي (Autostart)
hl.start(function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("systemctl --user start hyprpolkitagent || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 30")
    hl.exec_cmd("playerctld daemon")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

-- 4. متغيرات البيئة والمظهر الداكن (Environment Variables & Dark Mode)
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "30")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "30")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- 5. الإعدادات العامة والمظهر (Config: General, Decoration, Animations, Layouts, Input)
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 3,
        ["col.active_border"] = "rgba(33ccffee) rgba(00ff99ee) 45deg",
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        active_opacity = 1.0,
        inactive_opacity = 0.85,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
        bezier = {
            "easeOutQuint,0.23,1,0.32,1",
            "easeInOutCubic,0.65,0.05,0.36,1",
            "linear,0,0,1,1",
            "almostLinear,0.5,0.5,0.75,1.0",
            "quick,0.15,0,0.1,1",
        },
        animation = {
            "global, 1, 10, default",
            "border, 1, 5.39, easeOutQuint",
            "windows, 1, 4.79, easeOutQuint",
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%",
            "windowsOut, 1, 1.49, linear, popin 87%",
            "fadeIn, 1, 1.73, almostLinear",
            "fadeOut, 1, 1.46, almostLinear",
            "fade, 1, 3.03, quick",
            "layers, 1, 3.81, easeOutQuint",
            "layersIn, 1, 4, easeOutQuint, fade",
            "layersOut, 1, 1.5, linear, fade",
            "fadeLayersIn, 1, 1.79, almostLinear",
            "fadeLayersOut, 1, 1.39, almostLinear",
            "workspaces, 1, 1.94, almostLinear, fade",
        },
    },

    dwindle = {
        pseudotile = true,
        preserve_split = true,
        force_split = 2, -- فتح النوافذ الجديدة على اليمين دائماً
    },

    input = {
        kb_layout = "us,ara",
        kb_options = "grp:win_space_toggle",
        repeat_rate = 25,
        repeat_delay = 300,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.2,
        },
    },
})

-- 6. قواعد النوافذ والطبقات (Window & Layer Rules)
hl.windowrule({
    "suppressevent maximize, class:.*",
    "float, class:^(pavucontrol|org.pulseaudio.pavucontrol)$",
    "float, title:^(bluetui|btop|htop)$",
    "size 900 600, title:^(bluetui|btop|htop)$",
})

hl.layerrule({
    "blur, rofi",
    "ignorezero, rofi",
})

-- 7. الاختصارات (Keybindings)
local mainMod = "SUPER"
local secondMod = "SUPER_SHIFT"

-- تشغيل التطبيقات (App Launchers)
hl.bind(mainMod, "T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod, "Q", hl.dsp.window.kill_active())
hl.bind(secondMod, "Q", hl.dsp.exit())
hl.bind(mainMod, "F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod, "B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod, "M", hl.dsp.exec_cmd(music))
hl.bind(mainMod, "N", hl.dsp.exec_cmd(notion))
hl.bind(mainMod, "S", hl.dsp.exec_cmd(launcher))
hl.bind(secondMod, "S", hl.dsp.exec_cmd(runner))

-- إدارة النوافذ (Window Management)
hl.bind(secondMod, "T", hl.dsp.window.toggle_floating())
hl.bind(secondMod, "F", hl.dsp.window.fullscreen({ mode = "maximize" }))
hl.bind(mainMod, "P", hl.dsp.window.pseudo())
hl.bind("ALT", "Tab", hl.dsp.window.cycle_next())

-- التنقل بين النوافذ بمفاتيح Vim (HJKL)
hl.bind(mainMod, "H", hl.dsp.window.move_focus("l"))
hl.bind(mainMod, "L", hl.dsp.window.move_focus("r"))
hl.bind(mainMod, "K", hl.dsp.window.move_focus("u"))
hl.bind(mainMod, "J", hl.dsp.window.move_focus("d"))

-- تحريك النوافذ بمفاتيح Vim (Super + Shift + HJKL)
hl.bind(secondMod, "H", hl.dsp.window.move("l"))
hl.bind(secondMod, "L", hl.dsp.window.move("r"))
hl.bind(secondMod, "K", hl.dsp.window.move("u"))
hl.bind(secondMod, "J", hl.dsp.window.move("d"))

-- مساحات العمل (Workspaces 1-10)
for i = 1, 9 do
    hl.bind(mainMod, tostring(i), hl.dsp.workspace.switch(i))
    hl.bind(secondMod, tostring(i), hl.dsp.workspace.move_to(i))
end
hl.bind(mainMod, "0", hl.dsp.workspace.switch(10))
hl.bind(secondMod, "0", hl.dsp.workspace.move_to(10))

-- مساحة العمل المخفية (Scratchpad / Special Workspace)
hl.bind(mainMod, "Z", hl.dsp.workspace.toggle_special("magic"))
hl.bind(secondMod, "Z", hl.dsp.workspace.move_to_special("magic"))

-- التنقل بالماوس (Mouse Binds)
hl.bind(mainMod, "mouse_down", hl.dsp.workspace.switch("e+1"))
hl.bind(mainMod, "mouse_up", hl.dsp.workspace.switch("e-1"))
hl.bindm(mainMod, "mouse:272", hl.dsp.window.move_mouse())
hl.bindm(mainMod, "mouse:273", hl.dsp.window.resize_mouse())

-- مفاتيح الصوت والسطوع والميديا (Hardware Media Keys)
hl.bindel("", "XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bindel("", "XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bindel("", "XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bindel("", "XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bindel("", "XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bindel("", "XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))
hl.bindl("", "XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bindl("", "XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bindl("", "XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bindl("", "XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
