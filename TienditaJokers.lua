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
            "Each {C:attention}played card {}gives",
            "{X:mult,C:white} X#1# {} Mult when scored",
            "if played hand contains a {C:attention}#2#",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 4,
    config = { 
        extra = {
            x_mult = 4,
        } 
    }, -- Parametros
    rarity = 4, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 1, --cuanto vale en la tienda
    blueprint_compat = true, 
    eternal_compat = true,
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    effect= "",
    atlas = "TienditaJokers",
    pos = { x = 0, y = 0}, --Posicion asset
    soul_pos = { x = 0, y = 1},
    loc_vars = function(self,info_queue,center)
        return {
            vars = {center.ability.extra.x_mult, "Four of a Kind"}
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local text, disp_text, poker_hands, scoring_hand, non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
            if non_loc_disp_text == "Four of a Kind" then
                return {
                    x_mult = card.ability.extra.x_mult,
                    card = card
                }
            end
        end
    end
}