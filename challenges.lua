SMODS.Challenge {
    key = 'polycule',
    loc_txt = { name = 'Polycule' },
    unlocked = true,
    jokers = {
        { id = 'j_hyperdef_low_poly_holly', eternal = true },
    },
    consumeables = {
        { id = 'c_familiar' },
        { id = 'c_familiar' }
    },
    deck = {
        type = 'Challenge Deck',
        cards = { {s='S',r='Q'}, {s='D',r='Q'}, {s='C',r='Q'}, {s='H',r='Q'} }
    }
}

SMODS.Challenge {
    key = 'cerberus',
    loc_txt = { name = 'Cerberus' },
    unlocked = true,
    jokers = {
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true },
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true },
        { id = 'j_hyperdef_hydra', edition = 'negative', eternal = true }
    },
    deck = { type = 'Challenge Deck' }
}

SMODS.Challenge {
    key = 'instrumentality',
    loc_txt = { name = 'Instrumentality' },
    unlocked = true,
    rules = {
        custom = {
            { id = 'set_eternal_ante', value = 5 },
            { id = 'set_joker_slots_ante', value = 5 }
        }
    },
    restrictions = {
        banned_cards = {
            { id = 'v_petroglyph' },
            { id = 'v_hieroglyph' }
        }
    },
    jokers = {
        { id = 'j_hyperdef_adam' }
    },
    deck = { type = 'Challenge Deck' }
}
