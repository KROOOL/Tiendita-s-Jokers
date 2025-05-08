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
            "Gains {X:mult,C:white} X#2# {} Mult if played",
            "hand has {C:attention}Stone{} card",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 4, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 1, --cuanto vale en la tienda
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

        if context.before and context.cardarea == G.jokers and not context.blueprint then
            for _, v in ipairs(context.full_hand) do
                if SMODS.has_enhancement(v, "m_stone") then
                    card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
                end
            end
            return { x_mult = card.ability.extra.x_mult > 1 and card.ability.extra.x_mult }
        end

        if context.cardarea == G.jokers and context.joker_main then
            return { x_mult = card.ability.extra.x_mult > 1 and card.ability.extra.x_mult }
        end
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
    cost = 1, --cuanto vale en la tienda
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

