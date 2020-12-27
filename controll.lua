local RPG = require 'modules.rpg.table'
local re = require 'functions.soft_reset'
local Server = require 'utils.server'
require'mafan'
local wd = require 'modules.wave_defense.table'
--local fuck = require 'control'
--local wave_defense_table = wd.get_table()
CONVERT_ARGUMENTS_STATES_MAP = {
  -- nil output self, -1 new word, >= 0 to another status
  -- "str" output special
  -- states: 0 normal, 1 in ", 2 in ', 10 - 12 after \
  [0] = {
    ['"'] = 1, ['\''] = 2, ['\\'] = 10, [' '] = -1, ['\r'] = -1, ['\n'] = -1,
  },
  [1] = {
    ['"'] = 0, ['\\'] = 11,
  },
  [2] = {
    ['\''] = 0, ['\\'] = 12,
  },
  [10] = {
    ['a'] = '\a', ['b'] = '\b', ['f'] = '\f', ['n'] = '\n', ['r'] = '\r',
    ['t'] = '\t', ['v'] = '\v', ['\\'] = '\\', ['\''] = '\'', ['"'] = '"',
  }
}
CONVERT_ARGUMENTS_STATES_MAP[11] = CONVERT_ARGUMENTS_STATES_MAP[10]
CONVERT_ARGUMENTS_STATES_MAP[12] = CONVERT_ARGUMENTS_STATES_MAP[10]
function convert_args(line)


  local s = 0
  local args = {}
  local arg = ""
  local status_map = CONVERT_ARGUMENTS_STATES_MAP

  for i = 1, line:len() do
    local x = status_map[s][line:sub(i,i)]
    if x == nil then
      arg = arg .. line:sub(i,i)
    elseif x == -1 then
      if arg ~= '' then
        table.insert(args, arg)
        arg = ''
      end
    elseif type(x) == 'string' then
      arg = arg .. x
      if s >= 10 then
        s = s - 10
      end
    elseif x >= 0 then
      s = x
    end
  end
  if arg ~= '' then
    table.insert(args, arg)
  end
  return args
end



