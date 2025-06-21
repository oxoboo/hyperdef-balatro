local function table_remove_key(t, key)
    local i = 1
    while t[i] do
        if key == t[i] then
            table.remove(t, i)
        end
        i = i + 1
    end
end

local function hyper_pack_create_card(booster, i, key_append)
    if i == 1 then
        booster.config.keys_spawn = hyperdef_shop_get_keys()
    end
    local key = pseudorandom_element(booster.config.keys_spawn, pseudoseed(key_append))
    table_remove_key(booster.config.keys_spawn, key)
    if key then
	    return create_card('Joker', G.jokers, nil, nil, nil, nil, key, key_append)
	else
	    -- create this card if no cards should spawn
		return create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_hyperdef_wooden_kaiju', key_append)
    end
end

-- Hyper Packs are much rarer than Buffoon Packs
SMODS.Booster {
    key = 'hyper_normal',
    group_key = 'k_hyperdef_hyper_pack',
    atlas = 'boosters',
    pos = { x = 0, y = 0 },
    config = {
        extra = 4,
        choose = 1,
        keys_spawn = {}
    },
    discovered = true,
    cost = 4,
    weight = 0.06,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra } }
    end,
    create_card = function(self, card, i)
        return hyper_pack_create_card(self, i, 'hyper_pack_normal')
    end
}

SMODS.Booster {
    key = 'hyper_mega',
    group_key = 'k_hyperdef_hyper_pack',
    atlas = 'boosters',
    pos = { x = 1, y = 0 },
    config = {
        extra = 8,
        choose = 2,
        keys_spawn = {}
    },
    discovered = true,
    cost = 8,
    weight = 0.015,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra } }
    end,
    create_card = function(self, card, i)
        return hyper_pack_create_card(self, i, 'hyper_pack_mega')
    end
}
