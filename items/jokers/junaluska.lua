local joker = {
    name = "Junaluska", --Nombre
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 4, y = 0}, --Posicion asset
    config = { extra = { odds = 6, chips = 120 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('tiendita_junaluska') < G.GAME.probabilities.normal / card.ability.extra.odds then
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
                G.GAME.pool_flags.tiendita_junaluska_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args) -- equivalent to `no_pool_flag = 'tiendita_junaluska_extinct'`
        return not G.GAME.pool_flags.tiendita_junaluska_extinct
    end
}

return joker