local ENABLE_TEST_DECK = false

function deck_add_joker(forced_key)
    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'deck')
    card:add_to_deck()
    card:start_materialize()
    G.jokers:emplace(card)
end

if ENABLE_TEST_DECK then
    SMODS.Back {
        name = 'Hyper Definition Test Deck',
        key = 'test',
        pos = { x = 0, y = 0 },
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
    atlas = 'enhancers',
    pos = { x = 0, y = 0 },
    discovered = true,
    apply = function(self, back)
        -- Replace boosters with Hyper Packs in the first shop
        G.E_MANAGER:add_event(Event({
            blocking = false,
            blockable = false,
            func = function()
                if G.shop_booster then
                    if G.shop_booster.cards[#G.shop_booster.cards] then
                        for i = 1, #G.shop_booster.cards do
                            G.shop_booster.cards[i] = nil
                        end
                        local booster1 = Card(
                            G.shop_booster.T.x + G.shop_booster.T.w / 2,
                            G.shop_booster.T.y,
                            G.CARD_W * 1.27,
                            G.CARD_H * 1.27,
                            G.P_CARDS.empty,
                            G.P_CENTERS['p_hyperdef_hyper1'],
                            { bypass_discovery_center = true, bypass_discovery_ui = true }
                        )
                        local booster2 = Card(
                            G.shop_booster.T.x + G.shop_booster.T.w / 2,
                            G.shop_booster.T.y,
                            G.CARD_W * 1.27,
                            G.CARD_H * 1.27,
                            G.P_CARDS.empty,
                            G.P_CENTERS['p_hyperdef_hyper2'],
                            { bypass_discovery_center = true, bypass_discovery_ui = true }
                        )
                        booster1:start_materialize()
                        booster2:start_materialize()
                        G.shop_booster:emplace(booster1)
                        G.shop_booster:emplace(booster2)
                        create_shop_card_ui(booster1)
                        create_shop_card_ui(booster2)
                        return true
                    end
                end
                return false
            end
        }))
    end
}
