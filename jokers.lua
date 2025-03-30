local atlas = SMODS.Atlas {
    key = 'hyperdef',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

local atlas_large = SMODS.Atlas {
    key = 'hyperdef_large',
    path = 'JokersLarge.png',
    px = 142,
    py = 190
}

SMODS.Joker {
    key = 'shopcorp',
    config = { extra = { mult = 0, gain = 3 } },
    blueprint_compat = true,
    rarity = 1,
    atlas = atlas.key,
    pos = { x = 0, y = 0 },
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
            return { mult = card.ability.extra.mult }
        end
        if context.removed and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.gain * #context.removed)
            return { message = localize('k_upgrade_ex') }
        end
    end
}

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
    atlas = atlas_large.key,
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

SMODS.Joker {
    key = 'buffer_joker',
    config = {
        extra = {
            every = 6,
            remaining = 5,
            give = 1,
            hands_played_at_create = nil,
        }
    },
    blueprint_compat = false,
    rarity = 1,
    atlas = atlas.key,
    pos = { x = 1, y = 0 },
    cost = 4,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local remaining_message = localize {
            type = 'variable',
            key = (card.ability.extra.remaining == 0 and 'loyalty_active' or 'loyalty_inactive'),
            vars = { card.ability.extra.remaining }
        }
        return {
            vars = {
                card.ability.extra.every,
                card.ability.extra.give,
                remaining_message
            }
        }
    end,
    calculate = function(self, card, context)
        local extra = card.ability.extra
        if not extra.hands_played_at_create then
            extra.hands_played_at_create = G.GAME.hands_played
        end
        if context.before and not context.blueprint and extra.remaining == 0 then
            -- Add +1 hand before hand is evaluated to prevent game over
            -- when number of hands left reaches zero
            ease_hands_played(extra.give)
            for _, v in pairs(G.play.cards) do
                v:set_debuff(true)
            end
        end
        if context.after and not context.blueprint then
            -- Game does not immediately update `G.GAME.hands_played` when
            -- `context.after == true`, add 1 to hands played
            extra.remaining = extra.every - (((G.GAME.hands_played - extra.hands_played_at_create + 1) % extra.every) + 1)
            if extra.remaining == 0 then
                local eval = function(card)
                    return (card.ability.extra.remaining == 0)
                end
                juice_card_until(card, eval, true)
                return { message = localize('k_active_ex') }
            elseif extra.remaining == extra.every - 1 then
                -- Reset debuff state of played cards
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _, v in pairs(G.play.cards) do
                            v:juice_up()
                            G.GAME.blind:debuff_card(v)
                        end
                        return true
                    end
                }))
                return { message = localize('k_reset') }
            end
        end
    end
}

SMODS.Joker {
    key = 'wooden_kaiju',
    config = {
        extra = {
            gain = 4,
            mult = 0
        }
    },
    blueprint_compat = true,
    rarity = 1,
    atlas = atlas.key,
    pos = { x = 2, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.gain,
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
        end
        if context.end_of_round and not context.repetition and not context.blueprint and context.game_over == false then
            card.ability.extra.mult = 0
        end
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'stead_dog',
    config = {
        extra = {
            percent = 30,
            decrease = 6
        }
    },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 1,
    atlas = atlas_large.key,
    pos = { x = 3, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.percent,
                card.ability.extra.decrease
            }
        }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local chips = G.GAME.blind.chips * (card.ability.extra.percent / 100)
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.chips = chips
                    return true
                end
            }))
            return {
                message = '=' .. chips,
                colour = G.C.BLUE
            }
        end
        if context.end_of_round and not context.repetiton and not context.blueprint and context.game_over == false then
            card.ability.extra.percent = card.ability.extra.percent - card.ability.extra.decrease
            if card.ability.extra.percent > 0 then
                return {
                    message = '-' .. card.ability.extra.decrease,
                    colour = G.C.BLUE
                }
            else
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        G.jokers:remove_card(card)
                        card:remove()
                        return true
                    end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'magazine',
    config = { extra = { spend = 3 } },
    blueprint_compat = true,
    rarity = 2,
    atlas = atlas_large.key,
    pos = { x = 0, y = 0 },
    cost = 1,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.spend } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'mag')
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))
            return { dollars = -card.ability.extra.spend }
        end
    end
}

