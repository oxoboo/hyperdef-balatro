return {
    descriptions = {
        Back = {
            b_hyperdef_hyper = {
                name = 'Hyper Deck',
                text = {
                    'First shop has a',
                    '{C:attention}Hyper Pack{}'
                }
            }
        },
        Joker = {
            j_hyperdef_shopcorp = {
                name = 'Shop-Corp Poster',
                text = {
                    'This Joker gains {C:mult}+#1#{} Mult ',
                    'when a card from deck is',
                    '{C:attention}destroyed{}',
                    '{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult){}'
                }
            },
            j_hyperdef_horse_plinko = {
                name = 'Horse Plinko',
                text = {
                    '{C:green}#1# in #2#{} chance to give {C:chips}+#3#{} Chips',
                    '{C:green}#4# in #5#{} chance to give {C:chips}+#6#{} Chips',
                    '{C:green}#7# in #8#{} chance to give {C:chips}+#9#{} Chips',
                    '{C:green}#10# in #11#{} chance to give {C:chips}+#12#{} Chips',
                    '{C:inactive}(Chances cannot be modified){}'
                }
            },
            j_hyperdef_buffer_joker = {
                name = 'Buffer Joker',
                text = {
                    'Every {C:attention}#1#{} hands, give',
                    '{C:blue}+#2#{} hands this round',
                    'and {C:attention}debuff{} played hand',
                    '{C:inactive}#3#{}'
                }
            },
            j_hyperdef_wooden_kaiju = {
                name = 'Wooden Kaiju',
                text = {
                    'This Joker gains',
                    '{C:mult}+#1#{} Mult per {C:attention}hand{}',
                    'played this round',
                    '{C:inactive}(Currently{} {C:mult}+#2#{} {C:inactive}Mult){}'
                }
            },
            j_hyperdef_magazine  = {
                name = 'Magazine Subscription',
                text = {
                    'When {C:attention}Blind{} is selected, spend',
                    '{C:money}$#1#{} and create a {C:spectral}Spectral{} card',
                    '{C:inactive}(Must have room)'
                }
            },
            j_hyperdef_alchemy = {
                name = 'Alchemy',
                text = {
                    '{C:attention}Gold{} and {C:attention}Steel{}',
                    'cards share',
                    'abilities'
                }
            },
            j_hyperdef_hydra = {
                name = 'Hydra the Fox',
                text = {
                    '{C:chips}+#1#{} Chips, {C:attention}destroy{}',
                    'a {C:attention}random{} card in hand',
                    'at start of round'
                }
            },
            j_hyperdef_fish_satan = {
                name = 'Fish Satan',
                text = {
                    '{X:mult,C:white} X#1# {} Mult if played hand',
                    'has a scoring {C:attention}#2#{}',
                }
            },
            j_hyperdef_creature = {
                name = 'Creature',
                text = {
                    'Each {C:attention}Enhanced{}{C:inactive}d{} card',
                    'gives {X:mult,C:white} X#1# {} Mult{C:inactive}t{}',
                    'when scored {C:inactive}:3{}'
                }
            },
            j_hyperdef_oxoboo = {
                name = 'Oxoboo',
                text = {
                    'Create a {C:dark_edition}Negative{}',
                    '{C:tarot}Tarot{} card if {C:attention}Blind{}',
                    'is defeated on the',
                    '{C:attention}first hand{} of round'
                }
            },
            j_hyperdef_adam = {
                name = 'Adam',
                text = {
                    'After {C:attention}#1#{} rounds, sell',
                    'this card to create',
                    'a {C:legendary,E:1}Legendary{} Joker',
                    '{C:inactive}(Currently {C:attention}#2#{}{C:inactive}/#3#){}'
                }
            },
            j_hyperdef_low_poly_holly = {
                name = 'Low Poly Holly',
                text = {
                    'If played hand has {C:attention}only{}',
                    '{C:attention}1{} card, {C:attention}all face{} cards',
                    'held in hand are',
                    'converted into that card'
                }
            }
        },
        Other = {
            p_hyperdef_hyper = {
                name = 'Hyper Pack',
                text = {
                    'Choose {C:attention}#1#{} of up to',
                    '{C:attention}#2#{} {C:attention}Hyper Definition{}',
                    '{C:joker}Joker{} cards'
                }
            }
        }
    },
    misc = {
        dictionary = {
            hyper = 'Hyper Pack',
            k_hyperdef_hydra1 = 'munch',
            k_hyperdef_hydra2 = 'slurp',
            k_hyperdef_hydra3 = 'nom',
            k_hyperdef_nice = 'Nice!',
            k_hyperdef_converted = 'Converted!',
        },
        v_dictionary = {
            hyperdef_buffer_active = 'Active!',
            hyperdef_buffer_inactive = '#1# remaining'
        }
    }
}
