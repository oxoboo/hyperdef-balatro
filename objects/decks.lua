local ENABLE_TEST_DECK = false

-- Can be added to any card area for testing.
local function add_booster(forced_key, card_area)
    local booster = Card(
        card_area.T.x + card_area.T.w / 2,
        card_area.T.y,
        G.CARD_W * 1.27,
        G.CARD_H * 1.27,
        G.P_CARDS.empty,
        G.P_CENTERS[forced_key],
        { bypass_discovery_center = true, bypass_discovery_ui = true }
    )
    booster:start_materialize()
    card_area:emplace(booster)
    create_shop_card_ui(booster)
    return booster
end

if ENABLE_TEST_DECK then
    SMODS.Back {
        name = 'Hyper Definition Test Deck',
        key = 'test',
        pos = { x = 0, y = 0 },
        discovered = true,
        apply = function()
            G.E_MANAGER:add_event(Event({
                func = function(self, back)
                    -- ease_dollars(10)
                    -- G.GAME.round_resets.hands = 5
                    -- G.GAME.round_resets.discards = 4
                    -- SMODS.add_card({ set = 'Joker', area = G.jokers, key = 'j_hyperdef_adam', key_append = 'deck' })
                    -- add_booster('p_hyperdef_hyper_normal', G.consumeables)
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
                                local key_append = 'deck'
                                local key = pseudorandom_element(hyperdef_shop_get_keys(), pseudoseed(key_append))
     							local joker = SMODS.add_card({ set = 'Joker', area = G.shop_jokers, key = key, key_append = key_append })
                                create_shop_card_ui(joker)
                                joker:juice_up()
                                play_sound('generic1')
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
