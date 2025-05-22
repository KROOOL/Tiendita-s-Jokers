local joker = {
    name = "Other Half Joker",
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 6, y = 0}, --Posicion asset
    pixel_size = { w = 71, h =  48},
    config = { extra = { mult = 30, size = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.size } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand <= card.ability.extra.size then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

return joker