SMODS.Joker {
    key = 'buffer_joker',
    config = {
        extra = {
            every = 6,
            remaining = 5,
            give = 1,
            hands_played_at_create = nil,
        }
    },
    blueprint_compat = false,
    rarity = 1,
    atlas = 'hyperdef',
    pos = { x = 1, y = 0 },
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local remaining_message = localize {
            type = 'variable',
            key = (card.ability.extra.remaining == 0 and 'loyalty_active' or 'loyalty_inactive'),
            vars = { card.ability.extra.remaining }
        }
        return {
            vars = {
                card.ability.extra.every,
                card.ability.extra.give,
                remaining_message
            }
        }
    end,
    calculate = function(self, card, context)
        local extra = card.ability.extra
        if not extra.hands_played_at_create then
            extra.hands_played_at_create = G.GAME.hands_played
        end
        if context.before and not context.blueprint and extra.remaining == 0 then
            -- Add +1 hand before hand is evaluated to prevent game over
            -- when number of hands left reaches zero
            ease_hands_played(extra.give)
            for _, v in pairs(G.play.cards) do
                v:set_debuff(true)
            end
        end
        if context.after and not context.blueprint then
            -- Game does not immediately update `G.GAME.hands_played` when
            -- `context.after == true`, add 1 to hands played
            extra.remaining = extra.every - (((G.GAME.hands_played - extra.hands_played_at_create + 1) % extra.every) + 1)
            if extra.remaining == 0 then
                local eval = function(card)
                    return (card.ability.extra.remaining == 0)
                end
                juice_card_until(card, eval, true)
                return { message = localize('k_active_ex') }
            elseif extra.remaining == extra.every - 1 then
                -- Reset debuff state of played cards
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _, v in pairs(G.play.cards) do
                            v:juice_up()
                            G.GAME.blind:debuff_card(v)
                        end
                        return true
                    end
                }))
                return { message = localize('k_reset') }
            end
        end
    end
}
