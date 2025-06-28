local ENABLE_TEST_DECK = false

-- Can be added to any card area for testing.
local function add_booster(forced_key, card_area)
    local booster = Card(
        card_area.T.x + card_area.T.w / 2,
        card_area.T.y,
        G.CARD_W * 1.27,
        G.CARD_H * 1.27,
        G.P_CARDS.empty,
        G.P_CENTERS[forced_key],
        { bypass_discovery_center = true, bypass_discovery_ui = true }
    )
    booster:start_materialize()
    card_area:emplace(booster)
    create_shop_card_ui(booster)
    return booster
end

if ENABLE_TEST_DECK then
    SMODS.Back {
        name = 'Hyper Definition Test Deck',
        key = 'test',
        pos = { x = 0, y = 0 },
        discovered = true,
        apply = function()
            G.E_MANAGER:add_event(Event({
                func = function(self, back)
                    -- ease_dollars(10)
                    -- G.GAME.round_resets.hands = 5
                    -- G.GAME.round_resets.discards = 4
                    -- SMODS.add_card({ set = 'Joker', area = G.jokers, key = 'j_hyperdef_adam', key_append = 'deck' })
                    -- add_booster('p_buffoon_normal_1', G.consumeables)
                    return true
                end
            }))
        end
    }
end
