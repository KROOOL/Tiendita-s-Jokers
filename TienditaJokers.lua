SMODS.Atlas {
    key = 'TienditaJokers',
    path = 'TienditaJokers.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = 'yu_sze',
    loc_txt = {
        name = "Yu Sze", --Nombre
        text = { --Informacion sobre lo q hace
            "Gains {X:mult,C:white} X#2# {} Mult each time",
            "a {C:attention}Stone{} card is scored",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 4, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 20, --cuanto vale en la tienda
    blueprint_compat = true, 
    eternal_compat = true,
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 0, y = 0}, --Posicion asset
    soul_pos = { x = 0, y = 1}, --Posicion soul asset
    config = { 
        extra = {
            x_mult = 1, x_mult_gain = 0.25
        } 
    }, -- Parametros
    loc_vars = function(self,info_queue,center)
        return {
            vars = {center.ability.extra.x_mult, center.ability.extra.x_mult_gain}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") and not context.blueprint then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain 
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
             }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end,
    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_card'`
        for _, playing_card in ipairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(playing_card, 'm_stone') then
                return true
            end
        end
        return false
    end
}

SMODS.Joker {
    key = 'cepillin',
    loc_txt = {
        name = "Cepillin", --Nombre
        text = { --Informacion sobre lo q hace
            "When a {C:attention}#1#{} of {C:attention}5{} Cards is played",
            "then all scored Cards retrigger {C:attention}#2#{} additional times"
        },
    },
    atlas = 'TienditaJokers',
    rarity = 4, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 20, --cuanto vale en la tienda
    blueprint_compat = true, 
    eternal_compat = true,
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 1, y = 0}, --Posicion asset
    soul_pos = { x = 1, y = 1}, --Posicion soul asset
    config = { extra = { poker_hand = 'High Card', repetitions = 4} },
    loc_vars = function(self, info_queue, card)
        return { vars = {localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.repetitions} }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play 
        and context.scoring_name == card.ability.extra.poker_hand and #context.full_hand == 5 then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}

SMODS.Joker {
    key = 'bust',
    loc_txt = {
        name = "Bust", --Nombre
        text = { --Informacion sobre lo q hace
            "Retrigger all played {C:attention}Stone{} cards",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 2, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 6, --cuanto vale en la tienda
    blueprint_compat = true, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 3, y = 0}, --Posicion asset
    config =  { extra = { repetitions = 1 } },
     -- Parametros
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.repetitions}
        }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}

SMODS.Joker {
    key = 'junaluska',
    loc_txt = {
        name = "Junaluska", --Nombre
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:green}#2# in #3#{} chance this",
            "card is destroyed",
            "at end of round",
        },
    },
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

SMODS.Joker {
    key = 'red_delicious',
    loc_txt = {
        name = "Red Delicious", --Nombre
        text = {
            "{X:blue,C:white} X#1#{} Chips",
            "{C:green}#2# in #3#{} chance this",
            "card is destroyed",
            "at end of round",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 5, y = 0}, --Posicion asset

    config = { extra = { odds = 1000, Xchips = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xchips, G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('tiendita_red_delicious') < G.GAME.probabilities.normal / card.ability.extra.odds then
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
                xchips = card.ability.extra.Xchips
            }
        end
    end,
    in_pool = function(self, args) -- equivalent to `yes_pool_flag = 'tiendita_junaluska_extinct'`
        return G.GAME.pool_flags.tiendita_junaluska_extinct
    end
}

SMODS.Joker {
    key = 'lucky_clover',
    loc_txt = {
        name = "Lucky Clover", --Nombre
        text = {
            "Played {C:attention}#1#{} cards have",
            "{C:green}#2# in #3#{} to become",
            "{C:attention}Lucky{} cards when scored",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 2, y = 1}, --Posicion asset
    config = { extra = {suit = 'Clubs', odds = 4 }, },
    loc_vars = function(self, info_queue, card)
       return { vars = { localize(card.ability.extra.suit,'suits_singular'), G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint and 
            pseudorandom('tiendita_lucky_clover') < G.GAME.probabilities.normal / card.ability.extra.odds then
            local suits = {}
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card:is_suit(card.ability.extra.suit) then
                        suits[#suits + 1] = scored_card
                        scored_card:set_ability('m_lucky', nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                return true
                            end
                        }))
                    end
                end
                if #suits > 0 then
                    return {
                        message = localize('k_lucky'),
                        colour = G.C.MONEY
                    }
                end
        end
    end
}
