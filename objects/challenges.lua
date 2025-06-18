SMODS.Challenge {
    key = 'hyperdef_polycule1',
    unlocked = function()
        return true
    end,
    jokers = { { id = 'j_hyperdef_low_poly_holly', eternal = true } },
    consumeables = {
        { id = 'c_familiar' },
        { id = 'c_familiar' }
    },
    deck = {
        type = 'Challenge Deck',
        cards = {
            { s = 'S', r = 'Q' },
            { s = 'D', r = 'Q' },
            { s = 'C', r = 'Q' },
            { s = 'H', r = 'Q' }
        }
    }
}

SMODS.Challenge {
    key = 'hyperdef_polycule2',
    unlocked = function()
        return true
    end,
    restrictions = {
        banned_cards = {
            { id = 'j_shoot_the_moon' },
            { id = 'j_triboulet' }
        }
    },
    jokers = { { id = 'j_hyperdef_polyqueen', eternal = true } },
    consumeables = {
        { id = 'c_cryptid' },
        { id = 'c_cryptid' }
    },
    deck = {
        type = 'Challenge Deck',
        cards = {
            { s = 'S', r = 'Q' },
            { s = 'D', r = 'Q' },
            { s = 'C', r = 'Q' },
            { s = 'H', r = 'Q' }
        }
    }
}

SMODS.Challenge {
    key = 'hyperdef_cerberus',
    unlocked = function()
        return true
    end,
    jokers = {
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true },
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true },
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true }
    },
    deck = { type = 'Challenge Deck' }
}

SMODS.Challenge {
    key = 'hyperdef_instrumentality',
    unlocked = function()
        return true
    end,
    rules = {
        custom = {
            { id = 'set_joker_slots_ante', value = 5 },
            { id = 'set_eternal_ante', value = 5 }
        }
    },
    restrictions = {
        banned_cards = {
            { id = 'v_petroglyph' },
            { id = 'v_hieroglyph' }
        }
    },
    jokers = { { id = 'j_hyperdef_adam' } },
    deck = { type = 'Challenge Deck' }
}
