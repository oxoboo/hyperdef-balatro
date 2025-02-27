local ENABLE_TEST_DECK = false

local atlas_boosters = SMODS.Atlas {
    key = 'boosters',
    path = 'boosters.png',
    px = 71,
    py = 95
}

function deck_add_joker(forced_key)
    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'deck')
    card:add_to_deck()
    card:start_materialize()
    G.jokers:emplace(card)
end

if ENABLE_TEST_DECK then
    SMODS.Back {
        name = 'Hyper Definition Test Deck',
        key = 'hyperdef-test',
        pos = { x = 0, y = 0 },
        loc_txt = {
            name = 'Hyper Definition Test Deck',
            text = {
                'This is a Test Deck',
                'for {C:attention}Hyper Definition{}'
            },
        },
        unlocked = true,
        discovered = true,
        apply = function()
            G.E_MANAGER:add_event(Event({
                func = function(self, back)
                    -- ease_dollars(10)
                    -- G.GAME.round_resets.hands = 5
                    -- G.GAME.round_resets.discards = 4
                    -- deck_add_joker('j_hyperdef_adam')
                    return true
                end
            }))
        end
    }
end

SMODS.Back {
    name = 'Hyper Deck',
    key = 'hyper',
    pos = { x = 5, y = 2 },
    loc_txt = {
        name = 'Hyper Deck',
        text = {
            'First shop has a',
            '{C:attention}Hyper Pack{}'
        }
    },
    unlocked = true,
    discovered = true,
    apply = function(self, back)
        -- Replace a booster with the Hyper Pack in the first shop
        G.E_MANAGER:add_event(Event({
            blocking = false,
            blockable = false,
            func = function()
                if G.shop_booster then
                    if G.shop_booster.cards[#G.shop_booster.cards] then
                        G.shop_booster.cards[#G.shop_booster.cards] = nil
                        local card = Card(
                            G.shop_booster.T.x + G.shop_booster.T.w/2,
                            G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27,
                            G.P_CARDS.empty,
                            G.P_CENTERS['p_hyperdef_hyper'],
                            {bypass_discovery_center = true, bypass_discovery_ui = true}
                        )
                        card:start_materialize()
                        G.shop_booster:emplace(card)
                        create_shop_card_ui(card)
                        return true
                    end
                end
                return false
            end
        }))
    end
}

-- This booster is only for the Hyper Deck
SMODS.Booster {
    key = 'hyper',
    atlas = atlas_boosters.key,
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Hyper Pack',
        group_name = 'Hyper Pack',
        text = {
            'Choose {C:attention}#1#{} of up to',
            '{C:attention}#2#{} {C:attention}Hyper Definition{}',
            '{C:joker}Joker{} cards'
        }
    },
    config = {
        extra = 11,
        choose = 1,
        jokers = {
            'j_hyperdef_shopcorp',
            'j_hyperdef_horse_plinko',
            'j_hyperdef_buffer_joker',
            'j_hyperdef_wooden_kaiju',
            'j_hyperdef_magazine',
            'j_hyperdef_alchemy',
            'j_hyperdef_hydra',
            'j_hyperdef_fish_satan',
            'j_hyperdef_creature',
            'j_hyperdef_oxoboo',
            'j_hyperdef_adam'
        }
    },
    discovered = true,
    cost = 2,
    weight = 0,
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.choose } }
    end,
    create_card = function(self, card, i)
        if i <= #self.config.jokers then
            return create_card('Joker', G.jokers, nil, nil, nil, nil, self.config.jokers[i], 'pack')
        end
    end
}
