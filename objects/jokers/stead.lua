-- see override.lua
SMODS.Joker {
    key = 'stead',
    config = { extra = { sell_cost = 0 } },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 3,
    atlas = 'jokers',
    pos = { x = 0, y = 2 },
    cost = 8,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sell_cost } }
    end,
    update = function(self, card, front)
        card.sell_cost = card.ability.extra.sell_cost
    end,
    calculate = function(self, card, context)
        if context.selling_self and not context.blueprint then
            local other = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    other = G.jokers.cards[i + 1]
                    break
                end
            end
            if other then
                local c = copy_card(other)
                local append = 'stead'
                -- carry over the string from this card, if there is one
                if card.ability.hyperdef_name_append  then
                    append = card.ability.hyperdef_name_append .. 'stead'
                end
                if not c.ability.hyperdef_name_append then
                    c.ability.hyperdef_name_append = append
                else
                    c.ability.hyperdef_name_append = c.ability.hyperdef_name_append .. append
                end
                c:add_to_deck()
                c:start_materialize()
                G.jokers:emplace(c)
            end
        end
    end
}
