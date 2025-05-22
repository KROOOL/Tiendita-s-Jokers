local joker = {
    name = "D6",
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 6,
    blueprint_compat = false,
    eternal_compat = false,
    unlocked = true,
    discovered = true,
    pos = {x = 8, y = 0},
    config = {extra = {tdestroy = 0, judge = "Judgement", legend = "The Soul"}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.tdestroy}}
    end,
    calculate = function(self, card, context)
        local deletable_jokers = {}
        if context.selling_self then
            for k, v in pairs(G.jokers.cards) do
                if not v.ability.eternal then deletable_jokers[#deletable_jokers + 1] = v end
                card.ability.extra.tdestroy = card.ability.extra.tdestroy + 1
            end
        end
        local chosen_joker = ""
        local _first_dissolve = nil
        for k, v in pairs(deletable_jokers) do
            if v ~= chosen_joker then 
                v:start_dissolve(nil, _first_dissolve)
                _first_dissolve = true
            end
        end
        table.remove(deletable_jokers, 1)
        if card.ability.extra.tdestroy > 0 then
            for k, v in pairs(deletable_jokers) do
                local edition_poll = pseudorandom(pseudoseed('paleta_payaso'))
                local carta
                if edition_poll > 1 - 0.05 then
                    carta = create_card('Joker', G.jokers, card.ability.extra.legend == 'The Soul', nil, nil, nil, nil, card.ability.extra.legend == '' and 'jud' or 'sou')
                else
                    carta = create_card('Joker', G.jokers, card.ability.extra.judge == '', nil, nil, nil, nil, card.ability.extra.judge == 'Judgement' and 'jud' or 'sou')
                end
                carta:add_to_deck()
                G.jokers:emplace(carta)
            end
        end
    end
}

return joker