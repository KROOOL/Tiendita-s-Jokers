local joker = {
    name = "Piggy Bank",
    atlas = "TienditaJokers",
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    pos = {x = 6, y = 1},
    config = {extra = {mplus = 1, mmineed = 5}},

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mmineed, card.ability.extra.mplus}}
    end,

    calculate = function(self, card, context)
        if context.ending_shop and G.GAME.dollars >= 5 then
            card.ability.extra_value = card.ability.extra_value + math.floor(G.GAME.dollars / card.ability.extra.mmineed)
            card:set_cost()
            return{
                message = localize("k_val_up"),
                colour = G.C.MONEY
            }
        end
    end
}

return joker