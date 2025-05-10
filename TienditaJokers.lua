SMODS.Atlas {
    key = 'TienditaJokers',
    path = 'TienditaJokers.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = 'j_yu_sze',
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
    key = 'j_cepillin',
    loc_txt = {
        name = "Cepillin", --Nombre
        text = { --Informacion sobre lo q hace
            "Si tienes esta carta",
            "eres todo un ",
            "{C:attention}Naco y Estupido{}",
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
    config = { 
        extra = {
            mult = 0, x_mult = 2, every = 9, multadd = 1,
        } 
    }, -- Parametros
    loc_vars = function(self,info_queue,center)
        return {
            vars = {center.ability.extra.x_mult, center.ability.extra.every, center.ability.extra.multadd}
        }
    end,
}

SMODS.Joker {
    key = 'j_bust',
    loc_txt = {
        name = "Bust Joker", --Nombre
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