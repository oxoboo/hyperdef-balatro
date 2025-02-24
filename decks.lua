local ENABLE_TEST_DECK = false

function deck_add_joker(forced_key)
    local card = create_card('Joker', G.jokers, nil, nil, nil, nil, forced_key, 'deck')
    card:add_to_deck()
    card:start_materialize()
    G.jokers:emplace(card)
end

if ENABLE_TEST_DECK then
    SMODS.Back {
        name = 'Hyper Definition Test Deck',
        key = 'hyperdef-test',
        pos = { x = 0, y = 0 },
        loc_txt = {
            name = 'Hyper Definition Test Deck',
            text = {
                'This is a Test Deck',
                'for {C:attention}Hyper Definition{}'
            },
        },
        unlocked = true,
        discovered = true,
        apply = function()
            G.E_MANAGER:add_event(Event({
                func = function()
                    -- ease_dollars(10)
                    -- G.GAME.round_resets.hands = 5
                    -- G.GAME.round_resets.discards = 4
                    -- deck_add_joker('j_hyperdef_adam')
                    return true
                end
            }))
        end
    }
end
