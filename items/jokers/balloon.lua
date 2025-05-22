local joker = {
    name = "Balloon", --Nombre
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 0, y = 3}, --Posicion asset
    config = { extra = { odds = 12, mult = 0, mult_gain = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('tiendita_balloon') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.tiendita_balloon_extinct = true
                return {
                    message = localize('k_pop')
                }
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain

                if card.ability.extra.mult == 0 then
                    card.ability.extra.odds = 12
                    return { message = localize('k_blow'), colour = G.C.BLUE, message_card = card, }
                end
                if card.ability.extra.mult == 15 then
                    card.ability.extra.odds = 6
                    return { message = localize('k_blow'), colour = G.C.BLUE, message_card = card, }
                end
                if card.ability.extra.mult == 25 then
                    card.ability.extra.odds = 3
                    return { message = localize('k_blow'), colour = G.C.BLUE, message_card = card, }
                end

                return { message = localize('k_upgrade_ex'), colour = G.C.MULT, message_card = card, }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                odds = card.ability.extra.odds
            }
        end
    end,
}

return joker