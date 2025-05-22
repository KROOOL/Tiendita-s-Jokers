local joker = {
    name = "Paleta Payaso",
    atlas = 'TienditaJokers',
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    effect = '',
    config = {extra = {feis = 2, enhance = 4, editi = 8}},
    math.randomseed(os.time()),
    pos = {x = math.random(0, 4), y = 2},

    loc_vars = function(self, context, card)
        return{
            vars = {"Face", G.GAME.probabilities.normal, card.ability.extra.feis, card.ability.extra.enhance, card.ability.extra.editi, "Enhancement", "Edition"}
        }
    end,
    calculate = function (self, card, context)
        local edition = nil
        local encanto = 0
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then  
            if pseudorandom('paleta_payaso') < G.GAME.probabilities.normal / card.ability.extra.feis then
                if context.other_card.facing == "front" then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,context.other_card:flip()}))
                end
                local card = context.other_card
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local edition_poll = pseudorandom(pseudoseed('paleta_payaso'))
                local rank_suffix = card.base.id
                if edition_poll > 1 - 0.01*25 and rank_suffix ~= 13 then
                    rank_suffix = 'K'
                    encanto = encanto +1
                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                elseif edition_poll > 1 - 0.02*25 and rank_suffix ~= 12 then
                    rank_suffix = "Q"
                    encanto = encanto +1
                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                elseif rank_suffix ~= 11 then
                    rank_suffix = 'J'
                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                    encanto = encanto +1
                end  
            end 
            if pseudorandom('paleta_payaso') < G.GAME.probabilities.normal / card.ability.extra.enhance then
                encanto = encanto + 1
                local edition_poll = pseudorandom(pseudoseed('paleta_payaso'))
                if edition_poll > 1 - 0.005*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_steel, nil, true)
                elseif edition_poll > 1 - 0.0075*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_glass, nil, true)
                elseif edition_poll > 1 - 0.01*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_gold, nil, true)
                elseif edition_poll > 1 - 0.0125*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_lucky, nil, true)
                elseif edition_poll > 1 - 0.015*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_stone, nil, true)
                elseif edition_poll > 1 - 0.02*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_mult, nil, true)
                elseif edition_poll > 1 - 0.025*25 then
                    context.other_card:set_ability(G.P_CENTERS.m_bonus, nil, true)
                else
                    context.other_card:set_ability(G.P_CENTERS.m_wild, nil, true)
                end         
            end
            if pseudorandom('paleta_payaso') < G.GAME.probabilities.normal / card.ability.extra.editi then
                if context.other_card.facing == "front" then
                    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,context.other_card:flip()}))
                end
                encanto = encanto + 1
                edition = poll_edition(wheel_of_fortune, nil, true, true)
                context.other_card:set_edition(edition, nil, true)
            end
            if context.other_card.facing == "back" then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,context.other_card:flip()}))
            end
            if encanto > 0 then
                return{
                    message = localize('k_change'),
                    colour = G.C.GREEN,
                    message_card = card
                }
            end
        end        
    end
}

return joker