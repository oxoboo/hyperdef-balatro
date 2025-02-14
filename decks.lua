function deck_add_joker(forced_key)
    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'deck')
    card:add_to_deck()
    card:start_materialize()
    G.jokers:emplace(card)
end

SMODS.Back {
    name = 'Test Deck 1',
    key = 'test1',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Test Deck 1',
        text = {
            'Start run with',
            '{C:attention}Creature{}'
        },
    },
    unlocked = true,
    discovered = true,
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                deck_add_joker('j_hyperdef_creature')
                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Test Deck 2',
    key = 'test2',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Test Deck 2',
        text = {
            'Start run with',
            '{C:attention}Hydra the Fox{}'
        },
    },
    unlocked = true,
    discovered = true,
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                deck_add_joker('j_hyperdef_hydra')
                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Test Deck 3',
    key = 'test3',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Test Deck 3',
        text = {
            'Start run with',
            '{C:attention}Horse Plinko{}',
        },
    },
    unlocked = true,
    discovered = true,
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                deck_add_joker('j_hyperdef_horse_plinko')
                return true
            end
        }))
    end
}

SMODS.Back {
    name = 'Test Deck 4',
    key = 'test4',
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = 'Test Deck 4',
        text = {
            'Start run with',
            '{C:attention}Fish Satan{}'
        },
    },
    unlocked = true,
    discovered = true,
    apply = function()
        G.E_MANAGER:add_event(Event({
            func = function()
                deck_add_joker('j_hyperdef_fish_satan')
                return true
            end
        }))
    end
}
