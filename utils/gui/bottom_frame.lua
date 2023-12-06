local Event = require 'utils.event'
local Global = require 'utils.global'
local Gui = require 'utils.gui'
local Task = require 'utils.task_token'
local Server = require 'utils.server'
local try_get_data = Server.try_get_data
local set_data = Server.set_data

local this = {
    players = {},
    storage = {},
    activate_custom_buttons = false,
    bottom_quickbar_button = {},
    bottom_quickbar_button_data = {}
}

Global.register(
    this,
    function(t)
        this = t
    end
)

local Public = {
    events = {
        bottom_quickbar_respawn_raise = Event.generate_event_name('bottom_quickbar_respawn_raise'),
        bottom_quickbar_location_changed = Event.generate_event_name('bottom_quickbar_location_changed')
    }
}

local set_location
local get_player_data
local bottom_dataset = 'bottom_frame_data'

local main_frame_name = Gui.uid_name()

local sections = {
    [1] = 1,
    [2] = 1,
    [3] = 2,
    [4] = 2,
    [5] = 3,
    [6] = 3,
    [7] = 4,
    [8] = 4,
    [9] = 5,
    [10] = 5,
    [11] = 6,
    [12] = 6
}

local restore_bottom_location_token =
    Task.register(
    function(event)
        local player_index = event.player_index
        local player = game.get_player(player_index)
        if not player or not player.valid then
            return
        end

        local state = event.state
        if not state then
            return
        end

        local bottom_right = event.bottom_right or 'bottom_right'
        local above = event.above or false

        local data = get_player_data(player)

        data.bottom_right = bottom_right
        data.above = above
        data.state = state

        set_location(player, state)
    end
)

local function remove_player(index)
    this.players[index] = nil
    this.storage[index] = nil
    this.bottom_quickbar_button[index] = nil
end

get_player_data = function(player, remove_user_data)
    if remove_user_data then
        this.players[player.index] = nil
        this.storage[player.index] = nil
        return
    end
    if not this.players[player.index] then
        this.players[player.index] = {
            state = 'bottom_right',
            section = {},
            direction = 'vertical',
            row_index = 1,
            row_selection = 1,
            row_selection_added = 1
        }
        this.storage[player.index] = {}
    end
    return this.players[player.index], this.storage[player.index]
end

--- Refreshes all inner frames for a given player
local function refresh_inner_frames(player)
    if not player or not player.valid then
        return
    end
    local player_data, storage_data = get_player_data(player)
    if not player_data or not storage_data or not player_data.frame or not player_data.frame.valid then
        return
    end

    local main_frame = player_data.frame

    local horizontal_flow = main_frame.add {type = 'flow', direction = 'horizontal'}
    horizontal_flow.style.horizontal_spacing = 0

    for row_index, row_index_data in pairs(storage_data) do
        if row_index_data and type(row_index_data) == 'table' then
            local section_row_index = player_data.section[row_index]
            local vertical_flow = horizontal_flow.add {type = 'flow', direction = 'vertical'}
            vertical_flow.style = 'shortcut_bar_column'

            if not section_row_index then
                player_data.section[row_index] = {}
                section_row_index = player_data.section[row_index]
            end

            if not section_row_index.inside_frame or not section_row_index.inside_frame.valid then
                section_row_index.inner_frame = vertical_flow
            end

            for row_selection, row_selection_data in pairs(row_index_data) do
                if section_row_index[row_selection] and section_row_index[row_selection].valid then
                    section_row_index[row_selection].destroy()
                end

                section_row_index[row_selection] =
                    section_row_index.inner_frame.add {
                    type = 'sprite-button',
                    sprite = row_selection_data.sprite,
                    name = row_selection_data.name,
                    tooltip = row_selection_data.tooltip or '',
                    style = 'quick_bar_page_button'
                }
            end
        end
    end
end

