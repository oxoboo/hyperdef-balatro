SMODS.Joker {
    key = 'horse_plinko',
    config = {
        extra = {
            chances_outcomes = {
                { 2, 1 },
                { 2, 50 },
                { 2, 100 },
                { 1, 250 }
            }
        }
    },
    blueprint_compat = true,
    rarity = 1,
    atlas = 'jokers_large',
    pos = { x = 2, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local vars = {}
        local num_outcomes = 0
        for _, v in pairs(card.ability.extra.chances_outcomes) do
            num_outcomes = num_outcomes + v[1]
        end
        for _, v in pairs(card.ability.extra.chances_outcomes) do
            table.insert(vars, v[1])
            table.insert(vars, num_outcomes)
            table.insert(vars, v[2])
        end
        return { vars = vars }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local outcomes = {}
            for _, v in pairs(card.ability.extra.chances_outcomes) do
                for i = 1, v[1] do
                    table.insert(outcomes, v[2])
                end
            end
            return { chips = pseudorandom_element(outcomes, pseudoseed('horse_plinko')) }
        end
    end
}
