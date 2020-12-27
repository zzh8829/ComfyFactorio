require 'utils.data_stages'
_LIFECYCLE = _STAGE.control -- Control stage
_DEBUG = false
_DUMP_ENV = false
local Global = require 'utils.global'
local WD = require 'modules.wave_defense.table'
	local wave_defense_table = WD.get_table()
require 'utils.server'
require 'utils.server_commands'
require 'utils.utils'
require 'utils.table'
require 'utils.freeplay'
require 'utils.datastore.server_ups'
require 'utils.datastore.color_data'
require 'utils.datastore.session_data'
require 'utils.datastore.jail_data'
require 'utils.datastore.quickbar_data'
require 'utils.datastore.message_on_join_data'
require 'utils.datastore.player_tag_data'
require 'chatbot'
require 'commands'
require 'antigrief'
require 'modules.corpse_markers'
require 'modules.floaty_chat'
require 'modules.show_inventory'
require 'utils.debug.command'

require 'comfy_panel.main'
require 'comfy_panel.player_list'
require 'comfy_panel.admin'
require 'comfy_panel.group'
require 'comfy_panel.poll'
require 'comfy_panel.score'
require 'comfy_panel.config'

require 'modules.autostash'

require'mafan'

---------------- !ENABLE MODULES HERE ----------------
--require 'modules.admins_operate_biters'
--require 'modules.the_floor_is_lava'
--require 'modules.biters_landfill_on_death'
--require 'modules.autodecon_when_depleted'
--require 'modules.biter_noms_you'
--require 'modules.biters_avoid_damage'
--require 'modules.biters_double_damage'
require 'modules.burden'
--require 'modules.comfylatron'
--require 'modules.dangerous_goods'
--require 'modules.explosive_biters'
--require 'modules.explosive_player_respawn'
--require 'modules.explosives_are_explosive'
require 'modules.fish_respawner'
--require 'modules.fluids_are_explosive'
--require 'modules.hunger'
--require 'modules.hunger_games'
require 'modules.pistol_buffs'
--require 'modules.players_trample_paths'
--require 'modules.railgun_enhancer'
--require 'modules.restrictive_fluid_mining'
--require 'modules.satellite_score'
require 'modules.show_health'
require 'modules.splice_double'
--require 'modules.ores_are_mixed'
--require 'modules.team_teleport'
--require 'modules.surrounded_by_worms'
--require 'modules.no_blueprint_library'
--require 'modules.explosives'
require 'modules.biter_pets'
--require 'modules.no_solar'
--require 'modules.biter_reanimator'
--require 'modules.force_health_booster'
--require 'modules.immersive_cargo_wagons.main'

--require 'modules.fjei.main'
require 'modules.charging_station'
--require 'modules.nuclear_landmines'
--require 'modules.crawl_into_pipes'
--require 'modules.no_acid_puddles'
--require 'modules.simple_tags'
---------------------------------------------------------------

---------------- ENABLE MAPS HERE ----------------
--!Make sure only one map is enabled at a time.
--!Remove the "--" in front of the line to enable.
--!All lines with the "require" keyword are different maps.