commands.add_command("zz", "ZZ", function(event)
	if event.parameter then
		event.argv = convert_args(event.parameter)
	else
		event.argv = {}
	end
	local player  = game.players[event.player_index]
	local surface = game.players[event.player_index].surface
	function chartore ()
		if event.argv[2] == "h" then 			player.print("/zz chartore (stone,coal,copper-ore,iron-ore,crude-oil,uranium-ore) number R",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		local pos = 2
		if event.argv[4] ~= nil then
			pos = event.argv[4] 
		end
		for _, resources in pairs(player.surface.find_entities_filtered{area = {{player.position.x-pos, player.position.y-pos}, {player.position.x+pos, player.position.y+pos}}, type= "resource"}) do
			if event.argv[2] == "all" then
				local number = resources.amount + event.argv[3]
				if number > 0 then
					resources.amount = number
				else
					resources.amount = 1
				end
			elseif resources.name == event.argv[2] then
				local number = resources.amount + event.argv[3]
				if number > 0 then
					resources.amount = number
				else
					resources.amount = 1
				end
			end
		end
	end
	
	 
	--地图优化 
	function removetiles()
		for chunk in surface.get_chunks() do
			--game.player.print("x: " .. chunk.x .. ", y: " .. chunk.y)
			--game.player.print("area: " .. serpent.line(chunk.area))
			local a = surface.count_tiles_filtered{area=chunk.area,name="out-of-map"}
			local b = surface.count_entities_filtered{area=chunk.area,force=game.forces.player}
			game.print(a)
			if a > 0 or b == 0 then
			surface.delete_chunk({chunk.x,chunk.y})
			end
		end
	end
	
	function removetrees()
		for chunk in surface.get_chunks() do
		  for _, e in pairs(surface.find_entities_filtered{area=chunk.area, type='tree'}) do
			e.destroy()
		  end
		end
	end
	function removecorpse()
		for chunk in surface.get_chunks() do
		  for _, e in pairs(surface.find_entities_filtered{area=chunk.area, type='corpse'}) do
			e.destroy()
		  end
		end
	end
	--game.player.force.technologies["automation"].researched
	function tech()
		if event.argv[2] == "h" then player.print("/zz tech name t/n",{r = 0.5, g = 1, b = 0, a = 0.5}) return end
		if event.argv[3] == "t" then
			game.player.force.technologies[event.argv[2]].researched = true
		end
		if event.argv[3] == "n" then
			game.player.force.technologies[event.argv[2]].researched = false
		end
	end
	
	
	function removemap()
		for chunk in surface.get_chunks() do
			surface.delete_chunk({chunk.x,chunk.y})
		end
	end
	
	--建筑保护 
	function defend ()
		if event.argv[2] == "h" then 			player.print("/zz defend R on/off",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		if event.argv[3] == "on" then 
			for _, entities in pairs(player.surface.find_entities_filtered{area = {{player.position.x - event.argv[2]/2, player.position.y - event.argv[2]/2}, {player.position.x + event.argv[2]/2, player.position.y + event.argv[2]/2}}, force = player.force}) do
				--if entities.type ~= "player" then 
					entities.destructible = false
					entities.minable = false
				--end
			end
		elseif event.argv[3] == "off" then
			for _, entities in pairs(player.surface.find_entities_filtered{area = {{player.position.x - event.argv[2]/2, player.position.y - event.argv[2]/2}, {player.position.x + event.argv[2]/2, player.position.y + event.argv[2]/2}}, force = player.force}) do
				entities.destructible = true
				entities.minable = true
			end
		end
	end	

	function chart ()
		-- if  not player.admin then
			-- print_back(event, {"cant-run-command-not-admin", event.name})
			-- return
		-- end
		if event.argv[2] == "h" then 			player.print("/zz chart -x -y x y ",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		player.force.chart(player.surface, {{event.argv[2],event.argv[3]}, {event.argv[4], event.argv[5]}})
	end
	
	function lantu ()
		game.player.force.character_reach_distance_bonus=10
		game.player.force.character_resource_reach_distance_bonus=10
		game.player.force.character_loot_pickup_distance_bonus=10
		game.player.force.character_inventory_slots_bonus=200
		game.player.force.worker_robots_battery_modifier=2000000
		game.player.force.worker_robots_speed_modifier=200000
		game.map_settings.pollution.enabled=false
		game.player.force.recipes["loader"].enabled=true
		game.player.force.recipes["fast-loader"].enabled=true
		game.player.force.recipes["express-loader"].enabled=true
		game.player.force.research_queue_enabled=true
		player.insert{name="infinity-chest", count = 10}
		player.insert{name="electric-energy-interface", count = 10}
	end
	--地图信息
	function mapinfo () 
		if event.argv[2] == "h" then 			player.print("/zz mapinfo w/j/s/k",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		if event.argv[2] == "污染" or event.argv[2] == "w" then
			--game.print("--------------------")
			game.print("    游戏时间：" .. string.format("%d小时%02d分%02d秒", math.floor(game.tick / 216000), math.floor(game.tick / 3600) % 60, math.floor(game.tick / 60) % 60) .. "-------------------------",{r = 0.5, g = 1, b = 0, a = 0.5})
			game.print("    每块污染扩散百分比：" .. game.map_settings.pollution.diffusion_ratio)
			game.print("    每块污染扩散绝对值：" .. game.map_settings.pollution.min_to_diffuse)
			game.print("    每块污染消散：" .. game.map_settings.pollution.ageing)
			game.print("    污染最高对森林破坏值：" .. game.map_settings.pollution.pollution_with_max_forest_damage)
			game.print("    污染最高对森林破坏值：" .. game.map_settings.pollution.pollution_per_tree_damage)
			game.print("    污染最高对森林破坏值：" .. game.map_settings.pollution.pollution_restored_per_tree_damage)
			game.print("    污染最高对森林破坏值：" .. game.map_settings.pollution.max_pollution_to_restore_trees)
			game.print("---------------------")
		elseif event.argv[2] == "进化" or event.argv[2] == "j" then
			--game.print("--------------------")

				if event.argv[3] == "进化" or event.argv[3] == "j" then
					game.forces.enemy.evolution_factor = event.argv[4] 
					return 
				end 

			game.print("    游戏时间：" .. string.format("%d小时%02d分%02d秒", math.floor(game.tick / 216000), math.floor(game.tick / 3600) % 60, math.floor(game.tick / 60) % 60) .. "-------------------------",{r = 0.5, g = 1, b = 0, a = 0.5})
			game.print("    当前虫族总体进化率：" .. game.forces.enemy.evolution_factor,{r = 1, g = 0, b = 0, a = 0.5})
			game.print("    时间进化：" .. game.map_settings.enemy_evolution.time_factor*60 .. "/秒")
			game.print("    虫巢摧毁：" .. game.map_settings.enemy_evolution.destroy_factor .. "/每个")
			game.print("    污染进化：" .. game.map_settings.enemy_evolution.pollution_factor*10 .. "/每吸收10000值")
			game.print("---------------------")
		elseif event.argv[2] == "属性" or event.argv[2] == "s" then
			if event.argv[3] == "上线" or event.argv[3] == "s"  then
				game.map_settings.enemy_expansion.max_expansion_cooldown = event.argv[4] * 3600 return 
			end
			if event.argv[3] == "下线" or event.argv[3] == "x" then game.map_settings.enemy_expansion.min_expansion_cooldown = event.argv[4] * 3600 return end
			if event.argv[3] == "最大" or event.argv[3] == "maxp" then game.map_settings.enemy_expansion.settler_group_max_size = event.argv[4] return end
			if event.argv[3] == "最小" or event.argv[3] == "minp" then game.map_settings.enemy_expansion.settler_group_min_size = event.argv[4] return end 
			--game.print("--------------------")
			game.print("    游戏时间：" .. string.format("%d小时%02d分%02d秒", math.floor(game.tick / 216000), math.floor(game.tick / 3600) % 60, math.floor(game.tick / 60) % 60) .. "-------------------------",{r = 0.5, g = 1, b = 0, a = 0.5})
			game.print("    虫巢扩张距离：" .. game.map_settings.enemy_expansion.max_expansion_distance)
			game.print("    友军基地影响半径：" .. game.map_settings.enemy_expansion.friendly_base_influence_radius)
			game.print("    敌军建筑影响半径：" .. game.map_settings.enemy_expansion.enemy_building_influence_radius)
			game.print("    建造系数：" .. game.map_settings.enemy_expansion.building_coefficient)
			game.print("    其他基数系数：" .. game.map_settings.enemy_expansion.other_base_coefficient)
			game.print("    相邻块系数：" .. game.map_settings.enemy_expansion.neighbouring_chunk_coefficient)
			game.print("    相邻块基本系数：" .. game.map_settings.enemy_expansion.neighbouring_base_chunk_coefficient)
			game.print("    最大碰撞平铺系数：" .. game.map_settings.enemy_expansion.max_colliding_tiles_coefficient)
			game.print("    队伍最小规模：" .. game.map_settings.enemy_expansion.settler_group_min_size)
			game.print("    队伍最大规模：" .. game.map_settings.enemy_expansion.settler_group_max_size)
			game.print("    派出队伍间隔上线：" .. game.map_settings.enemy_expansion.max_expansion_cooldown/3600 .. "/分钟")
			game.print("    派出队伍间隔下线：" .. game.map_settings.enemy_expansion.min_expansion_cooldown/3600 .. "/分钟")
			--game.print("---------------------")
		elseif event.argv[2] == "科研" or event.argv[2] == "k" then		
				if event.argv[3] == "乘数" or event.argv[3] == "c" then
					game.difficulty_settings.technology_price_multiplier = event.argv[4] return
				end 
			--game.print("--------------------")
			game.print("    游戏时间：" .. string.format("%d小时%02d分%02d秒", math.floor(game.tick / 216000), math.floor(game.tick / 3600) % 60, math.floor(game.tick / 60) % 60) .. "-------------------------",{r = 0.5, g = 1, b = 0, a = 0.5})
			if game.difficulty_settings.recipe_difficulty == 1 then game.print("    配方难度系列：高成本") else game.print("    配方难度系列：标准") end
			if game.difficulty_settings.technology_difficulty == 1 then game.print("    科技难度系列：高成本") else game.print("    科技难度系列：标准") end
			game.print("    科技话费乘数：" .. game.difficulty_settings.technology_price_multiplier)
			--game.print("---------------------")
		else
			player.print("输入格式有误！")
		end
	end
	--封地图
	function puttile()
	--(2)地砖名称 (3)坐标-x (4)-y (5)x (6)y 					(7)(8)(9)(10)()()
		if event.argv[2] == "h" then 			player.print("/zz puttile(挖水)	(2)地砖名称 (3)-x (4)x (5)-y (6)y)",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		if event.argv[2] == nil then 			player.print("/zz puttile(挖水)	(2)地砖名称 (3)-x (4)x (5)-y (6)y)",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end

		local tilename = event.argv[2]
		for x = event.argv[3] , event.argv[4] , 1 do
			for y = event.argv[5] , event.argv[6] , 1 do
				surface.set_tiles({{name = tilename,position = {x,y}}})
			end  
		end
	end
	--putentity
	function putentity()
	--(2)地砖名称 (3)坐标-x (4)上下左右 (5)pl/en (6)x 	(7)y		(8)(9)(10)()()

		if event.argv[2] == "h" then
			player.print("/zz putentity(放置实体)	(2)实体名称 (3)u/d/l/r (4)numbei距离 (5)x (6)y)",{r = 0.5, g = 1, b = 0, a = 0.5}) 			
			return 		
		end
		if event.argv[2] == nil then
			player.print("/zz putentity(放置实体)	(2)实体名称 (3)u/d/l/r (4)numbei距离 (5)x (6)y))",{r = 0.5, g = 1, b = 0, a = 0.5}) 			
			return 		
		end
		local enposition = player.position--方向
		local eforce = game.forces.player
		if event.argv[5] == "pl" then
			eforce = game.forces.player
		elseif event.argv[5] == "en" then
			eforce = game.forces.enemy
		end
		
		if event.argv[6] ~= nil and event.argv[7] ~= nil then 
			enposition.x = event.argv[6] enposition.y = event.argv[7] 
		end
		local entityname = event.argv[2]
		local endirection = {}
		if event.argv[3] == "u" then enposition.y = enposition.y - event.argv[4] endirection = defines.direction.north
		elseif event.argv[3] == "d" then enposition.y = enposition.y + event.argv[4] endirection = defines.direction.south
		elseif event.argv[3] == "l" then enposition.x = enposition.x - event.argv[4] endirection = defines.direction.west
		elseif event.argv[3] == "r" then enposition.x = enposition.x + event.argv[4] endirection = defines.direction.east
		end
		
		local entity = surface.create_entity{name = entityname, position = enposition,direction = endirection, force=eforce}
		entity.last_user = game.players[1]
		
	end
	--水
	function water () 
		if event.argv[2] == "h" then 			player.print("/zz water(挖水)	u/d/l/r(上，下，左，右)",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		if event.argv[2] == "u" then
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y - 3} }})
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y - 4} }})
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y - 5} }})
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y - 6} }})
		elseif event.argv[2] == "d" then
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y + 3} }})
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y + 4} }})
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y + 5} }})
		surface.set_tiles({{name = "water",position = {player.position.x, player.position.y + 6} }})
		elseif event.argv[2] == "l" then
		surface.set_tiles({{name = "water",position = {player.position.x - 3, player.position.y} }})
		surface.set_tiles({{name = "water",position = {player.position.x - 4, player.position.y} }})
		surface.set_tiles({{name = "water",position = {player.position.x - 5, player.position.y} }})
		surface.set_tiles({{name = "water",position = {player.position.x - 6, player.position.y} }})
		elseif event.argv[2] == "r" then
		surface.set_tiles({{name = "water",position = {player.position.x + 3, player.position.y} }})
		surface.set_tiles({{name = "water",position = {player.position.x + 4, player.position.y} }})
		surface.set_tiles({{name = "water",position = {player.position.x + 5, player.position.y} }})
		surface.set_tiles({{name = "water",position = {player.position.x + 6, player.position.y} }})
		end
		
	end
	--市场
	function market ()
		local market = nowface.create_entity{name = "market", position = {player.position.x, player.position.y-2}, force=game.forces.player}
		local market_items = {
		{price = {{"coin", 5}}, offer = {type = 'give-item', item = "raw-fish", count = 1}},
		{price = {{"coin", 1}}, offer = {type = 'give-item', item = 'wood', count = 8}},		
		{price = {{"coin", 8}}, offer = {type = 'give-item', item = 'grenade', count = 1}},
		{price = {{"coin", 32}}, offer = {type = 'give-item', item = 'cluster-grenade', count = 1}},
		{price = {{"coin", 1}}, offer = {type = 'give-item', item = 'land-mine', count = 1}},
		{price = {{"coin", 80}}, offer = {type = 'give-item', item = 'car', count = 1}},
		{price = {{"coin", 1200}}, offer = {type = 'give-item', item = 'tank', count = 1}},
		{price = {{"coin", 3}}, offer = {type = 'give-item', item = 'cannon-shell', count = 1}},
		{price = {{"coin", 7}}, offer = {type = 'give-item', item = 'explosive-cannon-shell', count = 1}},
		{price = {{"coin", 50}}, offer = {type = 'give-item', item = 'gun-turret', count = 1}},
		{price = {{"coin", 300}}, offer = {type = 'give-item', item = 'laser-turret', count = 1}},
		{price = {{"coin", 450}}, offer = {type = 'give-item', item = 'artillery-turret', count = 1}},
		{price = {{"coin", 10}}, offer = {type = 'give-item', item = 'artillery-shell', count = 1}},
		{price = {{"coin", 25}}, offer = {type = 'give-item', item = 'artillery-targeting-remote', count = 1}},
		{price = {{"coin", 1}}, offer = {type = 'give-item', item = 'firearm-magazine', count = 1}},
		{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'piercing-rounds-magazine', count = 1}},				
		{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'shotgun-shell', count = 1}},	
		{price = {{"coin", 6}}, offer = {type = 'give-item', item = 'piercing-shotgun-shell', count = 1}},
		{price = {{"coin", 30}}, offer = {type = 'give-item', item = "submachine-gun", count = 1}},
		{price = {{"coin", 250}}, offer = {type = 'give-item', item = 'combat-shotgun', count = 1}},	
		{price = {{"coin", 450}}, offer = {type = 'give-item', item = 'flamethrower', count = 1}},	
		{price = {{"coin", 25}}, offer = {type = 'give-item', item = 'flamethrower-ammo', count = 1}},	
		{price = {{"coin", 125}}, offer = {type = 'give-item', item = 'rocket-launcher', count = 1}},
		{price = {{"coin", 2}}, offer = {type = 'give-item', item = 'rocket', count = 1}},	
		{price = {{"coin", 7}}, offer = {type = 'give-item', item = 'explosive-rocket', count = 1}},
		{price = {{"coin", 7500}}, offer = {type = 'give-item', item = 'atomic-bomb', count = 1}},		
		{price = {{"coin", 325}}, offer = {type = 'give-item', item = 'railgun', count = 1}},
		{price = {{"coin", 8}}, offer = {type = 'give-item', item = 'railgun-dart', count = 1}},	
		{price = {{"coin", 40}}, offer = {type = 'give-item', item = 'poison-capsule', count = 1}},
		{price = {{"coin", 4}}, offer = {type = 'give-item', item = 'defender-capsule', count = 1}},	
		{price = {{"coin", 10}}, offer = {type = 'give-item', item = 'light-armor', count = 1}},		
		{price = {{"coin", 125}}, offer = {type = 'give-item', item = 'heavy-armor', count = 1}},	
		{price = {{"coin", 350}}, offer = {type = 'give-item', item = 'modular-armor', count = 1}},	
		{price = {{"coin", 1500}}, offer = {type = 'give-item', item = 'power-armor', count = 1}},
		{price = {{"coin", 12000}}, offer = {type = 'give-item', item = 'power-armor-mk2', count = 1}},
		{price = {{"coin", 50}}, offer = {type = 'give-item', item = 'solar-panel-equipment', count = 1}},
		{price = {{"coin", 2250}}, offer = {type = 'give-item', item = 'fusion-reactor-equipment', count = 1}},
		{price = {{"coin", 100}}, offer = {type = 'give-item', item = 'battery-equipment', count = 1}},				
		{price = {{"coin", 200}}, offer = {type = 'give-item', item = 'energy-shield-equipment', count = 1}},
		{price = {{"coin", 850}}, offer = {type = 'give-item', item = 'personal-laser-defense-equipment', count = 1}},	
		{price = {{"coin", 175}}, offer = {type = 'give-item', item = 'exoskeleton-equipment', count = 1}},		
		{price = {{"coin", 125}}, offer = {type = 'give-item', item = 'night-vision-equipment', count = 1}},
		{price = {{"coin", 200}}, offer = {type = 'give-item', item = 'belt-immunity-equipment', count = 1}},	
		{price = {{"coin", 250}}, offer = {type = 'give-item', item = 'personal-roboport-equipment', count = 1}},
		{price = {{"coin", 35}}, offer = {type = 'give-item', item = 'construction-robot', count = 1}},
		{price = {{"coin", 25}}, offer = {type = 'give-item', item = 'cliff-explosives', count = 1}}
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
	end
	
	
	function gadmin ()
		if event.argv[2] == "h" then 			player.print("/zz gadmin PLAYER add/del",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		for _, p in pairs(game.players) do
			if p.name ==  event.argv[2] then
				if event.argv[3] == "add"then
					p.admin = true
				elseif event.argv[3] == "del"then
					p.admin = false
				end
				return
			end
		end
	end
	--gitem
	function gitem ()
		if event.argv[2] == "h" then 			player.print("/zz gitem ITEM NUMBER",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		local s = event.argv[2]
		s = string.gsub(s,"%[item=",'')
		s = string.gsub(s,"%[recipe=",'')
		s = string.gsub(s,"]",'')
	player.insert{name=s, count = event.argv[3]}
	end
	--重叠
	function overlap()
		if event.argv[2] == "h" then
			player.print("/zz overlap(现有矿调整) 叠加实体(实体名称查询请输入/zz overlap enemy 中文名称） 数量 范围 插入物品(该实体需支持插入)",{r = 0.5, g = 1, b = 0, a = 0.5})
			return 		
		end
		 --/zz 1overlap 2enemy 3number 4pos 5in
		if event.argv[2] == "enemy" then player.print({event.argv[3]}) return end
		local number = 1 local pos = 2 
		if event.argv[3] ~= nil then number = event.argv[3] end
		if event.argv[4] ~= nil then pos = event.argv[4] end
		for _, fenemy in pairs(player.surface.find_entities_filtered{area = {{player.position.x-pos, player.position.y-pos}, {player.position.x+pos, player.position.y+pos}}, name = event.argv[2]}) do
			for y = 1 , number , 1 do
				local thisenemy = surface.create_entity{name = fenemy.name, position = fenemy.position, force=fenemy.force,direction = fenemy.direction}
				if event.argv[5] ~= nil then thisenemy.insert{name=event.argv[5], count = event.argv[6]} end
				thisenemy.last_user = game.players[1]
				--thisenemy.minable = false
			end
		end
	end
	--伤害加成
	function procession()
		local enemy = game.forces["enemy"]
		local play = game.forces["player"]
		if event.argv[2] == "h" then
			player.print("/zz procession pl/en ammo-damage/gun-speed/turret-attack number")
			player.print("ammo:(melee(物理)/landmine(地雷)/grenade(手雷)/shotgun-shell(散弹)/bullet(弹夹)/rocket(火箭弹)/cannon-shell(炮弹)/artillery-shell(重炮弹)/combat-robot-beam(进攻无人机))")
			player.print("ammo:(combat-robot-laser(掩护无人机)/combat-robot-laser(掩护无人机)/laser-turret(极光炮塔)/electric(电解)/biological(生物)/flamethrower(火焰))")
		elseif event.argv[2] == "pl" then
			if event.argv[3] == "ammo-damage" then--big-worm-turret
				play.set_ammo_damage_modifier(event.argv[4], event.argv[5])
				player.print(play.get_ammo_damage_modifier(event.argv[4]))
			elseif event.argv[3] == "gun-speed" then
				play.set_gun_speed_modifier(event.argv[4], event.argv[5])
				player.print(play.get_gun_speed_modifier(event.argv[4]))
			elseif event.argv[3] == "turret-attack" then
				play.set_turret_attack_modifier(event.argv[4], event.argv[5])
				player.print(play.get_turret_attack_modifier(event.argv[4]))
			end 
		elseif event.argv[2] == "en" then
			if event.argv[3] == "ammo-damage" then
				enemy.set_ammo_damage_modifier(event.argv[4], event.argv[5])
				player.print(enemy.get_ammo_damage_modifier(event.argv[4]))
			elseif event.argv[3] == "gun-speed" then
				enemy.set_gun_speed_modifier(event.argv[4], event.argv[5])
				player.print(enemy.get_gun_speed_modifier(event.argv[4]))
			elseif event.argv[3] == "turret-attack" then
				enemy.set_turret_attack_modifier(event.argv[4], event.argv[5])
				player.print(enemy.get_turret_attack_modifier(event.argv[4]))
			end 
		end
	end
	--/zz procession pl gun-speed piercing-rounds-magazine 10
	--有好模式
	function friendfir()
		local enemy = game.forces["enemy"]
		local play = game.forces["player"]
		if event.argv[2] == "h" then
			player.print("/zz friendfir pl/en on/off")
		elseif event.argv[2] == "pl" then
			if event.argv[3] == "on" then
				play.friendly_fire = true
			elseif event.argv[3] == "off" then
				play.friendly_fire = false
			end 
		elseif event.argv[2] == "en" then
			if event.argv[3] == "on" then
				enemy.friendly_fire = true
			elseif event.argv[3] == "off" then
				enemy.friendly_fire = false
			end 
		end
	end
	--创建矿
	function putore()
		if event.argv[2] == "h" then
			player.print("/zz putore 矿名(stone,coal,copper,iron,crude,uranium) number",{r = 0.5, g = 1, b = 0, a = 0.5})
		elseif event.argv[2] == "stone" then
			player.surface.create_entity{name = "stone" ,position = player.position,amount = event.argv[3]}
		elseif event.argv[2] == "coal" then
			player.surface.create_entity{name = "coal" ,position = player.position,amount = event.argv[3]}
		elseif event.argv[2] == "copper" then
			player.surface.create_entity{name = "copper-ore" ,position = player.position,amount = event.argv[3]}
		elseif event.argv[2] == "iron" then
			player.surface.create_entity{name = "iron-ore" ,position = player.position,amount = event.argv[3]}
		elseif event.argv[2] == "crude" then
			player.surface.create_entity{name = "crude-oil" ,position = player.position,amount = event.argv[3]}
		elseif event.argv[2] == "uranium" then
			player.surface.create_entity{name = "uranium-ore" ,position = player.position,amount = event.argv[3]}
		else
			player.print("/zz putore 矿名(stone,coal,copper,iron,crude,uranium) number",{r = 0.5, g = 1, b = 0, a = 0.5})
		end
		player.surface.create_entity{name = event.argv[2],position = player.position,amount = event.argv[3]}
	end
	--合成
	function recipe()
		if event.argv[2] == "h" then
			player.print("/zz recipe item false/true",{r = 0.5, g = 1, b = 0, a = 0.5})
		elseif event.argv[3] == "true" then
			local s = event.argv[2]
			s = string.gsub(s,"%[item=",'')
			s = string.gsub(s,"%[recipe=",'')
			s = string.gsub(s,"]",'')
			game.player.force.recipes[s].enabled = true
		elseif event.argv[3] == "false" then
			local s = event.argv[2]
			s = string.gsub(s,"%[item=",'')
			s = string.gsub(s,"%[recipe=",'')
			s = string.gsub(s,"]",'')
			game.player.force.recipes[s].enabled = false
		else
			player.print("/zz recipe item false/true",{r = 0.5, g = 1, b = 0, a = 0.5})
		end
	end
	--研究
	function research()
		if event.argv[2] == "h" then
			player.print("/zz research number(0-1)",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			player.force.research_progress = event.argv[2]
		end
	end
	--重置合成rrecipe
	function research()
		if event.argv[2] == "h" then
			player.print("/zz research number(0-1)",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			player.force.research_progress = event.argv[2]
		end
	end
	--玩家队伍加成
	function cmd()
		if event.argv[2] == "h" then
			player.print("/zz cmd text",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			--local  addscript="function dadd() " .. event.argv[2] .. " " .. event.argv[3] .. " " .. event.argv[4] .. " " .. event.argv[5] .. " end"
			local addscript = "function dadd() "
				for x = 2 , 100 , 1 do
					if event.argv[x] ~= nil then
						addscript = addscript .. event.argv[x]  .. " "
					end
				end  
			addscript = addscript .. " end"
			--player.print("addscript",{r = 0.5, g = 1, b = 0, a = 0.5})
			assert(loadstring(addscript))()  
			dadd()
			--player.print("执行完毕",{r = 0.5, g = 1, b = 0, a = 0.5})
		end
	end
    
	local regame = require 'functions.soft_reset'
	require 'modules.wave_defense.main'
	--重启游戏
	function re()
local created_items = function()
  return
  {
  -- ["car"] = 1,
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
global.created_items = created_items()

    local new = regame.soft_reset_map(surface, map_gen_settings,global.created_items)
local rpg_t = RPG.get('rpg_t')
local global = require 'utils.global'
global.rocket_silo = {}
--local xp_player = game.get_player(event.argv[2])
local wave_defense_table = wd.get_table()
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
	wd.reset_wave_defense()
	wave_defense_table.surface_index = new.index
	--创建火箭
	
	global.rocket_silo = new.create_entity{name = "rocket-silo", position = {0, 10}, force=game.forces.player}
	global.rocket_silo.minable=false
	--game.print(global.rocket_silo)
	game.print('虫子将在1000秒后开始进攻，虫子出现位置随机，做好准备！')
	--wave_defense_table.target = global.rocket_silo
	wave_defense_table.target = global.rocket_silo
	--game.print(wave_defense_table.target)
	--game.print(wave_defense_table.target)
	--市场
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
		roil = global.rocket_silo
	    nowface = new
		-----不要在我下面加代码
     return
	end

---------------------------------------------------------
	function gxp ()
		local rpg_t = RPG.get('rpg_t')
		if event.argv[2] == "h" then 			player.print("/zz gxp player xp-number",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		local xp_player = game.get_player(event.argv[2])
		if not player or not player.valid then
			return
		end
		game.print(xp_player.index)
		rpg_t[xp_player.index].xp = rpg_t[xp_player.index].xp + event.argv[3]
		game.print(rpg_t[xp_player.index].xp)
	end
	function gpn ()
		local rpg_t = RPG.get('rpg_t')
		if event.argv[2] == "h" then 			player.print("/zz gpn player pn-number",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
		local pn_player = game.get_player(event.argv[2])
		if not player or not player.valid then
			return
		end
		rpg_t[pn_player.index].points_to_distribute = rpg_t[pn_player.index].points_to_distribute +event.argv[3]
		end
	-----------------------------------------------------
	if event.argv[1] == nil then
		player.print(" ")
	elseif event.argv[1] == "chartore" then
		if pcall(chartore) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "defend" then
		if pcall(defend) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "chart" then
		if pcall(chart) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "gitem" or event.argv[1] == "g" or event.argv[1] == "G" then
		if pcall(gitem) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "mapinfo" then
		if pcall(mapinfo) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "water" then
		if pcall(water) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "market" then
	market()
		if pcall(market) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "gadmin" then
		if pcall(gadmin) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "overlap" then
		if pcall(overlap) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "cheshi" then
		cheshi()
	elseif event.argv[1] == "procession" then
		if pcall(procession) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "friendfir" then
		if pcall(friendfir) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "putore" then
		if pcall(putore) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "puttile" then
		if pcall(puttile) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "putentity" then
		if pcall(putentity) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "recipe" then
		if pcall(recipe) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "research" then
		if pcall(research) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "lantu" then
		if pcall(lantu) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "rrecipe" then
		if pcall(rrecipe) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "removetiles" then
		if pcall(removetiles) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "removemap" then
		if pcall(removemap) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "tech" then
		if pcall(tech) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "removetrees" then
		if pcall(removetrees) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "removecorpse" then
		if pcall(removecorpse) then
	game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "gxp" then
		if pcall(gxp) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "gpn" then
		
		if pcall(gpn) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
	elseif event.argv[1] == "cmd" then
		if pcall(cmd) then
			game.print("有人使用了作弊代码",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("作弊失败",{r = 1, g = 0, b = 0, a = 0.5})
		end
		elseif event.argv[1] == "re" then
		if pcall(re) then
			game.print("重开成功",{r = 0.5, g = 1, b = 0, a = 0.5})
		else
			game.print("重开失败，正在尝试再次重开，如果还是有问题，请联系管理员！或手动输入/zz re",{r = 1, g = 0, b = 0, a = 0.5})
		end
	end
	
	--[[research plup
	/zz chartore(现有矿调整) 矿名(stone,coal,copper,iron,crude,uranium) 数量 范围
	/zz defend(保护建筑) 以玩家为坐标 范围 on(开启)/off(关闭)
	/zz chart(扫描区域) -x -y x y (以初始点上-Y是负值 下Y 正值 左X负值 右X 正值)
	/zz mapinfo(地图信息)
	/zz water(挖水)	u/d/l/r(上，下，左，右)
	/zz market(市场)
	/zz gadmin(给管理) 玩家名 add/del
	if event.argv[2] == "h" then 			player.print("/zz gadmin(给管理) 玩家名 add/del",{r = 0.5, g = 1, b = 0, a = 0.5}) 			return 		end
	--]]
end)
