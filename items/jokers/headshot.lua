local joker = {
    name = "Headshot",
    atlas = "TienditaJokers",
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    pos = {x = 7, y = 1},
    config = {extra = {xmult = 2, xgain = 0.25, hands_played_at_create = 0}},

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xgain, card.ability.extra.hands_played_at_create}}
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 or card.ability.extra.hands_played_at_create == 0 and context.main_scoring then
            card.ability.extra.hands_played_at_create = card.ability.extra.hands_played_at_create + 1
            card.ability.extra_value = 0
            card:set_cost()
            return{
                Xmult = card.ability.extra.xmult
            }
        
        elseif context.joker_main and G.GAME.current_round.hands_played >= 1 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up(0.3, 0.4)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            card:start_dissolve(nil, self)
                            return true
                        end
                    }))
                    return true
                end
            }))
            G.GAME.pool_flags.tiendita_balloon_extinct = true
            return {
                message = localize('k_spotted')
            }
        end

        if context.end_of_round and context.cardarea == G.jokers and G.GAME.current_round.hands_played == 1 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xgain
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                colour = G.C.RED,
                message_card = card
            }
        end
    end
}

return joker