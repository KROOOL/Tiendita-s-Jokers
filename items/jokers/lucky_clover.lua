local joker = {
    name = "Lucky Clover", --Nombre
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 4, y = 1}, --Posicion asset
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
return joker