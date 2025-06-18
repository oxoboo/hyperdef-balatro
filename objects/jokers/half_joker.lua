SMODS.Joker {
    key = 'half_joker',
    config = {
        extra = {
            min_scoring = 3,
            mult = 20
        }
    },
    blueprint_compat = true,
    rarity = 2,
    -- atlas = 'jokers',
    -- pos = { x = 0, y = 0 },
    cost = 5,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.min_scoring
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local _, _, _, scoring_hand, _ = G.FUNCS.get_poker_hand_info(G.play.cards)
            if #scoring_hand >= card.ability.extra.min_scoring then
                return { mult = card.ability.extra.mult }
            end
        end
    end
}