SMODS.Joker {
    key = 'alchemy',
    blueprint_compat = false,
    rarity = 2,
    atlas = atlas.key,
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

SMODS.Joker {
    key = 'hydra',
    config = { extra = { chips = 100 } },
    blueprint_compat = true,
    rarity = 2,
    atlas = atlas_large.key,
    pos = { x = 1, y = 0 },
    cost = 6,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    -- `context.first_hand_drawn` may be `true` more than once per round.
    -- Instead, events are set on `context.setting_blind`
    calculate = function(self, card, context)
        if context.setting_blind then
            -- variable set by Hydra
            if not G.GAME.deck_buffer then
                G.GAME.deck_buffer = 0
            end
            if #G.deck.cards - G.GAME.deck_buffer > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.deck_buffer = 0
                        draw_card(G.deck, G.hand, nil, 'up')
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 1.3,
                            func = function()
                                G.hand.cards[1]:remove()
                                play_sound('generic1')
                                card:juice_up()
                                attention_text({
                                    text = pseudorandom_element({
                                        localize('k_hyperdef_hydra1'),
                                        localize('k_hyperdef_hydra2'),
                                        localize('k_hyperdef_hydra3')
                                    }),
                                    scale = 0.7,
                                    hold = 1,
                                    backdrop_colour = G.C.FILTER,
                                    align = 'bm',
                                    major = card,
                                    offset = { x = 0, y = 0.05 * card.T.h }
                                })
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.deck_buffer = G.GAME.deck_buffer + 1
            end
        end
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end
    end
}

SMODS.Joker {
    key = 'fish_satan',
    config = { extra = { xmult = 3, value = '6', id = 6 } },
    blueprint_compat = true,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 0, y = 1 },
    cost = 8,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                localize(card.ability.extra.value, 'ranks')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local _, _, _, scoring_hand, _ = G.FUNCS.get_poker_hand_info(G.play.cards)
            for _, v in pairs(scoring_hand) do
                if v:get_id() == card.ability.extra.id and not v.debuff then
                    return { xmult = card.ability.extra.xmult }
                end
            end
        end
    end
}

SMODS.Joker {
    key = 'creature',
    config = { extra = { xmult = 1.75 } },
    blueprint_compat = true,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 1, y = 1 },
    cost = 7,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card.config.center ~= G.P_CENTERS.c_base then
                return {
                    xmult = card.ability.extra.xmult,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'oxoboo',
    blueprint_compat = true,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 2, y = 1 },
    cost = 7,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and G.GAME.current_round.hands_played == 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'oxo')
                    c:set_edition('e_negative', true)
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    return true
                end
            }))
            return { message = localize('k_hyperdef_nice') }
        end
    end
}

SMODS.Joker {
    key = 'adam',
    config = {
        extra = {
            rounds_required = 12,
            rounds_passed = 0,
            message_triggered = false
        }
    },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 3, y = 1 },
    cost = 3,
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.rounds_required,
                card.ability.extra.rounds_passed,
                card.ability.extra.rounds_required
            }
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            card.ability.extra.rounds_passed = card.ability.extra.rounds_passed + 1
            if card.ability.extra.message_triggered == false and card.ability.extra.rounds_passed >= card.ability.extra.rounds_required then
                card.ability.extra.message_triggered = true
                local eval = function(card)
                    return card
                end
                juice_card_until(card, eval, true)
                return { message = localize('k_active_ex') }
            end
        end
        if context.selling_self and not context.blueprint and card.ability.extra.rounds_passed >= card.ability.extra.rounds_required then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('timpani')
                    local c = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'adam')
                    -- Secret part of ability: If Adam is negative, make the legendary joker negative too
                    if card.edition then
                        if card.edition.negative then
                            c:set_edition('e_negative', true)
                        end
                    end
                    c:add_to_deck()
                    G.jokers:emplace(c)
                    return true
                end
            }))
        end
    end
}

SMODS.Joker {
    key = 'manic',
    config = { extra = { active = false } },
    blueprint_compat = false,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 0, y = 2 },
    cost = 7,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            card.ability.extra.active = true
            local eval = function(card)
                return card.ability.extra.active
            end
            juice_card_until(card, eval, true)
        end
        if context.end_of_round and not context.blueprint then
            card.ability.extra.active = false
        end
        if card.ability.extra.active and context.pre_discard and not context.blueprint then
            card.ability.extra.active = false
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.15,
                    func = function()
                        -- `percent` is the pitch of the sounds played, the
                        -- values used below are similar to the ones used for
                        -- Sigil or Ouija
                        local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                        play_sound('card1', percent, 0.6)
                        if G.hand.highlighted[i].facing == 'front' then
                            G.hand.highlighted[i]:flip()
                        end
                        return true
                    end
                }))
            end
            delay(0.2)
            for i = 1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.15,
                    func = function()
                        local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
                        G.hand.highlighted[i]:set_base(pseudorandom_element(G.P_CARDS, pseudoseed('manic')))
                        play_sound('tarot2', percent, 0.6)
                        G.hand.highlighted[i]:flip()
                        return true
                    end
                }))
            end
            delay(1.3)
        end
    end
}

SMODS.Joker {
    key = 'stead',
    config = { extra = { sell_cost = 0 } },
    blueprint_compat = false,
    perishable_compat = false,
    eternal_compat = false,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 1, y = 2 },
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
                if not c.ability.hyperdef_name_append then
                    c.ability.hyperdef_name_append = 'stead'
                else
                    c.ability.hyperdef_name_append = c.ability.hyperdef_name_append .. 'stead'
                end
                c:add_to_deck()
                c:start_materialize()
                G.jokers:emplace(c)
            end
        end
    end
}

-- Any joker card copied by Stead will have 'stead' appended to its name.
local generate_UIBox_ability_table_original = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table()
    local full_UI_table = generate_UIBox_ability_table_original(self)
    if self.ability.hyperdef_name_append then
        local assembled_string = full_UI_table.name[1].config.object.string .. self.ability.hyperdef_name_append
        full_UI_table.name[1].config.object = DynaText({
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

SMODS.Joker {
    key = 'low_poly_holly',
    blueprint_compat = false,
    rarity = 4,
    atlas = atlas.key,
    pos = { x = 2, y = 2 },
    soul_pos = { x = 3, y = 2 },
    cost = 20,
    unlocked = true,
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
