local atlas = SMODS.Atlas {
    key = 'hyperdef',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

-- NOTE: Steamodded (1.0.0~ALPHA-1401d-STEAMODDED) has a bug that does not
-- keep a joker's sprite's width or height when joker is copied using Ankh
local atlas_large = SMODS.Atlas {
    key = 'hyperdef_large',
    path = 'JokersLarge.png',
    px = 142,
    py = 190
}

SMODS.Joker {
    key = 'shopcorp',
    loc_txt = {
        name = 'Shop-Corp Poster',
        text = {
            'This Joker gains {C:mult}+#1#{} Mult ',
            'when a card from deck is',
            '{C:attention}destroyed{}',
            '{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult){}'
        }
    },
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
            return {
                message = 'Upgraded!',
                colour = G.C.MULT,
                card = card
            }
        end
    end
}

SMODS.Joker {
    key = 'horse_plinko',
    loc_txt = {
        name = 'Horse Plinko',
        text = {
            '{C:green}#1# in #2#{} chance to give {C:chips}+#3#{} Chips',
            '{C:green}#4# in #5#{} chance to give {C:chips}+#6#{} Chips',
            '{C:green}#7# in #8#{} chance to give {C:chips}+#9#{} Chips',
            '{C:green}#10# in #11#{} chance to give {C:chips}+#12#{} Chips',
            '{C:inactive}(Chances cannot be modified){}'
        }
    },
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
    loc_txt = {
        name = 'Buffer Joker',
        text = {
            'Every {C:attention}#1#{} hands, give',
            '{C:blue}+#2#{} hands this round',
            'and {C:attention}debuff{} played hand',
            '{C:inactive}#3#{}'
        }
    },
    config = {
        extra = {
            active = false,
            every = 6,
            remaining = 5,
            give = 1,
            hands_played_at_create = 0,
            at_create_set = false,
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
        local remaining_message = nil
        if card.ability.extra.remaining == 0 then
            remaining_message = 'Active!'
        else
            remaining_message = card.ability.extra.remaining .. ' remaining'
        end
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
        if extra.at_create_set == false then
            extra.at_create_set = true
            extra.hands_played_at_create = G.GAME.hands_played
        end
        if context.before and card.ability.extra.active and not context.blueprint then
            -- Add +1 hand before hand is evaluated to prevent game over
            -- when number of hands left reaches zero
            ease_hands_played(extra.give)
            for _, v in pairs(G.play.cards) do
                v:set_debuff(true)
            end
        end
        if context.after and not context.blueprint then
            -- Game does not immediately update `G.GAME.hands_played` when
            -- `context.after = true`, add 1 to hands played
            extra.remaining = extra.every -
                (((G.GAME.hands_played - extra.hands_played_at_create + 1) % extra.every) + 1)
            if extra.remaining == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        extra.active = true
                        return true
                    end
                }))
                return { message = 'Active!' }
            elseif extra.active and extra.remaining == extra.every - 1 then
                extra.active = false
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _, v in pairs(G.play.cards) do
                            v:juice_up()
                            G.GAME.blind:debuff_card(v)
                        end
                        return true
                    end
                }))
                return { message = 'Reverted!' }
            end
        end
    end
}

SMODS.Joker {
    key = 'magazine',
    loc_txt  = {
        name = 'Magazine Subscription',
        text = {
            'When {C:attention}Blind{} is selected, spend',
            '{C:money}$#1#{} and create a {C:spectral}Spectral{} card',
            '{C:inactive}(Must have room)'
        }
    },
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
            return { p_dollars = -card.ability.extra.spend }
        end
    end
}

