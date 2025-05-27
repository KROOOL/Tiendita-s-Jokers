local joker = {
    name = "Yu Sze", --Nombre
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
            x_mult = 1, x_mult_gain = 0.2
        } 
    }, -- Parametros
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
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
return joker