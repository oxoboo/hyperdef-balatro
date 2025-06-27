SMODS.Joker {
    key = 'creature',
    config = { extra = { xmult = 1.75 } },
    blueprint_compat = true,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 5, y = 1 },
    cost = 7,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.config.center ~= G.P_CENTERS.c_base then
                return {
                    xmult = card.ability.extra.xmult,
                    card = card
                }
            end
        end
    end
}
