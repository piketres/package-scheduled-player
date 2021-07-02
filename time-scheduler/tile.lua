local api, CHILDS, CONTENTS = ...

local json = require "json"

local font
local color
local speed

local M = {}

-- { source: { text1, text2, text3, ...} }
local content = {__myself__ = {}}

local items = {}
local current_left = 0
local last = sys.now()

function M.updated_config_json(config)
    font = resource.load_font(api.localized(config.font.asset_name))
    color = config.color
    speed = config.speed

    content.__myself__ = {}
    local items = content.__myself__
    for idx = 1, #config.texts do
        local item = config.texts[idx]
        local color
        if item.color.a ~= 0 then
            color = item.color
        end

        -- 'show' either absent or true?
        if item.show ~= false then
            items[#items+1] = {
                text = item.text,
                blink = item.blink,
                color = color,
            }
        end
    end
    print("configured scroller content")
    pp(items)
end

function draw_schedule(x, y, w, h)
  font:write(0, 0, "Pas des cours prevus", 50, 1,1,1,1)
end

function M.task(starts, ends, config, x1, y1, x2, y2)
    for now in api.frame_between(starts, ends) do
        api.screen.set_scissor(x1, y1, x2, y2)
        draw_schedule(x1, y1, x2-x1, y2-y1)
        api.screen.set_scissor()
    end
end

return M
