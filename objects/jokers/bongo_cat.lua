SMODS.Joker {
    key = 'bongo_cat',
    config = {
        extra = {
            xmult = 2,
            cards = {}
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
            card.ability.extra.cards = {}
            for _, v in pairs(G.hand.cards) do
                table.insert(card.ability.extra.cards, v)
            end
        end
        if context.cardarea == G.hand and context.other_card then
            local c1 = nil
            for i = 1, #card.ability.extra.cards do
                if card.ability.extra.cards[i] == context.other_card then
                    c1 = table.remove(card.ability.extra.cards, i)
                    break
                end
            end
            if c1 then
                for i = 1, #card.ability.extra.cards do
                    if c1:get_id() == card.ability.extra.cards[i]:get_id() then
                        local c2 =  card.ability.extra.cards[i]
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                c2:juice_up()
                                return true
                            end
                        }))
                        table.remove(card.ability.extra.cards, i)
                        return { xmult = card.ability.extra.xmult }
                    end
                end
            end
        end
    end
}
