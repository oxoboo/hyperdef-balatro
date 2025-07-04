SMODS.Joker {
    key = 'magazine',
    config = { extra = { spend = 3 } },
    blueprint_compat = true,
    rarity = 2,
    atlas = 'jokers_large',
    pos = { x = 3, y = 0 },
    cost = 1,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.spend } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({ set = 'Spectral', area = G.consumeables, key_append = 'mag' })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { dollars = -card.ability.extra.spend }
        end
    end
}
