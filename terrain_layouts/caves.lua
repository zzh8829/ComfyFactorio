--[[
Exchange Strings

>>>eNp1UT1oFEEUfi/nkcsJonBNwMQrUtjsES/aHOFmTCMp1M5+b
29OB/Z2ztldSLRwixQWQpo0pkmKNCZgJ2gXsVHQIGpjd5LGwiJBE
AvhnNnd2VvX5IN5fPO9/xmAC3AbYuxTgKhdOeMI201vRMmk6ojBg
ElLSJaXpxwZdpkluAqO6N7uLtGeKvNYf9Xq2D7TskqI5QqXwitWK
PuB8P5VAsmYnyRGba2eDaXt8bCf5EZZJODOwZ3X0dos6DN6BPXRS
B/Fhso/hBQqA5WWonTZEV4ghWv5LAi4d7dlhyutnmT3Q+Y5q61+6
AZ84HImKwuN+RgzxYy+4H4QStbqcNufsuYbzWs6zjo17sTyVxoLM
cqOy3s9gPp1dZb01oj4sPb8xrcHGwSTqRs0JUepst8xyrIht+ipr
jlDrubqJN1/5kjSNFAt0qgKHZPEuaadiMf3Dh+/+P2ljX+eHX+62
aEEj4yCOKkScCIzm081XplVwNQcktT1leCH9xo/CJZ1Rk2b7SfKR
M0JwPPnzLV+EcxobVOmRrEX45fZ5NCQz6S4h3qIRV18Vpu32sQNs
8kwoXSdIr1kvNPjEJXfhPwM3fGG70zbN7n+hUH+/4j8HgVljp7wD
VXdsJuZ76VsGvWeHyfNjW7REoyhvvvAetn9CzJb1cQ=<<<
]]
--local BuriedEnemies = require 'maps.mountain_fortress_v3.buried_enemies'
local Global = require 'utils.global'
local event = require 'utils.event'
require "player_modifiers"
require "modules.rocks_broken_paint_tiles"
require "modules.rocks_heal_over_time"
require "modules.rocks_yield_ore_veins"
require "modules.no_deconstruction_of_neutral_entities"
local MT = require "functions.basic_markets"
local Loot = require "maps.mountain_fortress_v3.loot"
local fuck = require 'functions.loot_raffle'
local get_noise = require "utils.get_noise"
local Player_modifiers = require "player_modifiers"
local math_random = math.random
local random = math.random
local math_floor = math.floor
local Token = require 'utils.token'
local math_abs = math.abs
local rege = require 'maps.mountain_fortress_v3.generate'
local asdasd = require 'modules.rpg.table'
local rock_raffle = {"sand-rock-big","sand-rock-big", "rock-big","rock-big","rock-big","rock-big","rock-big","rock-big","rock-big","rock-huge"}
local size_of_rock_raffle = #rock_raffle
local Pets = require 'maps.mountain_fortress_v3.biter_pets'
local Functions = require 'modules.rpg.functions'
--前置
local BiterRolls = require 'modules.wave_defense.biter_rolls'
local round = math.round
local Alert = require 'utils.alert'
local chests = {
    'wooden-chest',
    'iron-chest',
    'steel-chest',
    'crash-site-chest-1',
    'crash-site-chest-2',
    'crash-site-spaceship-wreck-big-1',
    'crash-site-spaceship-wreck-big-2',
    'crash-site-spaceship-wreck-medium-1',
    'crash-site-spaceship-wreck-medium-2',
    'crash-site-spaceship-wreck-medium-3'
}
local Public = {}
local size_chests = #chests

local treasure_chest_messages = {
    ({'entity.treasure_1'}),
    ({'entity.treasure_2'}),
    ({'entity.treasure_3'})
}

local rare_treasure_chest_messages = {
    ({'entity.treasure_rare_1'}),
    ({'entity.treasure_rare_2'}),
    ({'entity.treasure_rare_3'})
}

local disabled_threats = {
    ['entity-ghost'] = true,
    ['raw-fish'] = true
}

local defeated_messages = {
    ({'entity.defeated_1'}),
    ({'entity.defeated_2'}),
    ({'entity.defeated_3'}),
    ({'entity.defeated_4'})
}

local protect_types = {
    ['cargo-wagon'] = true,
    ['artillery-wagon'] = true,
    ['fluid-wagon'] = true,
    ['locomotive'] = true,
    ['reactor'] = true,
    ['car'] = true,
    ['spidertron'] = true
}

local function place_entity(surface, position)
	if math_random(1, 3) ~= 1 then
		surface.create_entity({name = rock_raffle[math_random(1, size_of_rock_raffle)], position = position, force = "neutral"})
	end
end

local function is_scrap_area(noise)
	if noise > 0.67 then return end
	if noise < -0.67 then return end
	if noise > 0.32 then return true end	
	if noise < -0.32 then return true end
