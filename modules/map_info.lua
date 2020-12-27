local Global = require 'utils.global'
local Tabs = require 'comfy_panel.main'

local map_info = {
    localised_category = false,
    main_caption = '山地保卫战',
    main_caption_color = {r = 0.6, g = 0.3, b = 0.99},
    sub_caption = '0.8版本，2020.12.26',
    sub_caption_color = {r = 0.2, g = 0.9, b = 0.2},
    text = '本图难度较大。\n保护好火箭发射井！ \n\n请迅速开发矿区，建造产线，建立防线，抵御虫子进攻。  \n\n如果有余力可以到野外，找找有没有有用的东西。\n建议按以下配置进行游戏： \n虫巢密度400%，大小200%，进化时间因子调为三分之一，其他拉满，部队派出规模拉满，部队冷却时间拉到最小，污染扩散25%\n如果觉得太难，也可以适度下调。 \n\n地图特性：随机商店，载具内部空间，RPG系统，特殊地形，运气挖矿 .软重启前务必先回收载具！。 \n你可以在场景中找到这个地图!\n 地图制作人：itam QQ群号:701077913'
}

Global.register(
    map_info,
    function(tbl)
        map_info = tbl
    end
)

local Public = {}

function Public.Pop_info()
    return map_info
end

local create_map_intro = (function(player, frame)
    frame.clear()
    frame.style.padding = 4
    frame.style.margin = 0

    local t = frame.add {type = 'table', column_count = 1}

    local line = t.add {type = 'line'}
    line.style.top_margin = 4
    line.style.bottom_margin = 4

    local caption = map_info.main_caption or {map_info.localised_category .. '.map_info_main_caption'}
    local sub_caption = map_info.sub_caption or {map_info.localised_category .. '.map_info_sub_caption'}
    local text = map_info.text or {map_info.localised_category .. '.map_info_text'}

    if map_info.localised_category then
        map_info.main_caption = caption
        map_info.sub_caption = sub_caption
        map_info.text = text
    end
    local l = t.add {type = 'label', caption = map_info.main_caption}
    l.style.font = 'heading-1'
    l.style.font_color = map_info.main_caption_color
    l.style.minimal_width = 780
    l.style.horizontal_align = 'center'
    l.style.vertical_align = 'center'

    local l_2 = t.add {type = 'label', caption = map_info.sub_caption}
    l_2.style.font = 'heading-2'
    l_2.style.font_color = map_info.sub_caption_color
    l_2.style.minimal_width = 780
    l_2.style.horizontal_align = 'center'
    l_2.style.vertical_align = 'center'

    local line_2 = t.add {type = 'line'}
    line_2.style.top_margin = 4
    line_2.style.bottom_margin = 4

    local scroll_pane =
        frame.add {
        type = 'scroll-pane',
        name = 'scroll_pane',
        direction = 'vertical',
        horizontal_scroll_policy = 'never',
        vertical_scroll_policy = 'auto'
    }
    scroll_pane.style.maximal_height = 320
    scroll_pane.style.minimal_height = 320

    local l_3 = scroll_pane.add {type = 'label', caption = map_info.text}
    l_3.style.font = 'heading-2'
    l_3.style.single_line = false
    l_3.style.font_color = {r = 0.85, g = 0.85, b = 0.88}
    l_3.style.minimal_width = 780
    l_3.style.horizontal_align = 'center'
    l_3.style.vertical_align = 'center'

    local b = frame.add {type = 'button', caption = 'CLOSE', name = 'close_map_intro'}
    b.style.font = 'heading-2'
    b.style.padding = 2
    b.style.top_margin = 3
    b.style.left_margin = 333
    b.style.horizontal_align = 'center'
    b.style.vertical_align = 'center'
end)

local function on_player_joined_game(event)
    local player = game.players[event.player_index]
    if player.online_time == 0 then
        Tabs.comfy_panel_call_tab(player, 'Map Info')
    end
end

local function on_gui_click(event)
    if not event then
        return
    end
    if not event.element then
        return
    end
    if not event.element.valid then
        return
    end
    if event.element.name == 'close_map_intro' then
        game.players[event.player_index].gui.left.comfy_panel.destroy()
        return
    end
end

comfy_panel_tabs['Map Info'] = {gui = create_map_intro, admin = false}

local event = require 'utils.event'
event.add(defines.events.on_player_joined_game, on_player_joined_game)
event.add(defines.events.on_gui_click, on_gui_click)

return Public
