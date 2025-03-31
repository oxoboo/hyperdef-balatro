SMODS.Joker {
    key = 'alchemy',
    blueprint_compat = false,
    rarity = 2,
    atlas = 'hyperdef',
    pos = { x = 3, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.other_card and not context.blueprint then
            -- Only the leftmost Alchemy should be triggered every hand/round.
            -- If there is another Alchemy to the left of this card, do not
            -- trigger this card's ability.
            local is_leftmost_alchemy = true
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and G.jokers.cards[i].config.center.key == 'j_hyperdef_alchemy' then
                    is_leftmost_alchemy = false
                    break
                end
                if G.jokers.cards[i] == card then
                    break
                end
            end
            if not context.other_card.debuff and is_leftmost_alchemy then
                if context.end_of_round then
                    if context.other_card.config.center == G.P_CENTERS.m_steel then
                        return { dollars = G.P_CENTERS.m_gold.config.h_dollars }
                    end
                else
                    if context.other_card.config.center == G.P_CENTERS.m_gold then
                        return { xmult = G.P_CENTERS.m_steel.config.h_x_mult }
                    end
                end
            end
        end
    end
}
