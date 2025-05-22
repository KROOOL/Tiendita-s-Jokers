local joker = {
    name = "Souls", --Nombre
    atlas = 'TienditaJokers',
    rarity = 3,
    cost = 10,
    blueprint_compat = false,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 5, y = 2}, --Posicion asset
    soul_pos = { x = 5, y = 3, },
    config = { extra = { soul_rounds = 0, total_rounds = 7 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.total_rounds, card.ability.extra.soul_rounds }}
    end,
    calculate = function(self, card, context)
        if context.selling_self and (card.ability.extra.soul_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
           G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                local card = create_card(nil,G.consumeables, nil, nil, nil, nil, 'c_soul', 'sup')
                card:set_edition({negative = true}, true)
                card:add_to_deck()
                G.consumeables:emplace(card)
                return true
            end)}))
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.soul_rounds = card.ability.extra.soul_rounds + 1
            if card.ability.extra.soul_rounds == card.ability.extra.total_rounds then
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
                message = (card.ability.extra.soul_rounds < card.ability.extra.total_rounds) and
                    (card.ability.extra.soul_rounds .. '/' .. card.ability.extra.total_rounds) or
                    localize('k_active_ex'),
                colour = G.C.FILTER
            }
        end
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_custom' and G.GAME.max_jokers <= 4
    end,
}

return joker