SMODS.Joker {
    key = 'alchemy',
    loc_txt = {
        name = 'Alchemy',
        text = {
            '{C:attention}Gold{} and {C:attention}Steel{}',
            'cards share',
            'abilities'
        }
    },
    blueprint_compat = false,
    rarity = 2,
    atlas = atlas.key,
    pos = { x = 2, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.cardarea == G.hand and context.other_card and not context.blueprint then
            if not context.other_card.debuff then
                if context.end_of_round then
                    if context.other_card.config.center == G.P_CENTERS.m_steel then
                        return { p_dollars = G.P_CENTERS.m_gold.config.h_dollars }
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
    loc_txt = {
        name = 'Hydra the Fox',
        text = {
            '{C:chips}+#1#{} Chips, {C:attention}destroy{}',
            'a {C:attention}random{} card in hand',
            'at start of round'
        }
    },
    config = {
        extra = {
            chips = 100,
            num_cards_to_destroy = 0,
        }
    },
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
    update = function(self, card, front)
        -- `G.STATE == G.STATES.SELECTING_HAND` after all cards are drawn from deck
        if G.STATE == G.STATES.SELECTING_HAND then
            local extra = card.ability.extra
            if extra.num_cards_to_destroy > 0 then
                local not_dissolved = {}
                for _, v in pairs(G.hand.cards) do
                    if not v.dissolve then
                        table.insert(not_dissolved, v)
                    end
                end
                if #not_dissolved > 0 then
                    local c = pseudorandom_element(not_dissolved, pseudoseed('hydra'))
                    c.dissolve = 0
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c:highlight(true)
                            play_sound('card1')
                            return true
                        end
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.7,
                        func = function()
                            c:start_dissolve(nil)
                            return true
                        end
                    }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = pseudorandom_element({'munch', 'crunch', 'slurp', 'nom' })})
                    extra.num_cards_to_destroy = extra.num_cards_to_destroy - 1
                end
            end
        end
    end,
    -- G.hand is empty when `context.first_hand_drawn = true`. If all cards
    -- in hand are removed, `context.first_hand_drawn` resets to `true`.
    -- Instead, the number of cards to be removed will be determined when
    -- `context.setting_blind = true`, and cards will be removed on update().
    calculate = function(self, card, context)
        if context.setting_blind then
            local extra = card.ability.extra
            extra.num_cards_to_destroy = extra.num_cards_to_destroy + 1
        end
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end
    end
}

SMODS.Joker {
    key = 'fish_satan',
    loc_txt = {
        name = 'Fish Satan',
        text = {
            '{X:mult,C:white} X#1# {} Mult if played hand',
            'has a scoring {C:attention}#2#{}',
        }
    },
    config = { extra = { xmult = 3, value = '6', id = 6 } },
    blueprint_compat = true,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 3, y = 0 },
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
    loc_txt = {
        name = 'Creature',
        text = {
            'Each {C:attention}Enhanced{}{C:inactive}d{} card',
            'gives {X:mult,C:white} X#1# {} Mult{C:inactive}t{}',
            'when scored {C:inactive}:3{}'
        }
    },
    config = { extra = { xmult = 1.75 } },
    blueprint_compat = true,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 0, y = 1 },
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
    loc_txt = {
        name = 'Oxoboo',
        text = {
            'Create a {C:dark_edition}Negative{}',
            '{C:tarot}Tarot{} card if {C:attention}Blind{}',
            'is defeated on the',
            '{C:attention}first hand{} of round'
        }
    },
    blueprint_compat = true,
    rarity = 3,
    atlas = atlas.key,
    pos = { x = 1, y = 1 },
    cost = 7,
    unlocked = true,
    discovered = true,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition
            and context.game_over == false and G.GAME.current_round.hands_played == 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'oxo')
                    c:set_edition('e_negative', true)
                    c:add_to_deck()
                    G.consumeables:emplace(c)
                    return true
                end
            }))
            return { message = 'Nice!' }
        end
    end
}

SMODS.Joker {
    key = 'low_poly_holly',
    loc_txt = {
        name = 'Low Poly Holly',
        text = {
            'If played hand has {C:attention}only{}',
            '{C:attention}1{} card, {C:attention}all face{} cards',
            'held in hand are',
            'converted into that card'
        }
    },
    blueprint_compat = false,
    rarity = 4,
    atlas = atlas.key,
    pos = { x = 0, y = 2 },
    soul_pos = { x = 1, y = 2 },
    cost = 20,
    unlocked = true,
    discovered = true,
    -- BUG: cards that are enhanced may not trigger on the same played hand
    calculate = function(self, card, context)
        if context.before and not context.repetition and not context.blueprint then
            local face_card_in_hand = false
            for _, v in pairs(G.hand.cards) do
                if v:is_face() then
                    face_card_in_hand = true
                end
            end
            if face_card_in_hand and #G.play.cards == 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        for _, v in pairs(G.hand.cards) do
                            if v:is_face() then
                                copy_card(G.play.cards[1], v)
                                v:juice_up()
                            end
                        end
                        return true
                    end
                }))
                return { message = 'Converted!' }
            end
        end
    end
}
