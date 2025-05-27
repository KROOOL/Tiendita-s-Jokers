local joker = {
    name = "Bust", --Nombre
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
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
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

return joker