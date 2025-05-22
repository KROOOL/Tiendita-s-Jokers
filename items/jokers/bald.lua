local joker = {
    name = "Bald Joker",
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 3, y = 3}, --Posicion asset
    config = { extra = { mult = 25, odds = 7, Xmult = 0.8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult ,G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('tiendita_bald') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return{
                    Xmult = card.ability.extra.Xmult
                }
            end
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

return joker
