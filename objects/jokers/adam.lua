SMODS.Joker {
    key = 'adam',
    config = {
        extra = {
            rounds_required = 12,
            rounds_passed = 0,
            message_triggered = false
        }
    },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 0, y = 1 },
    cost = 3,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.rounds_required,
                card.ability.extra.rounds_passed,
                card.ability.extra.rounds_required
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            card.ability.extra.rounds_passed = card.ability.extra.rounds_passed + 1
            if card.ability.extra.message_triggered == false and card.ability.extra.rounds_passed >= card.ability.extra.rounds_required then
                card.ability.extra.message_triggered = true
                local eval = function(card)
                    return card
                end
                juice_card_until(card, eval, true)
                return { message = localize('k_active_ex') }
            end
        end
        if context.selling_self and not context.blueprint and card.ability.extra.rounds_passed >= card.ability.extra.rounds_required then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('timpani')
                    local c = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'adam')
                    -- Secret part of ability: If Adam is negative, make the legendary joker negative too
                    if card.edition then
                        if card.edition.negative then
                            c:set_edition('e_negative', true)
                        end
                    end
                    c:add_to_deck()
                    G.jokers:emplace(c)
                    return true
                end
            }))
        end
    end
}
