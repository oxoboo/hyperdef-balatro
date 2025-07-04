-- Any joker card copied by Stead will have 'stead' appended to the text shown.
local generate_UIBox_ability_table_original = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table()
    local full_UI_table = generate_UIBox_ability_table_original(self)
    if self.ability.hyperdef_name_append then
        -- NOTE: In Steamodded 1.0.0~BETA-0301, the object is `full_UI_table.name[1].config.object`
        local assembled_string = full_UI_table.name[1].nodes[1].config.object.string .. self.ability.hyperdef_name_append
        full_UI_table.name[1].nodes[1].config.object = DynaText({
            string = { assembled_string },
            -- values from localize()
            colours = { G.C.UI.TEXT_LIGHT },
            bump = true,
            silent = true,
            pop_in = 0,
            pop_in_rate = 4,
            maxw = 5,
            shadow = true,
            y_offset = -0.6,
            spacing = math.max(0, 0.32 * (17 - #assembled_string)),
            scale =  (0.55 - 0.004 * #assembled_string)
        })
    end
    return full_UI_table
end

local start_run_original = Game.start_run
function Game:start_run(args)
    start_run_original(self, args)
    if args.challenge then
        local _ch = args.challenge
        if _ch.rules then
            if _ch.rules.custom then
                for k, v in ipairs(_ch.rules.custom) do
                    if v.id == 'hyperdef_faster_scaling' then
                        G.GAME.modifiers.scaling = 2
                    end
                end
            end
        end
    end
end