end

local function move_away_things(surface, area)
	for _, e in pairs(surface.find_entities_filtered({type = {"unit-spawner", "turret", "unit", "tree"}, area = area})) do
		local position = surface.find_non_colliding_position(e.name, e.position, 128, 4)
		if position then 
			surface.create_entity({name = e.name, position = position, force = "enemy"})
			e.destroy()
		end
	end
end

local vectors = {{0,0}, {1,0}, {-1,0}, {0,1}, {0,-1}}


--我添加的代码


local function get_random_weighted(weighted_table, item_index, weight_index)
    local total_weight = 0
    item_index = item_index or 1
    weight_index = weight_index or 2
    for _, w in pairs(weighted_table) do
        total_weight = total_weight + w[weight_index]
    end
    local index = random() * total_weight
    local weight_sum = 0
    for _, w in pairs(weighted_table) do
        weight_sum = weight_sum + w[weight_index]
        if weight_sum >= index then
            return w[item_index]
        end
    end
end
local function on_entity_died(event)	
	if not event.entity.valid then return end
	on_player_mined_entity(event)
end
local function on_chunk_generated(event)	
	local surface = event.surface
	local seed = surface.map_gen_settings.seed
	local left_top_x = event.area.left_top.x
	local left_top_y = event.area.left_top.y
	local set_tiles = surface.set_tiles
	local get_tile = surface.get_tile
	local position
	local noise
	for x = 0, 31, 1 do
		for y = 0, 31, 1 do			
			position = {x = left_top_x + x, y = left_top_y + y}				
			if not get_tile(position).collides_with("resource-layer") then 
				noise = get_noise("scrapyard", position, seed)
				if is_scrap_area(noise) then
					set_tiles({{name = "dirt-" .. math_floor(math_abs(noise) * 12) % 4 + 3, position = position}}, true)
					--创建其他的逻辑
					if x+y > 33 and x+y < 40 then
					local b = math_random(1,200)
					--宝藏
					if b < 3 then 
					local chest = 'iron-chest'
					Loot.add(surface, position, chest)
					end
					--中立建筑

    
    
					
					--在我上面添加代码
					end
					
					
					
					--创建商店逻辑
					if y == 1 then 
					if x == 1 then 
					 local a = math_random(1,8)
					 if a == 1 then 
					 MT.mountain_market(surface,position,math_random(10,80))
					end
					end
					end
					place_entity(surface, position)
				end
			end		
			end
		
	end

	move_away_things(surface, event.area)
