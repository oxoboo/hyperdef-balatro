SMODS.Joker {
    key = 'hydra',
    config = { extra = { chips = 100 } },
    blueprint_compat = true,
    rarity = 2,
    atlas = 'jokers_large',
    pos = { x = 2, y = 0 },
    cost = 6,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    -- `context.first_hand_drawn` may be `true` more than once per round.
    -- Instead, events are set on `context.setting_blind`
    calculate = function(self, card, context)
        if context.setting_blind then
            -- variable set by Hydra
            if not G.GAME.deck_buffer then
                G.GAME.deck_buffer = 0
            end
            if #G.deck.cards - G.GAME.deck_buffer > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.deck_buffer = 0
                        draw_card(G.deck, G.hand, nil, 'up')
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 1.3,
                            func = function()
                                G.hand.cards[1]:remove()
                                play_sound('generic1')
                                card:juice_up()
                                attention_text({
                                    text = pseudorandom_element({
                                        localize('k_hyperdef_hydra1'),
                                        localize('k_hyperdef_hydra2'),
                                        localize('k_hyperdef_hydra3')
                                    }),
                                    scale = 0.7,
                                    hold = 1,
                                    backdrop_colour = G.C.FILTER,
                                    align = 'bm',
                                    major = card,
                                    offset = { x = 0, y = 0.05 * card.T.h }
                                })
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.deck_buffer = G.GAME.deck_buffer + 1
            end
        end
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end
    end
}
