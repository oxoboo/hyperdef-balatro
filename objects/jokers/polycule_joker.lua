SMODS.Joker {
    key = 'polycule_joker',
    config = {
        extra = {
            value = 'Queen',
            id = 12,
            minimum = 3,
            num_rank_played = 0
        }
    },
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.value, 'ranks'),
                card.ability.extra.minimum,
                localize(card.ability.extra.value, 'ranks')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.num_rank_played = 0
            for _, v in pairs(G.play.cards) do
                print(#G.play.cards)
                if v:get_id() == card.ability.extra.id then
                    card.ability.extra.num_rank_played = card.ability.extra.num_rank_played + 1
                end
            end
            for _, v in pairs(G.hand.cards) do
                if v:get_id() == card.ability.extra.id then
                    card.ability.extra.num_rank_played = card.ability.extra.num_rank_played + 1
                end
            end
        end
        if context.repetition and card.ability.extra.num_rank_played >= card.ability.extra.minimum then
            if context.other_card:get_id() == card.ability.extra.id then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card
                }
            end
        end
    end
}
