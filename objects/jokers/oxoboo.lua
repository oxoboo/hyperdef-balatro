SMODS.Joker {
    key = 'oxoboo',
    blueprint_compat = true,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 4, y = 1 },
    cost = 7,
    discovered = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and G.GAME.current_round.hands_played == 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = SMODS.add_card({ set = 'Tarot', area = G.consumeables, key_append = 'oxoboo' })
                    c:set_edition('e_negative', true)
                    return true
                end
            }))
            return { message = localize('k_hyperdef_nice') }
        end
    end
}
