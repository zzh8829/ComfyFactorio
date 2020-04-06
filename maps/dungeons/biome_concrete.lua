local Functions = require "maps.dungeons.functions"
local BiterRaffle = require "functions.biter_raffle"

local table_shuffle_table = table.shuffle_table
local table_insert = table.insert
local table_remove = table.remove
local math_random = math.random
local math_abs = math.abs
local math_sqrt = math.sqrt
local math_floor = math.floor

local function add_enemy_units(surface, room)
	for _, tile in pairs(room.room_border_tiles) do 
		if math_random(1, 2) == 1 then
			local name = BiterRaffle.roll("biter", global.dungeons.depth * 0.001)
			local unit = surface.create_entity({name = name, position = tile.position, force = "enemy"})
		end
	end
	for _, tile in pairs(room.room_tiles) do
		if math_random(1, 2) == 1 then
			local name = BiterRaffle.roll("biter", global.dungeons.depth * 0.001)
			local unit = surface.create_entity({name = name, position = tile.position, force = "enemy"})
		end
	end	
end

local function concrete(surface, room)
	for _, tile in pairs(room.path_tiles) do		
		surface.set_tiles({{name = "concrete", position = tile.position}}, true)	
	end
	
	if not room.room_border_tiles[1] then return end
	
	table_shuffle_table(room.room_tiles)
	for key, tile in pairs(room.room_tiles) do
		surface.set_tiles({{name = "stone-path", position = tile.position}}, true)
		if math_random(1, 16) == 1 then
			surface.create_entity({name = "iron-ore", position = tile.position, amount = Functions.get_common_resource_amount()})
		end
		if math_random(1, 128) == 1 then
			Functions.crash_site_chest(surface, tile.position)
		end
		if key % 128 == 1 and math_random(1, 3) == 1 then
			Functions.set_spawner_tier(surface.create_entity({name = "biter-spawner", position = tile.position, force = "enemy"}))
		end
		if math_random(1, 256) == 1 then
			surface.create_entity({name = "crude-oil", position = room.center, amount = Functions.get_crude_oil_amount()})
		end
	end
	
	table_shuffle_table(room.room_border_tiles)
	for key, tile in pairs(room.room_border_tiles) do
		surface.set_tiles({{name = "refined-concrete", position = tile.position}}, true)
		if key % 8 == 1 then
			surface.create_entity({name = "rock-big", position = tile.position})
		else
			surface.create_entity({name = "stone-wall", position = tile.position})
		end
	end
	
	if room.entrance_tile then
		local p = room.entrance_tile.position
		local area = {{p.x - 1, p.y - 1}, {p.x + 1.5, p.y + 1.5}}
		for _, entity in pairs(surface.find_entities_filtered({area = area})) do
			entity.destroy()
		end
	end
	
	add_enemy_units(surface, room)
end

return concrete