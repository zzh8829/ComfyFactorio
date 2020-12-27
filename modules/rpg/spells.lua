local Public = {}

function Public.conjure_items()
    local spells = {}

    spells[#spells + 1] = {
        name = '石墙',
        obj_to_create = 'stone-wall',
        level = 1,
        type = 'item',
        mana_cost = 5,
        tick = 1,
        enabled = true
    }

    spells[#spells + 1] = {
        name = '木箱子',
        obj_to_create = 'wooden-chest',
        level = 1,
        type = 'item',
        mana_cost = 10,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '铁箱子',
        obj_to_create = 'iron-chest',
        level = 5,
        type = 'item',
        mana_cost = 20,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '钢箱子',
        obj_to_create = 'steel-chest',
        level = 10,
        type = 'item',
        mana_cost = 50,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '传送带',
        obj_to_create = 'transport-belt',
        level = 3,
        type = 'item',
        mana_cost = 20,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '快速传送带',
        obj_to_create = 'fast-transport-belt',
        level = 15,
        type = 'item',
        mana_cost = 30,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '急速传送带',
        obj_to_create = 'express-transport-belt',
        level = 40,
        type = 'item',
        mana_cost = 80,
       tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '地下传送带',
        obj_to_create = 'underground-belt',
        level = 3,
        type = 'item',
        mana_cost = 20,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '快速地下传送带',
        obj_to_create = 'fast-underground-belt',
        level = 5,
        type = 'item',
        mana_cost = 40,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '急速地下传送带',
        obj_to_create = 'express-underground-belt',
        level = 10,
        type = 'item',
        mana_cost = 80,
       tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = 'Sandy Rock',
        obj_to_create = 'sand-rock-big',
        level = 20,
        type = 'entity',
        mana_cost = 50,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '小虫子',
        obj_to_create = 'small-biter',
        level = 15,
        biter = true,
        type = 'entity',
        mana_cost = 35,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '远程小虫子',
        obj_to_create = 'small-spitter',
        level = 15,
        biter = true,
        type = 'entity',
        mana_cost = 35,
       tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '中虫子',
        obj_to_create = 'medium-biter',
        level = 25,
        biter = true,
        type = 'entity',
        mana_cost = 55,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '远程中虫子',
        obj_to_create = 'medium-spitter',
        level = 25,
        type = 'entity',
        mana_cost = 55,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '撕咬巢穴',
        obj_to_create = 'biter-spawner',
        level = 45,
        biter = true,
        type = 'entity',
        mana_cost = 600,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '喷吐巢穴',
        obj_to_create = 'spitter-spawner',
        level = 45,
        biter = true,
        type = 'entity',
        mana_cost = 600,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '手雷',
        obj_to_create = 'grenade',
        target = true,
        amount = 1,
        damage = true,
        force = 'player',
        level = 15,
        type = 'special',
        mana_cost = 75,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '大型AOE手雷',
        obj_to_create = 'cluster-grenade',
        target = true,
        amount = 2,
        damage = true,
        force = 'player',
        level = 35,
        type = 'special',
        mana_cost = 150,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = 'Pointy Rocket',
        obj_to_create = 'rocket',
        range = 240,
        target = true,
        amount = 4,
        damage = true,
        force = 'enemy',
        level = 40,
        type = 'special',
        mana_cost = 60,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '虫子口水',
        obj_to_create = 'acid-stream-spitter-big',
        target = true,
        amount = 2,
        range = 0,
        damage = true,
        force = 'player',
        level = 40,
        type = 'special',
        mana_cost = 55,
       tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '沙虫口水',
        obj_to_create = 'railgun-beam',
        target = false,
        amount = 3,
        damage = true,
        range = 240,
        force = 'player',
        level = 30,
        type = 'special',
        mana_cost = 100,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '生成鱼',
        obj_to_create = 'fish',
        target = false,
        amount = 4,
        damage = false,
        range = 30,
        force = 'player',
        level = 10,
        type = 'special',
        mana_cost = 30,
       tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = 'Suicidal Comfylatron',
        obj_to_create = 'suicidal_comfylatron',
        target = false,
        amount = 4,
        damage = false,
        range = 30,
        force = 'player',
        level = 60,
        type = 'special',
        mana_cost = 250,
        tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '防御无人机',
        obj_to_create = 'distractor-capsule',
        target = true,
        amount = 1,
        damage = false,
        range = 30,
        force = 'player',
        level = 25,
        type = 'special',
        mana_cost = 125,
     tick = 1,
        enabled = true
    }
    spells[#spells + 1] = {
        name = '回城',
        obj_to_create = 'warp-gate',
        target = true,
        force = 'player',
        level = 60,
        type = 'special',
        mana_cost = 100,
       tick = 1,
        enabled = true
    }
    return spells