--![[North VS South Survival PVP, feed the opposing team's biters with science flasks. Disable Autostash, Group and Poll modules.]]--
--require 'maps.biter_battles_v2.main'
--require 'maps.biter_battles.biter_battles'

--![[Guide a Train through rough terrain, while defending it from the biters]]--
--require 'maps.mountain_fortress_v3.main'
--require 'maps.mountain_fortress_v2.main'
--require 'maps.mountain_fortress'

--![[Defend the market against waves of biters]]--
--require 'maps.fish_defender_v2.main'
--require 'maps.crab_defender.main'
--require 'maps.fish_defender_v1.fish_defender'
--require 'maps.fish_defender.main'

--![[Comfylatron has seized the Fish Train and turned it into a time machine]]--
--require 'maps.chronosphere.main'

--![[East VS West Survival PVP, where you breed biters with science flasks]]--
--require 'maps.biter_hatchery.main'

--![[Chop trees to gain resources]]--
--require 'maps.choppy'
--require 'maps.choppy_dx'

--![[Infinite random dungeon with RPG]]--
--require 'maps.dungeons.main'
--require 'maps.dungeons.tiered_dungeon'

--![[Randomly generating Islands that have to be beaten in levels to gain credits]]--
--require 'maps.island_troopers.main'

--![[Infinitely expanding mazes]]--
--require 'maps.stone_maze.main'
--require 'maps.labyrinth'

--![[Extreme survival mode with thirst and limited building room]]--
--require 'maps.desert_oasis'

--![[The trees are your enemy here]]--
--require 'maps.overgrowth'

--![[Wave Defense Map split in 4 Quarters]]--
--'maps.quarters'

--![[Flee from the collapsing map with portable base inside train]]--
--require 'maps.railway_troopers_v2.main'

--![[Another simliar version without collapsing terrain]]--
--require 'maps.railway_troopers.main'

--![[You fell in a dark cave, will you survive?]]--
--require 'maps.cave_miner'
--require 'maps.cave_choppy.cave_miner'
--require 'maps.cave_miner_v2.main'

--![[Hungry boxes eat your items, but reward you with new territory to build.]]--
--require 'maps.expanse.main'

--![[Crashlanding on Junk Planet]]--
--require 'maps.junkyard'
--require 'maps.territorial_control'
--require 'maps.junkyard_pvp.main'

--![[A green maze]]--
--require 'maps.hedge_maze'

--![[Dangerous forest with unique map revealing]]--
--require 'maps.spooky_forest'

--![[Defeat the biters and unlock new areas]]--
--require 'maps.spiral_troopers'

--![[Railworld style terrains]]--
--require 'maps.mixed_railworld'
--require 'maps.scrap_railworld'

--![[It's tetris!]]--
--require 'maps.tetris.main'

--![[4 Team Lane Surival]]--
--require 'maps.wave_of_death.WoD'

--![[PVP Battles with Tanks]]--
--require 'maps.tank_conquest.tank_conquest'
--require 'maps.tank_battles'

--![[Terrain with lots of Rocks]]--
--require 'maps.rocky_waste'

--![[Landfill is reveals the map, set resources to high when rolling the map]]--
--require 'maps.lost'

--![[A terrain layout with many rivers]]--
--require 'maps.rivers'

--![[Islands Theme]]--
--require 'maps.atoll'

--![[Placed buildings can hardly be removed]]--
--require 'maps.refactor-io'

--![[Prebuilt buildings on the map that can not be removed, you will hate this map]]--
--require 'maps.spaghettorio'

--![[Misc / WIP]]--
--require 'maps.rainbow_road'
--require 'maps.deep_jungle'
--require 'maps.cratewood_forest'
--require 'maps.maze_challenge'
--require 'maps.lost_desert'
--require 'maps.stoneblock'
--require 'maps.wave_defense'
--require 'maps.crossing'
--require 'maps.anarchy'
--require 'maps.planet_prison'
--require 'maps.blue_beach'
--require 'maps.nightfall'
--require 'maps.pitch_black.main'
--require 'maps.cube'
--require 'maps.mountain_race.main'
--require 'maps.native_war.main'
---------------------------------------------------------------

---------------- MORE MODULES HERE ----------------
--require 'modules.hidden_dimension.main'
--require 'modules.towny.main'
require 'modules.rpg.main'
--require 'modules.rpg'
--require 'modules.trees_grow'
--require 'modules.trees_randomly_die'
---------------------------------------------------------------

---------------- MOSTLY TERRAIN LAYOUTS HERE ----------------
require 'terrain_layouts.caves'
--require 'terrain_layouts.cone_to_east'
--require 'terrain_layouts.biters_and_resources_east'
--require 'terrain_layouts.scrap_01'
--require 'terrain_layouts.watery_world'
--require 'terrain_layouts.tree_01'
--------------------------------------------------------------
---我添加的----
require 'modules.wave_defense.main'
require 'modules.rocks_yield_ore_veins'
require 'modules.shotgun_buff'
require "modules.spawners_contain_biters"
require "modules.mineable_wreckage_yields_scrap"
require 'modules.ic.main'
--require 'modules.icw.main'
require 'modules.no_deconstruction_of_neutral_entities'
require 'modules.biters_yield_coins'
local aaa = require 'controll'
require 'modules.map_info'
--我的代码--
global.rocket_silo = {}
local created_items = function()
  return
  {
  --  ["car"] = 1,
--	["cargo-wagon"] = 1,
--	["rail"] = 100
    ["iron-plate"] = 8,
    ["wood"] = 1,
    ["pistol"] = 1,
    ["firearm-magazine"] = 10,
    ["burner-mining-drill"] = 1,
    ["stone-furnace"] = 1
  }
end
global.created_items = created_items()
---结束
if _DUMP_ENV then
    require 'utils.dump_env'
end

local function on_player_created(event)
    local player = game.players[event.player_index]
	local surface = game.players[event.player_index].surface
	util.insert_safe(player, global.created_items)
    player.gui.top.style = 'slot_table_spacing_horizontal_flow'
    player.gui.left.style = 'slot_table_spacing_vertical_flow'
	--local wtmd = require 'modules.rpg.table'

	
	global.rocket_silo=surface.create_entity{name = "rocket-silo", position = {0, 10}, force=game.forces.player}
	global.rocket_silo.minable=false
	game.print('虫子将在1000秒后开始进攻，虫子出现位置随机，做好准备！')
	
	--市场
	local market = surface.create_entity{name = "market", position = {0, -5}, force=game.forces.player}
	local market_items = {
		{price = {{"coin", 5}}, offer = {type = 'give-item', item = "rail", count = 1}},
		{price = {{"coin", 1000}}, offer = {type = 'give-item', item = 'car', count = 1}},
		{price = {{"coin", 3000}}, offer = {type = 'give-item', item = 'tank', count = 1}},
		{price = {{"coin", 20000}}, offer = {type = 'give-item', item = 'spidertron', count = 1}}
		--{price = {{"coin", 5000}}, offer = {type = 'give-item', item = 'locomotive', count = 1}},
		--{price = {{"coin", 5000}}, offer = {type = 'give-item', item = 'cargo-wagon', count = 1}},
		--{price = {{"coin", 5000}}, offer = {type = 'give-item', item = 'fluid-wagon', count = 1}}
	}
market.last_user = nil
		if market ~= nil then
			market.destructible = false
			if market ~= nil then
				for _, item in pairs(market_items) do
					market.add_market_item(item)
				end
			end
		end
		
	--设置虫子目标
	
	wave_defense_table.target = global.rocket_silo
	roil = global.rocket_silo
    nowface = surface

end

local loaded = _G.package.loaded
function require(path)
    return loaded[path] or error('Can only require files at runtime that have been required in the control stage.', 2)
end

local Event = require 'utils.event'
local on_player_joined_game = function(Event)
--game.print(nowface)

local surface = nowface
local player = game.players[Event.player_index]
local pos =surface.find_non_colliding_position('character', {10,10}, 2, 1)

--game.print(game.players[1].name)
player.teleport(pos,game.players[1].surface)

--player.teleport(surface.find_non_colliding_position("character", {0,0}, 2, 1))
end

--当火车被摧毁时
local function on_entity_died(Event)
if Event.entity == roil then

	game.print('游戏失败！\n 正在重启游戏。',{r = 1, g = 0, b = 0, a = 0.5})
	regame(Event)
	
end
end

local renow = require 'functions.soft_reset'
function regame()
game.print(3)
local surface = nowface

local map_gen_settings = {}
		map_gen_settings.autoplace_controls = {
			["coal"] = {frequency = "1", size = "1", richness = "0.7"},
			["stone"] = {frequency = "1", size = "1", richness = "0.7"},
			["copper-ore"] = {frequency = "1", size = "2", richness = "0.7"},
			["iron-ore"] = {frequency = "1", size = "2", richness = "0.7"},
			["crude-oil"] = {frequency = "1", size = "2", richness = "1"},
			["trees"] = {frequency = "1", size = "0.5", richness = "0.7"},
			["enemy-base"] = {frequency = "4", size = "2", richness = "0.4"},
		}
		
		local created_items = function()
  return
  {
  --  ["car"] = 1,
--	["cargo-wagon"] = 1,
--	["rail"] = 100
    ["iron-plate"] = 8,
    ["wood"] = 1,
    ["pistol"] = 1,
    ["firearm-magazine"] = 10,
    ["burner-mining-drill"] = 1,
    ["stone-furnace"] = 1
  }
end
global.created_items = created_items()

local new = renow.soft_reset_map(surface, map_gen_settings,global.created_items)

--重置经验
local RPG = require 'modules.rpg.table'
local rpg_t = RPG.get('rpg_t')

 for k, p in pairs(game.connected_players) do
	 local player = game.connected_players[k]
	
      --  game.print(player)
		--game.print(rpg_t[player.index].xp)
	rpg_t[player.index].xp = rpg_t[player.index].xp / 2
	rpg_t[player.index].level = 1
	rpg_t[player.index].strength = 10
	rpg_t[player.index].magicka = 10
	rpg_t[player.index].dexterity = 10
	rpg_t[player.index].vitality = 10
	rpg_t[player.index].points_to_distribute = 0

    end
	
	
--重置波防
    local wd = require 'modules.wave_defense.table'
    local wave_defense_table = wd.get_table()
	wd.reset_wave_defense()
	wave_defense_table.surface_index = new.index
	
--创建火箭
	global.rocket_silo = new.create_entity{name = "rocket-silo", position = {0, 10}, force=game.forces.player}
	global.rocket_silo.minable=false
--	game.print(global.rocket_silo)
	game.print('虫子将在1000秒后开始进攻，虫子出现位置随机，做好准备！')
	--wave_defense_table.target = global.rocket_silo
	wave_defense_table.target = global.rocket_silo
	
	local market = new.create_entity{name = "market", position = {0, -5}, force=game.forces.player}
	local market_items = {
		{price = {{"coin", 5}}, offer = {type = 'give-item', item = "rail", count = 1}},
		{price = {{"coin", 1000}}, offer = {type = 'give-item', item = 'car', count = 1}},
		{price = {{"coin", 3000}}, offer = {type = 'give-item', item = 'tank', count = 1}},
		{price = {{"coin", 20000}}, offer = {type = 'give-item', item = 'spidertron', count = 1}}
		--{price = {{"coin", 5000}}, offer = {type = 'give-item', item = 'locomotive', count = 1}},
		--{price = {{"coin", 5000}}, offer = {type = 'give-item', item = 'cargo-wagon', count = 1}},
		--{price = {{"coin", 5000}}, offer = {type = 'give-item', item = 'fluid-wagon', count = 1}}
	}
market.last_user = nil
		if market ~= nil then
			market.destructible = false
			if market ~= nil then
				for _, item in pairs(market_items) do
					market.add_market_item(item)
				end
			end
		end
--同步
roil = global.rocket_silo
nowface = new
end

Event.add(defines.events.on_player_created, on_player_created)
---我添加的----

--设置火箭事件
Event.add(defines.events.on_entity_died, on_entity_died)
Event.add(defines.events.on_player_joined_game, on_player_joined_game)
--Event.add(defines.events.on_rocket_launched, on_rocket_launched)
--Event.add(defines.events.on_entity_damaged, on_entity_damaged)