local joker = {
    name = "Alien Joker",
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 2, y = 3}, --Posicion asset
    --Por alguna razon multiplica eso x2??????
    config = { extra = { chips = 5} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chips * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0) } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Planet" then
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { (card.ability.extra.chips*2) } },
                colour = G.C.CHIPS,
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0),
                    colour = G.C.CHIPS
            }
        end
    end,
}

return joker
