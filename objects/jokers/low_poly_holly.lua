SMODS.Joker {
    key = 'low_poly_holly',
    blueprint_compat = false,
    rarity = 4,
    atlas = 'jokers',
    pos = { x = 1, y = 2 },
    soul_pos = { x = 2, y = 2 },
    cost = 20,
    discovered = true,
    calculate = function(self, card, context)
        if context.before and not context.repetition and not context.blueprint then
            local face_card_in_hand = false
            for _, v in pairs(G.hand.cards) do
                if v:is_face() then
                    face_card_in_hand = true
                end
            end
            if face_card_in_hand and #G.play.cards == 1 then
                -- Show message and convert cards held in hand before hand
                -- is evaluated
                attention_text({
                    text = localize('k_hyperdef_converted'),
                    scale = 0.7,
                    hold = 1.4,
                    backdrop_colour = G.C.FILTER,
                    align = 'bm',
                    major = card,
                    offset = { x = 0, y = 0.05 * card.T.h }
                })
                play_sound('generic1')
                card:juice_up()
                for _, v in pairs(G.hand.cards) do
                    if v:is_face() then
                        copy_card(G.play.cards[1], v)
                        v:juice_up()
                    end
                end
            end
        end
    end
}
