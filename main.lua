local function load_objects(dir, t_names)
    for _, v in pairs(t_names) do
        local path = 'objects/' .. dir .. '/' .. v .. '.lua'
        local load_obj = SMODS.load_file(path)
        if load_obj then
            load_obj()
        else
            sendErrorMessage('Failed to load \'' .. path .. '\'', 'Hyper Definition')
        end
    end
end

SMODS.load_file('global_functions.lua')()
SMODS.load_file('objects/consumables/cutaway.lua')()
SMODS.load_file('objects/atlas.lua')()
SMODS.load_file('objects/boosters.lua')()
SMODS.load_file('objects/challenges.lua')()
SMODS.load_file('override.lua')()
load_objects('decks', { 'test', 'hyper' })
load_objects('jokers', {
    'wooden_kaiju',
    'shopcorp',
    'horse_plinko',
    'stead_dog',
    'buffer_joker',
    'half_joker',
    'polyqueen',
    'alchemy',
    'hydra',
    'magazine',
    'adam',
    'fish_satan',
    'manic',
    'bongo_cat',
    'oxoboo',
    'creature',
    'stead',
    'low_poly_holly'
})
