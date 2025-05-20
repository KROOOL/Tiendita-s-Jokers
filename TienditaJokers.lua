SMODS.Atlas {
    key = 'TienditaJokers',
    path = 'TienditaJokers.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = 'yu_sze',
    loc_txt = {
        name = "Yu Sze", --Nombre
        text = { --Informacion sobre lo q hace
            "This Joker gains {X:mult,C:white}X#2#{} Mult each time",
            "a {C:attention}Stone{} card is scored",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
        },
    },
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

SMODS.Joker {
    key = 'cepillin',
    loc_txt = {
        name = "Cepillin", --Nombre
        text = { --Informacion sobre lo q hace
            "Retrigger all played cards {C:attention}#2#{} additional times", 
            "if {C:attention}played hand{} is {C:attention}#1#{}",
            "and contains {C:attention}5{} cards",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 4, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 20, --cuanto vale en la tienda
    blueprint_compat = true, 
    eternal_compat = true,
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 1, y = 0}, --Posicion asset
    soul_pos = { x = 1, y = 1}, --Posicion soul asset
    config = { extra = { poker_hand = 'High Card', repetitions = 4} },
    loc_vars = function(self, info_queue, card)
        return { vars = {localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.repetitions} }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play 
        and context.scoring_name == card.ability.extra.poker_hand and #context.full_hand == 5 then
            return {
                repetitions = card.ability.extra.repetitions,
                message = localize('k_nye'),
            }
        end
    end,
}

SMODS.Joker {
    key = 'snake',
    loc_txt = {
        name = "Snake", --Nombre
        text = {
            "If {C:attention}played hand{} has only",
            "{C:attention}1{} card {C:attention}+#1#{} hand size",
            "in the current round,",
            "{C:red}#2#{} discard",
        },
    },
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

SMODS.Joker {
    key = 'souls',
    loc_txt = {
        name = "Souls", --Nombre
        text = {
            "After {C:attention}#1#{} rounds,",
            "sell this card to",
            "create a free {C:purple}The Soul{} card",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
        },
    },
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

SMODS.Joker{
    key = 'paleta_payaso',
    loc_txt ={
        name = "Paleta Payaso",
        text = {
            "All scored {C:attention}#1#{} cards have",
            "{C:green}#2# in #3#{} chance to change to another {C:attention}#1#{} card",
            "{C:green}#2# in #4#{} chance to change its {C:attention}#6#",
            "{C:green}#2# in #5#{} chance to change its {C:attention}#7#",
        },
    },
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

SMODS.Joker {
    key = 'moai',
    loc_txt = {
        name = "Moai", --Nombre
        text = {
            "This Joker gains ",
            "{X:blue,C:white}X#1#{} Chips for each destroyed {C:attention}Stone{} card",
            "{C:chips}+#2#{} Chips for each played {C:attention}Stone{} card",
            "{C:inactive}[Currently {C:chips}+#4#{}{C:inactive} & {X:blue,C:white}X#3#{C:inactive} Chips]{}",
        },
    },
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

--Queria hacer otra cosa para d4c pero no jalo, si alguien lee esto y lo arregla le doy 5 peso
--O si yo del futuro quiere recordar la idea: si la mano descartada contiene un par destruye estos pares
SMODS.Joker {
    key = 'd4c',
    loc_txt = {
        name = "D4C", --Nombre
        text = {
            "If discard hand contain exactly {C:attention}3{}",
            "cards and two of them are of the same {C:attention}rank{}",
            "{C:attention}destroy{} all cards",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 2,
    cost = 7,
    blueprint_compat = false,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 1, y = 3}, --Posicion asset
    config = {},
    calculate = function(self, card, context)
        if context.pre_discard and context.cardarea == G.jokers then
            if #context.full_hand < 2 then return nil end

            -- Contar cartas por valor (rank)
            local value_counts = {}
            for _, c in ipairs(context.full_hand) do
                local value = c.base.value
                value_counts[value] = (value_counts[value] or 0) + 1
            end

            -- Encuentra valores con exactamente 2 cartas
            local matching_values = {}
            for value, count in pairs(value_counts) do
                if count == 2 then
                    table.insert(matching_values, value)
                end
            end
            if #matching_values == 0 then return nil end


            -- Marcar las cartas que coinciden con esos valores
            for _, c in ipairs(context.full_hand) do
                for _, value in ipairs(matching_values) do
                    if c.base.value == value then
                        c.d4c_marked = true
                        break
                    end
                end
            end

            -- Marca las cartas a destruir
            local marked_cards = {}
            for _, value in ipairs(matching_values) do
                local found = 0
                for _, c in ipairs(context.full_hand) do
                    if c.base.value == value and found < 2 then
                        found = found + 1
                        table.insert(marked_cards, c)
                    end
                end
            end

            return {
                remove = true
            }
        end

        if context.discard and context.cardarea == G.jokers and not context.blueprint then
            if #context.full_hand ~= 3 then return nil end
            local destroyed_cards = {}

            for i = #G.hand.cards, 1, -1 do
                local c = G.hand.cards[i]
                if c.d4c_marked then
                    table.insert(destroyed_cards, c)

                    c.drestroyed = true

                    c:start_dissolve({HEX("ed9cbe")}, nil, 1.6)
                    c:remove_from_deck()
                    c.d4c_marked = true
                end
            end

            for _, joker in ipairs(G.jokers.cards) do
                joker:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
            end

            if #destroyed_cards > 0 then
                return {
                    message = localize("k_dojya"),
                    colour = HEX("ed9cbe"),
                    duration = 1.0,
                    remove = true
                }
            end
        end
    end
}

SMODS.Joker {
    key = 'lucky_clover',
    loc_txt = {
        name = "Lucky Clover", --Nombre
        text = {
            "Played {C:attention}#1#{} cards have",
            "{C:green}#2# in #3#{} chance to become",
            "{C:attention}Lucky{} cards when scored",
        },
    },
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

SMODS.Joker {
    key = 'bust',
    loc_txt = {
        name = "Bust", --Nombre
        text = { --Informacion sobre lo q hace
            "Retrigger all played {C:attention}Stone{} cards",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 2, --rareza 1=comun 2=inusual 3=raro 4=legendario
    cost = 6, --cuanto vale en la tienda
    blueprint_compat = true, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 3, y = 0}, --Posicion asset
    config =  { extra = { repetitions = 1 } },
     -- Parametros
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.repetitions}
        }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_stone") then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
    end,
}

SMODS.Joker {
    key = 'balloon',
    loc_txt = {
        name = "Balloon", --Nombre
        text = {
            "{C:mult}+#1#{} Mult each round",
            "{C:green}#2# in #3#{} chance this",
            "is destroyed at end of round",
            "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 0, y = 3}, --Posicion asset
    config = { extra = { odds = 12, mult = 0, mult_gain = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('tiendita_balloon') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.tiendita_balloon_extinct = true
                return {
                    message = localize('k_pop')
                }
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain

                if card.ability.extra.mult == 0 then
                    card.ability.extra.odds = 12
                    return { message = localize('k_blow'), colour = G.C.BLUE, message_card = card, }
                end
                if card.ability.extra.mult == 15 then
                    card.ability.extra.odds = 6
                    return { message = localize('k_blow'), colour = G.C.BLUE, message_card = card, }
                end
                if card.ability.extra.mult == 25 then
                    card.ability.extra.odds = 3
                    return { message = localize('k_blow'), colour = G.C.BLUE, message_card = card, }
                end

                return { message = localize('k_upgrade_ex'), colour = G.C.MULT, message_card = card, }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                odds = card.ability.extra.odds
            }
        end
    end,
}

SMODS.Joker {
    key = 'junaluska',
    loc_txt = {
        name = "Junaluska", --Nombre
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:green}#2# in #3#{} chance this",
            "is destroyed",
            "at end of round",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false, 
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 4, y = 0}, --Posicion asset
    config = { extra = { odds = 6, chips = 120 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('tiendita_junaluska') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                G.GAME.pool_flags.tiendita_junaluska_extinct = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    in_pool = function(self, args) -- equivalent to `no_pool_flag = 'tiendita_junaluska_extinct'`
        return not G.GAME.pool_flags.tiendita_junaluska_extinct
    end
}

SMODS.Joker {
    key = 'red_delicious',
    loc_txt = {
        name = "Red Delicious", --Nombre
        text = {
            "{X:blue,C:white} X#1#{} Chips",
            "{C:green}#2# in #3#{} chance this",
            "is destroyed",
            "at end of round",
        },
    },
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 5, y = 0}, --Posicion asset

    config = { extra = { odds = 1000, Xchips = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xchips, G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if pseudorandom('tiendita_red_delicious') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                card:remove()
                                return true
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                xchips = card.ability.extra.Xchips
            }
        end
    end,
    in_pool = function(self, args) -- equivalent to `yes_pool_flag = 'tiendita_junaluska_extinct'`
        return G.GAME.pool_flags.tiendita_junaluska_extinct
    end
}

SMODS.Joker {
    key = 'alien',
    loc_txt = {
        name = "Alien Joker",
        text = {
            "{C:chips}+10{} Chips per {C:blue}Planet{}",
            "card used this run",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
        }
    },
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 2, y = 3}, --Posicion asset
    --Por alguna razon multiplica eso x2??????
    config = { extra = { chips = 5} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chips * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0) } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Planet" then
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { (card.ability.extra.chips*2) } },
                colour = G.C.CHIPS,
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0),
                    colour = G.C.CHIPS
            }
        end
    end,
}

SMODS.Joker {
    key = 'bald',
    loc_txt = {
        name = "Bald Joker",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:green}#2# in #3#{} chance to ",
            "{X:mult,C:white}X#4#{} Mult",
        }
    },
    atlas = 'TienditaJokers',
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = false,  
    unlocked = true, --Desbloqueado por default
    discovered = true, --Descubierto por default
    pos = { x = 3, y = 3}, --Posicion asset
    config = { extra = { mult = 25, odds = 7, Xmult = 0.8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult ,G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom('tiendita_bald') < G.GAME.probabilities.normal / card.ability.extra.odds then
                return{
                    Xmult = card.ability.extra.Xmult
                }
            end
            return {
                mult = card.ability.extra.mult
            }
        end

    end
}