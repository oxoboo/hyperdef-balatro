SMODS.Joker {
    key = 'stead_dog',
    config = {
        extra = {
            percent = 40,
            decrease = 8
        }
    },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 1,
    atlas = 'jokers_large',
    pos = { x = 1, y = 0 },
    cost = 4,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.percent,
                card.ability.extra.decrease
            }
        }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.GAME.chips and G.GAME.blind.chips then
                        local chips = G.GAME.blind.chips * (card.ability.extra.percent / 100) - G.GAME.chips
                        G.GAME.chips = G.GAME.chips + chips
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = tostring(chips), colour = G.C.CHIPS })
                        save_run()
                        return true
                    end
                    return false
                end
            }))
        end
        if context.end_of_round and not context.repetiton and not context.blueprint and context.game_over == false then
            card.ability.extra.percent = card.ability.extra.percent - card.ability.extra.decrease
            if card.ability.extra.percent > 0 then
                return {
                    message = '-' .. card.ability.extra.decrease .. '%',
                    colour = G.C.BLUE
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        G.jokers:remove_card(card)
                        card:remove()
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}
