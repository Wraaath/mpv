local assdraw = require 'mp.assdraw'
local options = require 'mp.options'

local o = {
    arrow_size = 100,
    arrow_opacity = 0.5,
}

options.read_options(o, "pause-indicator")

local function draw_arrow()
    local w, h = mp.get_osd_size()

    local x1 = w / 2 - o.arrow_size / 2
    local y1 = h / 2 - o.arrow_size / 2
    local x2 = w / 2 + o.arrow_size / 2
    local y2 = h / 2 + o.arrow_size / 2

    local ass = assdraw.ass_new()

    ass:new_event()
    ass:pos(0, 0)
    ass:append(string.format("{\\alpha&H%02X&}", math.floor(o.arrow_opacity * 255)))
    ass:append("{\\1c&HFFFFFF&}")
    ass:draw_start()
    ass:move_to(x1, y1)
    ass:line_to(x2, h / 2)
    ass:line_to(x1, y2)
    ass:line_to(x1, y1)
    ass:draw_stop()

    mp.set_osd_ass(w, h, ass.text)
end

local function clear_arrow()
    mp.set_osd_ass(0, 0, "")
end

local function update_display()
    if mp.get_property_bool("pause") then
        draw_arrow()
    else
        clear_arrow()
    end
end

mp.observe_property("pause", "bool", update_display)
mp.observe_property("osd-dimensions", nil, update_display)
mp.register_event("file-loaded", update_display)
mp.register_event("end-file", clear_arrow)
