local file_names_jokers = {
    'wooden_kaiju',
    'shopcorp',
    'horse_plinko',
    'stead_dog',
    'buffer_joker',
    'polyqueen',
    'half_joker',
    'alchemy',
    'hydra',
    'magazine',
    'adam',
    'fish_satan',
    'manic',
    'oxoboo',
    'creature',
    'stead',
    'low_poly_holly'
}

SMODS.load_file('objects/consumables/cutaway.lua')()
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
