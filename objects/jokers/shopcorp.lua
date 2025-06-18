SMODS.Joker {
    key = 'shopcorp',
    config = { extra = { mult = 0, gain = 3 } },
    blueprint_compat = true,
    rarity = 1,
    atlas = 'jokers',
    pos = { x = 1, y = 0 },
    cost = 4,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return { mult = card.ability.extra.mult }
        end
        if context.removed and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.gain * #context.removed)
            return { message = localize('k_upgrade_ex') }
        end
    end
}
