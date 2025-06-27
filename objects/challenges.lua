SMODS.Challenge {
    key = 'hyperdef_polycule1',
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
    jokers = {
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true },
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true },
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true }
    },
    deck = { type = 'Challenge Deck' }
}

SMODS.Challenge {
    key = 'new_stuff',
    jokers = {
        { id = 'j_hyperdef_half_joker' },
        { id = 'j_hyperdef_bongo_cat' }
    },
    consumeables = { { id = 'c_hyperdef_cutaway' } },
    deck = { type = 'Challenge Deck' }
}
