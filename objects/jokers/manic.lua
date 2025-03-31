SMODS.Joker {
    key = 'manic',
    config = { extra = { active = false } },
    blueprint_compat = false,
    rarity = 3,
    atlas = 'hyperdef',
    pos = { x = 0, y = 2 },
    cost = 7,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            card.ability.extra.active = true
            local eval = function(card)
                return card.ability.extra.active
            end
            juice_card_until(card, eval, true)
        end
        if context.end_of_round and not context.blueprint then
            card.ability.extra.active = false
        end
        if card.ability.extra.active and context.pre_discard and not context.blueprint then
            card.ability.extra.active = false
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.15,
                    func = function()
                        -- `percent` is the pitch of the sounds played, the
                        -- values used below are similar to the ones used for
                        -- Sigil or Ouija
                        local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                        play_sound('card1', percent, 0.6)
                        if G.hand.highlighted[i].facing == 'front' then
                            G.hand.highlighted[i]:flip()
                        end
                        return true
                    end
                }))
            end
            delay(0.2)
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.15,
                    func = function()
                        local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                        G.hand.highlighted[i]:set_base(pseudorandom_element(G.P_CARDS, pseudoseed('manic')))
                        play_sound('tarot2', percent, 0.6)
                        G.hand.highlighted[i]:flip()
                        return true
                    end
                }))
            end
            delay(1.3)
        end
    end
}
