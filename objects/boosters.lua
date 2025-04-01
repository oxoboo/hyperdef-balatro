local hyper1_jokers = {
    'j_hyperdef_wooden_kaiju',
    'j_hyperdef_shopcorp',
    'j_hyperdef_horse_plinko',
    'j_hyperdef_magazine',
    'j_hyperdef_fish_satan',
    'j_hyperdef_manic',
    'j_hyperdef_creature'
}

-- This booster is only for the Hyper Deck
SMODS.Booster {
    key = 'hyper1',
    group_key = 'k_hyperdef_hyper_pack',
    atlas = 'boosters',
    pos = { x = 0, y = 0 },
    config = {
        extra = #hyper1_jokers,
        choose = 1,
        jokers = hyper1_jokers
    },
    discovered = true,
    cost = 2,
    weight = 0,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra } }
    end,
    create_card = function(self, card, i)
        return create_card('Joker', G.jokers, nil, nil, nil, nil, self.config.jokers[i], 'hyper1')
    end
}

local hyper2_jokers = {
    'j_hyperdef_stead_dog',
    'j_hyperdef_buffer_joker',
    'j_hyperdef_polycule_joker',
    'j_hyperdef_alchemy',
    'j_hyperdef_hydra',
    'j_hyperdef_adam',
    'j_hyperdef_oxoboo',
    'j_hyperdef_stead'
}

-- This booster is only for the Hyper Deck
SMODS.Booster {
    key = 'hyper2',
    group_key = 'k_hyperdef_hyper_pack',
    atlas = 'boosters',
    pos = { x = 1, y = 0 },
    config = {
        extra = #hyper2_jokers,
        choose = 1,
        jokers = hyper2_jokers
    },
    discovered = true,
    cost = 2,
    weight = 0,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose, self.config.extra } }
    end,
    create_card = function(self, card, i)
        return create_card('Joker', G.jokers, nil, nil, nil, nil, self.config.jokers[i], 'hyper2')
    end
}
