local joker = {
    name = "Snake", --Nombre
    atlas = 'TienditaJokers',
    rarity = 3,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 2, y = 0}, --Posicion asset
    soul_pos = { x = 2, y = 1, },
    config = { h_size = 0, extra_h = 2, extra = { d_size = -1}} ,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra_h, card.ability.extra.d_size}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and #context.full_hand == 1 and not context.blueprint then
            card.ability.h_size = card.ability.h_size + card.ability.extra_h
            G.hand:change_size(card.ability.extra_h)
      
            return { message = localize('k_upgrade_ex'), colour = G.C.RED, message_card = card }
        end
    
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            G.hand:change_size(-card.ability.h_size)
            card.ability.h_size = 0
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(-card.ability.extra.d_size)
    end
}

return joker