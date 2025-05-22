local joker = {
    name = "Moai", --Nombre
    atlas = 'TienditaJokers',
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 3, y = 1}, --Posicion asset
    config = { extra = { chip_mod = 25, Xchips_mod = 0.15, chips = 0, Xchips = 1} },
    loc_vars = function(self, info_queue, card)
         return { vars = { card.ability.extra.Xchips_mod ,card.ability.extra.chip_mod, card.ability.extra.Xchips, card.ability.extra.chips}}
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards and not context.blueprint then
            local d_stone_cards = 0
            for _, removed_card in ipairs(context.removed) do
                if SMODS.has_enhancement(removed_card, "m_stone") then d_stone_cards = d_stone_cards + 1 end
            end
        if d_stone_cards > 0 then
            card.ability.extra.Xchips = card.ability.extra.Xchips + card.ability.extra.Xchips_mod 
            return {  message = localize('k_upgrade_ex'), colour = G.C.CHIPS, message_card = card }
            end
        end
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
            return { message = localize('k_upgrade_ex'), colour = G.C.GREEN, message_card = card }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                xchips = card.ability.extra.Xchips,
            }
        end
    end,
}

return joker