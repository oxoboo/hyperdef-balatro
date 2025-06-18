SMODS.Consumable({
    set = 'Spectral',
    key = 'cutaway',
    config = {
        mod_antes = -1,
        to_dollars = 0,
    },
    pos = { x = 0, y = 0 },
    atlas = 'tarots_large',
    cost = 4,
    discovered = true,
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                self.config.mod_antes,
                self.config.to_dollars
            }
        }
    end,
    can_use = function()
        return G.GAME.round_resets.ante > 0
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                ease_ante(self.config.mod_antes)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + self.config.mod_antes
                ease_dollars(-G.GAME.dollars + self.config.to_dollars)
                return true
            end
        }))
    end
})
