local function reset_blind_select_opt(opt, type)
    local par = opt.parent
    local bg_color = nil
    if type == 'Boss' then
        bg_color = mix_colours(G.C.BLACK, get_blind_main_colour(type), 0.8)
    else
        bg_color = lighten(G.C.BLACK, 0.07)
    end
    opt:remove()
    opt = UIBox{
        T = { par.T.x, 0, 0, 0 },
        definition = {
            n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR },
            nodes = { UIBox_dyn_container(
                { create_UIBox_blind_choice(type) },
                false,
                get_blind_main_colour(type),
                bg_color
            )}
        },
        config = {
            align = "bmi",
            offset = {x = 0, y = G.ROOM.T.y + 9},
            major = par,
            xy_bond = 'Weak'
        }
    }
    par.config.object = opt
    par.config.object:recalculate()
    opt.parent = par
    opt.alignment.offset.y = 0
    return opt
end

SMODS.Consumable({
    set = 'Spectral',
    key = 'cutaway',
    config = {
        ante_mod = -1,
        to_dollars = 0,
    },
    pos = { x = 0, y = 0 },
    atlas = 'tarots_large',
    cost = 4,
    discovered = true,
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                self.config.ante_mod,
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
                ease_ante(self.config.ante_mod)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante + self.config.ante_mod
                ease_dollars(-G.GAME.dollars + self.config.to_dollars)
                -- change the blind amount during a round
                G.E_MANAGER:add_event(Event({
                    func = function()
                        if G.GAME.blind then
                            G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante) * G.GAME.blind.mult * G.GAME.starting_params.ante_scaling
                            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                        end
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.blind_select_opts.small = reset_blind_select_opt(G.blind_select_opts.small, 'Small')
                        G.blind_select_opts.big = reset_blind_select_opt(G.blind_select_opts.big, 'Big')
                        G.blind_select_opts.boss = reset_blind_select_opt(G.blind_select_opts.boss, 'Boss')
                        return true
                    end
                }))
                return true
            end
        }))
    end
})
