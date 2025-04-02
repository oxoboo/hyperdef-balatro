SMODS.Joker {
    key = 'oxoboo',
    blueprint_compat = true,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 3, y = 1 },
    cost = 7,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and G.GAME.current_round.hands_played == 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'oxo')
                    c:set_edition('e_negative', true)
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    return true
                end
            }))
            return { message = localize('k_hyperdef_nice') }
        end
    end
}
