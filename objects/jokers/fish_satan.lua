SMODS.Joker {
    key = 'fish_satan',
    config = {
        extra = {
            xmult = 3,
            value = '6',
            id = 6
        }
    },
    blueprint_compat = true,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 1, y = 1 },
    cost = 8,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                localize(card.ability.extra.value, 'ranks')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local _, _, _, scoring_hand, _ = G.FUNCS.get_poker_hand_info(G.play.cards)
            for _, v in pairs(scoring_hand) do
                if v:get_id() == card.ability.extra.id and not v.debuff then
                    return { xmult = card.ability.extra.xmult }
                end
            end
        end
    end
}
