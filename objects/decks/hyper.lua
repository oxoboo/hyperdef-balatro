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
