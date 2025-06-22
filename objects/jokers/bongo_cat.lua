SMODS.Joker {
    key = 'bongo_cat',
    config = {
        extra = {
            xmult = 2,
            pairs = {}
        }
    },
    blueprint_compat = true,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 3, y = 1 },
    cost = 8,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize('Pair', 'poker_hands'),
                card.ability.extra.xmult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.pairs = {}
            local cards = {}
            for _, v in pairs(G.hand.cards) do
                table.insert(cards, v)
            end
            while (#cards > 0) do
                local c = table.remove(cards, 1)
                for i = 1, #cards do
                    if c:get_id() == cards[i]:get_id() then
                        table.insert(card.ability.extra.pairs, { c, table.remove(cards, i) })
                        break
                    end
                end
            end
        end
        if context.cardarea == G.hand and context.other_card and not context.repetition and not context.end_of_round then
            for i = 1, #card.ability.extra.pairs do
                local pair = card.ability.extra.pairs[i]
                if context.other_card == pair[1] then
                    return { xmult = card.ability.extra.xmult }
                end
            end
        end
        if context.after then
            card.ability.extra.pairs = {}
        end
    end
}
