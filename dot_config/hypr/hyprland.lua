--------------------
---- COLORS WAL ----
--------------------

local function load_wal_colors()
	local home = os.getenv("HOME") or ""
	local path = home .. "/.cache/wal/colors-hyprland.lua"
	local ok, result = pcall(dofile, path)

	if ok and type(result) == "table" then
		return result
	end

	return {}
end

local wal = load_wal_colors()

local function argb_to_rgba(value, fallback)
	if type(value) ~= "string" then
		return fallback
	end

	local hex = value:lower():match("^0x(%x%x%x%x%x%x%x%x)$")
	if not hex then
		return fallback
	end

	local aa, rr, gg, bb = hex:match("(%x%x)(%x%x)(%x%x)(%x%x)")
	return string.format("rgba(%s%s%s%s)", rr, gg, bb, aa)
end

local wal_active_a = argb_to_rgba(wal.color12, "rgba(33ccffee)")
local wal_active_b = argb_to_rgba(wal.color14, "rgba(00ff99ee)")
local wal_inactive = argb_to_rgba(wal.color8, "rgba(595959aa)")
local wal_shadow = argb_to_rgba("rgba(0,0,0,0.5)", "rgba(0,0,0,0.5)")

------------------
---- MONITORS ----
------------------

-- Moniteur gauche portrait
hl.monitor({ output = "HDMI-A-1", mode = "preferred", transform = 3, position = "0x0", scale = 1 })

-- Moniteur millieu horizontal
hl.monitor({ output = "DP-2", mode = "preferred", position = "1440x500", scale = 1 })

-- Moniteur droit horizontal
hl.monitor({ output = "DP-1", mode = "preferred", position = "4000x500", scale = 1 })

------------------
---- PROGRAMS ----
------------------
local terminal = "kitty"
local fileManager = "thunar"
local menu = "wofi -n"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpm reload -n")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css")
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("pypr")
	hl.exec_cmd("swaync-client -df")
	hl.exec_cmd("hyprctl setcursor phinger-cursors-dark 24")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("awww-daemon")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("WAYLAND_DISPLAY", "wayland-0")

hl.env("GTK_IM_MODULE", "cedilla")
hl.env("QT_IM_MODULE", "cedilla")

hl.env("QT_STYLE_OVERRIDE", "kvantum")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,

		border_size = 0,

		-- https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
		--col = {
		--	active_border = wal_active_a .. " " .. wal_active_b .. " 45deg",
		--	inactive_border = wal_inactive,
		--},

		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		active_opacity = 0.78,
		inactive_opacity = 0.7,
		fullscreen_opacity = 1,
		blur = {
			enabled = true,
			size = 3,
			passes = 5,
			ignore_opacity = true,
			xray = false,
			popups = true,
		},
		shadow = {
			enabled = true,
			range = 15,
			render_power = 5,
			color = wal_shadow,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
		focus_on_activate = true,
		middle_click_paste = false,
	},
})

hl.curve("fluid", { type = "bezier", points = { { 0.15, 0.85 }, { 0.25, 1 } } })
hl.curve("snappy", { type = "bezier", points = { { 0.3, 1 }, { 0.4, 1 } } })
hl.curve("default", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3.0, bezier = "fluid", type = "popin", offset = "5%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.0, bezier = "snappy" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.0, bezier = "snappy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.0, bezier = "snappy", type = "slide" })
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 3.0,
	bezier = "fluid",
	type = "slidefadevert",
	offset = "-35%",
})
hl.animation({ leaf = "layers", enabled = true, speed = 3.0, bezier = "snappy", type = "popin", offset = "70%" })

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "intl",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = -0.3, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo("# dwindle"))
hl.bind(mainMod .. " + G", hl.dsp.layout("togglesplit # dwindle"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/hypr/show_desktop.sh"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(terminal .. " --hold sh -c btop"))

-- -- # Hyprspace
-- -- bind = $mainMod, TAB, overview:toggle, all
-- -- #bind = SUPER, TAB, overview:toggle
-- -- #bind = SUPER SHIFT, TAB, overview:toggle, all

-- TODO : fix this
-- hl.bind(mainMod .. " + TAB", hl.dsp.overview.toggle("all"))

hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + ALT + L", hl.dsp.exec_cmd("wlogout -b 2"))

hl.bind("ALT + W", hl.dsp.exec_cmd("~/.config/hypr/wallpaper.sh"))

-- # Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

-- # Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))

-- # Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))

-- # Example special workspace (scratchpad)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- # Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "r+1" }))

-- # Move into monitor workspaces
hl.bind(mainMod .. " + equal", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + minus", hl.dsp.focus({ workspace = "r-1" }))

-- # Move current window into monitor worspaces
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.move({ workspace = "r-1" }))

hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }))

-- -- # Screen taking
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("/home/sigill/.local/bin/doki -c"))
--
-- # Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("mouse:277", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

-- local suppressMaximizeRule = hl.window_rule({
-- 	-- Ignore maximize requests from all apps. You'll probably like this.
-- 	name = "suppress-maximize-events",
-- 	match = { class = ".*" },
--
-- 	suppress_event = "maximize",
-- })
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
local overlayLayerRule = hl.layer_rule({
	name = "no-anim-overlay",
	match = { namespace = "^my-overlay$" },
	no_anim = true,
})
overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Blur waybar
hl.layer_rule({
	name = "blur-waybar",
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.8,
})

-- Blur swaync
hl.layer_rule({
	name = "blur-swaync-control-center",
	match = { namespace = "swaync-control-center" },
	blur = true,
	ignore_alpha = 0.35,
})

-- Blur swaync notifications
hl.layer_rule({
	name = "blur-swaync-notification-window",
	match = { namespace = "swaync-notification-window" },
	blur = true,
	ignore_alpha = 0.35,
})

-- This is a layer rule that disables animations for the selection layer. This is useful if you want to have a static selection layer without any animations.
-- hl.layer_rule({
-- 	name = "no-anim-selection",
-- 	match = { namespace = "selection" },
-- 	no_anim = true,
-- })

-- Blur swayosd
hl.layer_rule({
	name = "blur-swayosd",
	match = { namespace = "swayosd" },
	blur = true,
	ignore_alpha = 0.5,
})
