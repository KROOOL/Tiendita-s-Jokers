local joker =  {
    name = "Damocles",
    atlas = 'TienditaJokers',
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 7, y = 0}, --Posicion asset
    config = { extra = {Xmult = 4, odds = 6}, },
    loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.Xmult , G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not context.repetition and 
            pseudorandom('tiendita_damocles') < G.GAME.probabilities.normal / card.ability.extra.odds then
               ease_hands_played(1 - G.GAME.current_round.hands_left)
               ease_discard(-G.GAME.current_round.discards_left, nil, true)
               return{
                message = localize("k_damocles"),
                colour = G.C.RED,
                message_card = card
                }
        end
        if context.joker_main then
            return{
                Xmult = card.ability.extra.Xmult
            }
        end
    end
}

return joker