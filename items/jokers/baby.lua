local joker = {
    name = "Baby Joker",
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 6,
    blueprint_compat = true, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 4, y = 3}, --Posicion asset
    pixel_size = { w = 38, h =  49},
    config =  { extra = {Xmult_mod = 0.05, Xmult = 1 } },
     -- Parametros
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.Xmult_mod, card.ability.extra.Xmult}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:get_id() == 2 or
                context.other_card:get_id() == 3 or
                context.other_card:get_id() == 4 or
                context.other_card:get_id() == 5 then
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                        message_card = card,
                    } 
            end
        end
        if context.joker_main then 
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}

return joker