---Adds a new inner frame to the bottom frame
-- local BottomFrame = require 'utils.gui.bottom_frame'
-- BottomFrame.add_inner_frame({player = player, element_name = Gui.uid_name(), tooltip = 'Some tooltip', sprite = 'item/raw-fish' })
---@param data any
local function add_inner_frame(data)
    if not data then
        return
    end
    local player = data.player
    local element_name = data.element_name
    local tooltip = data.tooltip
    local sprite = data.sprite
    if not player or not player.valid then
        return error('Given player was not valid', 2)
    end
    if not element_name then -- the element_name to pick from the row_selection
        return error('Element name is missing', 2)
    end
    if not sprite then
        return error('Sprite is missing', 2)
    end

    local player_data, storage_data = get_player_data(player)
    if not player_data or not storage_data or not player_data.frame or not player_data.frame.valid then
        return
    end

    if player_data.row_index > 6 then
        return error('Having more than 6 rows is currently not supported.', 2)
    end

    player_data.row_index = sections[player_data.row_selection_added]

    if not storage_data[player_data.row_index] then
        storage_data[player_data.row_index] = {}
    end

    local storage_data_section = storage_data[player_data.row_index]
    storage_data_section[player_data.row_selection] = {
        name = element_name,
        sprite = sprite,
        tooltip = tooltip
    }

    player_data.row_selection = player_data.row_selection + 1
    player_data.row_selection_added = player_data.row_selection_added + 1
    player_data.row_selection = player_data.row_selection > 2 and 1 or player_data.row_selection
end

local function destroy_frame(player)
    local gui = player.gui
    local frame = gui.screen[main_frame_name]
    if frame and frame.valid then
        frame.destroy()
    end
end

--- Creates a new frame
---@param player LuaPlayer
---@param alignment string
---@param location table
---@param data any
---@return unknown
local function create_frame(player, alignment, location, data)
    local gui = player.gui
    local frame = gui.screen[main_frame_name]
    if frame and frame.valid then
        destroy_frame(player)
    end

    alignment = alignment or 'vertical'

    frame =
        player.gui.screen.add {
        type = 'frame',
        name = main_frame_name,
        direction = alignment
    }

    if data.visible ~= nil then
        if data.visible then
            frame.visible = true
        else
            frame.visible = false
        end
    end

    frame.style.padding = 3
    frame.style.top_padding = 4
    if alignment == 'vertical' then
        frame.style.minimal_height = 96
    end

    local inner_frame =
        frame.add {
        type = 'frame',
        direction = alignment
    }
    inner_frame.style = 'quick_bar_inner_panel'

    frame.location = location
    if data.portable then
        frame.caption = '•'
    end

    if data.top then
        frame.visible = false
    else
        frame.visible = true
    end

    data.frame = inner_frame
    data.parent = frame
    data.section = data.section or {}
    data.section_data = data.section_data or {}
    data.alignment = alignment

    return frame
end

set_location = function(player, state)
    local data = get_player_data(player)
    local alignment = 'vertical'

    local location
    local resolution = player.display_resolution
    local scale = player.display_scale

    state = state or data.state

    if state == 'bottom_left' then
        if data.above then
            location = {
                x = (resolution.width / 2) - ((259) * scale),
                y = (resolution.height - (-12 + (40 * 5) * scale))
            }
            alignment = 'horizontal'
        else
            location = {
                -- x = (resolution.width / 2) - ((54 + 528 - 44) * scale),
                x = (resolution.width / 2) - ((455 + (data.row_index * 40)) * scale),
                y = (resolution.height - (96 * scale))
            }
        end
        data.bottom_state = 'bottom_left'
    elseif state == 'bottom_right' then
        if data.above then
            location = {
                -- x = (resolution.width / 2) - ((-262 - (40 * t[data.row_index])) * scale),
                x = (resolution.width / 2) - ((-460 + (data.row_index * 40)) * scale),
                y = (resolution.height - (-12 + (40 * 5) * scale))
            }
            alignment = 'horizontal'
        else
            location = {
                x = (resolution.width / 2) - ((54 + -528) * scale),
                y = (resolution.height - (96 * scale))
            }
        end
        data.bottom_state = 'bottom_right'
    else
        location = {
            x = (resolution.width / 2) - ((54 + -528) * scale),
            y = (resolution.height - (96 * scale))
        }
    end

    Event.raise(Public.events.bottom_quickbar_location_changed, {player_index = player.index, data = data})

    data.state = state

    local secs = Server.get_current_time()
    if secs ~= nil then
        set_data(
            bottom_dataset,
            player.name,
            {
                bottom_state = data.bottom_state,
                above = data.above,
                state = data.state
            }
        )
    end

    create_frame(player, alignment, location, data)
    refresh_inner_frames(player)
