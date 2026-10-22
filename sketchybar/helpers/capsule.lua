local colors = require("colors")
local settings = require("settings")

-- Shared look of the status widgets: one rounded capsule per widget with a
-- coloured SF Symbol on the left and a white value on the right.
--
--   ╭────────────╮
--   │ 􀫥  22%    │
--   ╰────────────╯
--
-- A widget made of one item gets the capsule as its own background
-- (capsule.item). A widget made of several items (network) draws the same
-- background around them with capsule.bracket.

local inner = settings.paddings.paddings - 1 -- capsule edge -> content
local gap = settings.paddings.container_paddings -- space between capsules

local capsule = {}

capsule.background = {
	color = colors.container.bg,
	height = settings.ui.container.height,
	border_color = colors.container.border_color,
	border_width = settings.ui.container.border_width,
	corner_radius = settings.ui.container.corner_radius,
	y_offset = settings.ui.container.y_offset,
}

function capsule.icon(glyph, color, extra)
	local icon = {
		string = glyph,
		color = color or colors.blue,
		font = settings.icon_font,
		padding_left = inner,
		padding_right = 5,
		align = "center",
	}
	for k, v in pairs(extra or {}) do
		icon[k] = v
	end
	return icon
end

function capsule.label(text, extra)
	local label = {
		string = text,
		font = settings.label_font,
		color = colors.white,
		padding_right = inner,
	}
	for k, v in pairs(extra or {}) do
		label[k] = v
	end
	return label
end

-- A single-item widget: icon + label inside its own capsule.
function capsule.item(name, props)
	props.position = props.position or "right"
	props.background = props.background or capsule.background
	props.padding_left = props.padding_left or gap
	props.padding_right = props.padding_right or 0
	return sbar.add("item", name, props)
end

-- A capsule drawn around several items that are already added.
function capsule.bracket(name, members)
	return sbar.add("bracket", name, members, { background = capsule.background })
end

capsule.gap = gap
capsule.inner = inner

return capsule
