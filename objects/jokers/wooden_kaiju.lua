SMODS.Joker {
    key = 'wooden_kaiju',
    config = {
        extra = {
            gain = 4,
            mult = 0
        }
    },
    blueprint_compat = true,
    rarity = 1,
    atlas = 'jokers',
    pos = { x = 0, y = 0 },
    cost = 5,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.gain,
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
        end
        if context.end_of_round and not context.repetition and not context.blueprint and context.game_over == false then
            card.ability.extra.mult = 0
        end
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}