end

--- Sets then frame location of the given player
---@param player LuaPlayer?
---@param value boolean
local function set_top(player, value)
    local data = get_player_data(player)
    data.top = value or false
    Public.set_location(player, 'bottom_right')
end

--- Returns the current frame location of the given player
---@param player LuaPlayer
---@return table|nil
local function get_location(player)
    local data = get_player_data(player)
    return data and data.state or nil
end

--- Activates the custom buttons
---@param value boolean
function Public.activate_custom_buttons(value)
    this.activate_custom_buttons = value or false
end

--- Fetches if the custom buttons are activated
function Public.is_custom_buttons_enabled()
    return this.activate_custom_buttons
end

--- Toggles the player frame
function Public.toggle_player_frame(player, state)
    local gui = player.gui
    local frame = gui.screen[main_frame_name]
    if frame and frame.valid then
        local data = get_player_data(player)
        if state then
            data.visible = true
            frame.visible = true
        else
            data.visible = false
            frame.visible = false
        end
    end
end

function Public.get(key)
    if key then
        return this[key]
    else
        return this
    end
end

function Public.set(key, value)
    if key and (value or value == false) then
        this[key] = value
        return this[key]
    elseif key then
        return this[key]
    else
        return this
    end
end

function Public.reset()
    local players = game.players
    for i = 1, #players do
        local player = players[i]
        if player and player.valid then
            if not player.connected then
                this.players[player.index] = nil
            end
        end
    end
end

Event.add(
    defines.events.on_player_joined_game,
    function(event)
        if this.activate_custom_buttons then
            local player = game.get_player(event.player_index)
            local data = get_player_data(player)
            set_location(player, data.state)
        end
    end
)

Event.add(
    defines.events.on_player_display_resolution_changed,
    function(event)
        if this.activate_custom_buttons then
            local player = game.get_player(event.player_index)
            local data = get_player_data(player)
            set_location(player, data.state)
        end
    end
)

Event.add(
    defines.events.on_player_display_scale_changed,
    function(event)
        local player = game.get_player(event.player_index)
        if this.activate_custom_buttons then
            local data = get_player_data(player)
            set_location(player, data.state)
        end
    end
)

Event.add(
    defines.events.on_pre_player_left_game,
    function(event)
        local player = game.get_player(event.player_index)
        destroy_frame(player)
    end
)

Event.add(
    defines.events.on_pre_player_died,
    function(event)
        if this.activate_custom_buttons then
            local player = game.get_player(event.player_index)
            destroy_frame(player)
        end
    end
)

Event.add(
    defines.events.on_player_respawned,
    function(event)
        if this.activate_custom_buttons then
            local player = game.get_player(event.player_index)
            local data = get_player_data(player)
            set_location(player, data.state)
        end
    end
)

Event.add(
    defines.events.on_player_removed,
    function(event)
        remove_player(event.player_index)
    end
)

Event.add(
    Public.events.bottom_quickbar_respawn_raise,
    function(event)
        if not event or not event.player_index then
            return
        end

        if this.activate_custom_buttons then
            local player = game.get_player(event.player_index)
            local data = get_player_data(player)
            set_location(player, data.state)
            local secs = Server.get_current_time()
            if secs ~= nil then
                try_get_data(bottom_dataset, bottom_dataset.index, restore_bottom_location_token)
            end
        end
    end
)

Event.add(
    Public.events.bottom_quickbar_location_changed,
    function(event)
        if not event or not event.player_index then
            return
        end

        if this.activate_custom_buttons then
            local player = game.get_player(event.player_index)
            local data = get_player_data(player)
            if data.frame and data.frame.valid then
                if data.top then
                    data.frame.visible = false
                else
                    data.frame.visible = true
                end
            end
        end
    end
)

Public.main_frame_name = main_frame_name
Public.get_player_data = get_player_data
Public.remove_player = remove_player
Public.set_location = set_location
Public.get_location = get_location
Public.set_top = set_top
Public.add_inner_frame = add_inner_frame
Gui.screen_to_bypass(main_frame_name)

return Public
