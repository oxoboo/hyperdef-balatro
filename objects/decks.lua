local ENABLE_TEST_DECK = false

local function add_joker(forced_key, card_area, key_append)
    local card = create_card('Joker', card_area, nil, nil, nil, nil, forced_key, key_append)
    card:add_to_deck()
    card:start_materialize()
    card_area:emplace(card)
    return card
end

-- Boosters can be added after G.shop_booster is initiated
local function shop_add_booster(forced_key)
    local booster = Card(
        G.shop_booster.T.x + G.shop_booster.T.w / 2,
        G.shop_booster.T.y,
        G.CARD_W * 1.27,
        G.CARD_H * 1.27,
        G.P_CARDS.empty,
        G.P_CENTERS[forced_key],
        { bypass_discovery_center = true, bypass_discovery_ui = true }
    )
    booster:start_materialize()
    G.shop_booster:emplace(booster)
    create_shop_card_ui(booster)
    return booster
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
                    -- add_joker('j_hyperdef_adam', G.jokers, 'deck')
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
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false then
            G.E_MANAGER:add_event(Event({
                blocking = false,
                func = function()
                    if G.shop_jokers and G.shop_jokers.cards and #G.shop_jokers.cards >= G.GAME.shop.joker_max then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.4,
                            func = function()
                                local key = pseudorandom_element(hyperdef_shop_get_keys(), pseudoseed('deck'))
     							create_shop_card_ui(add_joker(key, G.shop_jokers, 'deck'))
                                G.GAME.shop.joker_max = G.GAME.shop.joker_max + 1
                                G.shop_jokers.config.card_limit = G.GAME.shop.joker_max
                                G.shop_jokers.T.w = G.GAME.shop.joker_max * 1.01 * G.CARD_W
                                G.shop:recalculate()
                                G.GAME.shop.joker_max = G.GAME.shop.joker_max - 1
                                return true
                            end
                        }))
                        return true
                    end
                    return false
                end
            }))
        end
    end
}
