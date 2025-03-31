local file_names_jokers = {
    'shopcorp',
    'horse_plinko',
    'buffer_joker',
    'wooden_kaiju',
    'stead_dog',
    'magazine',
    'alchemy',
    'hydra',
    'polycule_joker',
    'manic',
    'fish_satan',
    'creature',
    'oxoboo',
    'adam',
    'stead',
    'low_poly_holly'
}

SMODS.load_file('objects/atlas.lua')()
SMODS.load_file('objects/boosters.lua')()
SMODS.load_file('objects/challenges.lua')()
SMODS.load_file('objects/decks.lua')()
SMODS.load_file('override.lua')()
for _, v in pairs(file_names_jokers) do
    local path = 'objects/jokers/' .. v .. '.lua'
    local load_joker = SMODS.load_file(path)
    if load_joker then
        load_joker()
    else
        print('Hyper Definition: Failed to load \'' .. path .. '\'')
    end
end