end
local function hidden_treasure(player, entity)
	local rpg = asdasd.get('rpg_t')
    local magic = rpg[player.index].magicka
    
       local msg = rare_treasure_chest_messages[random(1, #rare_treasure_chest_messages)]
       Alert.alert_player(player, 5, msg)
        Loot.add_rare(entity.surface, entity.position, 'wooden-chest', magic)
       game.print('23')
 --   local msg = treasure_chest_messages[random(1, #treasure_chest_messages)]
 --   Alert.alert_player(player, 5, msg, nil, nil, 0.3)
   -- Loot.add(entity.surface, entity.position, chests[random(1, size_chests)])
	game.print('24')
end
local function hidden_biter_pet(player, entity)
    if random(1, 1024) ~= 1 then
        return
    end

    local pos = entity.position

    BiterRolls.wave_defense_set_unit_raffle(sqrt(pos.x ^ 2 + pos.y ^ 2) * 0.25)
    local unit
    if random(1, 3) == 1 then
        unit = entity.surface.create_entity({name = BiterRolls.wave_defense_roll_spitter_name(), position = pos})
    else
        unit = entity.surface.create_entity({name = BiterRolls.wave_defense_roll_biter_name(), position = pos})
    end
    Pets.biter_pets_tame_unit(game.players[player.index], unit, true)
end
local function on_player_joined_game(event)
	local player = game.players[event.player_index]
	local modifiers = Player_modifiers.get_table()	
	--modifiers[player.index].character_mining_speed_modifier["caves"] = 3
	Player_modifiers.update_player_modifiers(player)
end
function Public.unstuck_player(index)
    local player = game.get_player(index)
    local surface = player.surface
    local position = surface.find_non_colliding_position('character', player.position, 32, 0.5)
    if not position then
        return
    end
    player.teleport(position, surface)
end
local function on_init()
	global.rocks_yield_ore_maximum_amount = 999
	global.rocks_yield_ore_base_amount = 100
	global.rocks_yield_ore_distance_modifier = 0.025
end
local mining_events = {
    {
        function()
        end,
        300000,
        'Nothing'
    },
    {
        function()
        end,
        16384,
        'Nothing'
    },
    {
        function()
        end,
        4096,
        'Nothing'
    },
    {
        function(entity)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            BuriedEnemies.buried_biter(entity.surface, entity.position, 1)
            entity.destroy()
        end,
        4096,
        'Angry Biter #2'
    },
    {
        function(entity)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            BuriedEnemies.buried_biter(entity.surface, entity.position)
            entity.destroy()
        end,
        512,
        'Angry Biter #2'
    },
    {
        function(entity)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            BuriedEnemies.buried_worm(entity.surface, entity.position)
            entity.destroy()
        end,
        2048,
        'Angry Worm'
    },
    {
        function(entity)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            Traps(entity.surface, entity.position)
            entity.destroy()
        end,
        2048,
        'Dangerous Trap'
    },
    {
        function(entity, index)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            local player = game.get_player(index)

            if entity.type == 'tree' then
                angry_tree(entity, player.character, player)
                entity.destroy()
            end
        end,
        1024,
        'Angry Tree'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        1024,
        'Treasure_Tier_1'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        512,
        'Treasure_Tier_2'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        256,
        'Treasure_Tier_3'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        128,
        'Treasure_Tier_4'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        64,
        'Treasure_Tier_5'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        32,
        'Treasure_Tier_6'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            hidden_treasure(player, entity)
        end,
        16,
        'Treasure_Tier_7'
    },
    {
        function(entity, index)
            local player = game.get_player(index)
            Public.unstuck_player(index)
            hidden_biter_pet(player, entity)
        end,
        256,
        'Pet'
    },
    {
        function(entity, index)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            local position = entity.position
            local surface = entity.surface
            surface.create_entity({name = 'biter-spawner', position = position, force = 'enemy'})
            Public.unstuck_player(index)
        end,
        512,
        'Nest'
    },
    {
        function(entity)
            local position = entity.position
            local surface = entity.surface
            surface.create_entity({name = 'compilatron', position = position, force = 'player'})
        end,
        64,
        'Friendly Compilatron'
    },
    {
        function(entity)
            if Locomotive.is_around_train(entity) then
                entity.destroy()
                return
            end

            local position = entity.position
            local surface = entity.surface
            surface.create_entity({name = 'compilatron', position = position, force = 'enemy'})
        end,
        128,
        'Enemy Compilatron'
    },
    {
        function(entity, index)
            local position = entity.position
            local surface = entity.surface
            surface.create_entity({name = 'car', position = position, force = 'player'})
            Public.unstuck_player(index)
            local player = game.players[index]
            local msg = ({'entity.found_car', player.name})
            Alert.alert_player(player, 15, msg)
        end,
        32,
        'Car'
    }
}
local function on_player_mined_entity(event)
local player = game.players[event.player_index]
     local rpg = asdasd.get('rpg_t')
    local rpg_char = rpg[player.index]
	local entity = event.entity
	if not entity.valid then return end
	if entity.type ~= "simple-entity" then return end
	local surface = entity.surface
	for _, v in pairs(vectors) do
		local position = {entity.position.x + v[1], entity.position.y + v[2]}
		if not surface.get_tile(position).collides_with("resource-layer") then 
			surface.set_tiles({{name = "landfill", position = position}}, true)
		end
	end
	if event.player_index then game.players[event.player_index].insert({name = "coin", count = 1}) end
	
	
	--我添加的代码
	if rpg_char.stone_path then
          
		  entity.surface.set_tiles({{name = 'stone-path', position = entity.position}}, true)
        end
		--宝藏
		if random(1,170)  < 3 then 
	hidden_treasure(player,entity)
	end 
	--虫子宠物,暂时不可用
	if random(1,150) < 2 then
	local position = {entity.position.x , entity.position.y }
	surface.create_entity({name = 'small-biter', position = position, force = 'player'})
	end
	if random(1,140) < 2 then
    local position = {entity.position.x , entity.position.y }
	local player = game.players[event.player_index]
	surface.create_entity({name = 'biter-spawner', position = position, force = 'enemy'})
	Public.unstuck_player(player.index)
	end 
	if random(1,100) < 3 then
	local position = {entity.position.x , entity.position.y }
	surface.create_entity({name = 'small-biter', position = position, force = 'enemy'})
	end 
	if random(1,512) < 2 then 
	local position = {entity.position.x , entity.position.y }
	local player = game.players[event.player_index]
	surface.create_entity({name = 'car', position = position, force = 'player'})
           Public.unstuck_player(player.index)
           local msg = ({'found a car', 'you'})
            Alert.alert_player(player, 15, msg)
    end
	
end
local Event = require 'utils.event'
Event.on_init(on_init)
Event.add(defines.events.on_chunk_generated, on_chunk_generated)
Event.add(defines.events.on_player_joined_game, on_player_joined_game)
Event.add(defines.events.on_player_mined_entity, on_player_mined_entity)
Event.add(defines.events.on_entity_died, on_entity_died)

require "modules.rocks_yield_ore"