end

Public.projectile_types = {
    ['explosives'] = {name = 'grenade', count = 0.5, max_range = 32, tick_speed = 1},
    ['land-mine'] = {name = 'grenade', count = 1, max_range = 32, tick_speed = 1},
    ['grenade'] = {name = 'grenade', count = 1, max_range = 40, tick_speed = 1},
    ['cluster-grenade'] = {name = 'cluster-grenade', count = 1, max_range = 40, tick_speed = 3},
    ['artillery-shell'] = {name = 'artillery-projectile', count = 1, max_range = 60, tick_speed = 3},
    ['cannon-shell'] = {name = 'cannon-projectile', count = 1, max_range = 60, tick_speed = 1},
    ['explosive-cannon-shell'] = {name = 'explosive-cannon-projectile', count = 1, max_range = 60, tick_speed = 1},
    ['explosive-uranium-cannon-shell'] = {
        name = 'explosive-uranium-cannon-projectile',
        count = 1,
        max_range = 60,
        tick_speed = 1
    },
    ['uranium-cannon-shell'] = {name = 'uranium-cannon-projectile', count = 1, max_range = 60, tick_speed = 1},
    ['atomic-bomb'] = {name = 'atomic-rocket', count = 1, max_range = 80, tick_speed = 20},
    ['explosive-rocket'] = {name = 'explosive-rocket', count = 1, max_range = 48, tick_speed = 1},
    ['rocket'] = {name = 'rocket', count = 1, max_range = 48, tick_speed = 1},
    ['flamethrower-ammo'] = {name = 'flamethrower-fire-stream', count = 4, max_range = 28, tick_speed = 1},
    ['crude-oil-barrel'] = {name = 'flamethrower-fire-stream', count = 3, max_range = 24, tick_speed = 1},
    ['petroleum-gas-barrel'] = {name = 'flamethrower-fire-stream', count = 4, max_range = 24, tick_speed = 1},
    ['light-oil-barrel'] = {name = 'flamethrower-fire-stream', count = 4, max_range = 24, tick_speed = 1},
    ['heavy-oil-barrel'] = {name = 'flamethrower-fire-stream', count = 4, max_range = 24, tick_speed = 1},
    ['acid-stream-spitter-big'] = {
        name = 'acid-stream-spitter-big',
        count = 3,
        max_range = 16,
        tick_speed = 1,
        force = 'enemy'
    },
    ['lubricant-barrel'] = {name = 'acid-stream-spitter-big', count = 3, max_range = 16, tick_speed = 1},
    ['railgun-beam'] = {name = 'railgun-beam', count = 5, max_range = 40, tick_speed = 5},
    ['shotgun-shell'] = {name = 'shotgun-pellet', count = 16, max_range = 24, tick_speed = 1},
    ['piercing-shotgun-shell'] = {name = 'piercing-shotgun-pellet', count = 16, max_range = 24, tick_speed = 1},
    ['firearm-magazine'] = {name = 'shotgun-pellet', count = 16, max_range = 24, tick_speed = 1},
    ['piercing-rounds-magazine'] = {name = 'piercing-shotgun-pellet', count = 16, max_range = 24, tick_speed = 1},
    ['uranium-rounds-magazine'] = {name = 'piercing-shotgun-pellet', count = 32, max_range = 24, tick_speed = 1},
    ['cliff-explosives'] = {name = 'cliff-explosives', count = 1, max_range = 48, tick_speed = 2}
}

return Public
