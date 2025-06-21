-- Get keys of all Hyper Definition cards except Legendary cards and banned
-- cards. If the player has a Showman, include keys of duplicate cards.
function hyperdef_shop_get_keys()
    local keys_owned = {}
    for _, v in pairs(G.jokers.cards) do
        table.insert(keys_owned, v.config.center.key)
    end
    local keys = {}
    for k, v1 in pairs(SMODS.Centers) do
        if string.sub(k, 1, #"j_hyperdef") == "j_hyperdef" and not G.GAME.banned_keys[k] and v1.rarity < 4 then
            local do_include = true
            local allow_duplicates = false
            for _, v in pairs(G.jokers.cards) do
                if v.config.center.key == 'j_ring_master' then
                    allow_duplicates = true
                    break
                end
            end
            if allow_duplicates == false then
                for _, v2 in pairs(keys_owned) do
                    if v2 == k then
                        do_include = false
                        break
                    end
                end
            end
            if do_include then
	            table.insert(keys, k)
            end
        end
    end
    return keys
end
