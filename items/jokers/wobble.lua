local joker =  {
    name = "Wooble Joker",
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 6,
    blueprint_compat = true, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 8, y = 1}, --Posicion asset
    config = { extra = {chip_modi = 10, chip_modii = 20, mult_modi = 3, mult_modii = 5, xmult_modi = 0.1, xmult_modii = 0.5, xchip_modi = 0.1, xchip_modii = 0.5, chips = 0, mult = 0, xmult = 1, xchips = 1}, },
    loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.chips, card.ability.extra.xchips} }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            --tenia otro plan asi q tengo q programar feo o cambiar todo y decido programar feo
            local rand = pseudorandom('wobble')
            if rand < 0.3 then
                card.ability.extra.chips = card.ability.extra.chips + math.random(card.ability.extra.chip_modi, card.ability.extra.chip_modii)
                return {  message = localize('k_upgrade_ex'), colour = G.C.CHIPS, message_card = card }
            elseif rand < 0.6 then 
                card.ability.extra.mult = card.ability.extra.mult + math.random(card.ability.extra.mult_modi, card.ability.extra.mult_modii)
                return {  message = localize('k_upgrade_ex'), colour = G.C.MULT, message_card = card }    
            elseif rand < 0.8 then
                card.ability.extra.xchips = card.ability.extra.xchips + (card.ability.extra.xchip_modi + math.random() * (card.ability.extra.xchip_modii - card.ability.extra.xchip_modi))
                return {  message = localize('k_upgrade_ex'), colour = G.C.CHIPS, message_card = card }
            else
                card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.xmult_modi + math.random() * (card.ability.extra.xmult_modii - card.ability.extra.xmult_modi))
                return {  message = localize('k_upgrade_ex'), colour = G.C.MULT, message_card = card }
            end
        end

            if context.joker_main then
                return{
                    mult = card.ability.extra.mult,
                    xmult = card.ability.extra.xmult,
                    chips = card.ability.extra.chips,
                    xchips = card.ability.extra.xchips,   
                }
            end
    end
}

return joker