SMODS.ConsumableType {
    key = 'tiendita_ReverseTarot',
    default = 'c_tiendita_fool',
    primary_colour = HEX("9d3c3c"),
    secondary_colour = HEX("9d3c3c"),
    collection_rows = { 5, 6 },
    shop_rate = 6
}

  G.C.SECONDARY_SET.rev_tarots = HEX("9d3c3c")

--rev fool
SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Fool",
    key = "rev_fool",
    pos = { x = 0, y = 0 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    
    can_use = function(self, card)
        return (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables)
            and G.GAME.last_rev_tarot
            and G.GAME.last_rev_tarot ~= 'c_tiendita_rev_fool'
    end,
    
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        if G.GAME.last_rev_tarot and G.GAME.last_rev_tarot ~= "c_tiendita_rev_fool" then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local new_card = create_card('Rev_Tarot', G.consumeables, nil, nil, nil, nil, G.GAME.last_rev_tarot, 'fool')
                        new_card:add_to_deck()
                        G.consumeables:emplace(new_card)
                        used_tarot:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    
    loc_vars = function(self, info_queue, card)
        local fool_c = G.GAME.last_rev_tarot and G.P_CENTERS[G.GAME.last_rev_tarot] or nil
        local last_tarot_name = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
        local colour = (not fool_c or fool_c.name == 'rev_Fool') and G.C.RED or G.C.GREEN

        if fool_c and fool_c.name ~= 'rev_Fool' then
            info_queue[#info_queue + 1] = fool_c
        end

        return {
            vars = { last_tarot_name },
            main_end = {
                {
                    n = G.UIT.C, config = { align = "bm", padding = 0.02 }, nodes = {
                        {
                            n = G.UIT.C, config = { align = "m", colour = colour, r = 0.05, padding = 0.05 }, nodes = {
                                {
                                    n = G.UIT.T, config = {
                                        text = ' ' .. last_tarot_name .. ' ',
                                        colour = G.C.UI.TEXT_LIGHT,
                                        scale = 0.3,
                                        shadow = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Magician",
    key = "rev_magician",
    pos = { x = 1, y = 0 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

--view the least used planet
local function get_least_played_planet()
     local least_played = math.huge
    local least_hands = {}

    for _, hand_key in ipairs(G.handlist) do
        local hd = G.GAME.hands[hand_key]
        if hd and hd.visible then
            if hd.played < least_played then
                least_played = hd.played
                least_hands = { hand_key }
            elseif hd.played == least_played then
                table.insert(least_hands, hand_key)
            end
        end
    end

    if #least_hands > 0 then
        local chosen_hand = least_hands[ math.random(#least_hands) ]
        for _, planet in pairs(G.P_CENTER_POOLS.Planet) do
            if planet.config and planet.config.hand_type == chosen_hand then
                return planet.key
            end
        end
    end

    return nil
end



--rev priestess
SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Priestess",
    key = "rev_priestess",
    pos = { x = 2, y = 0 },
    config = { extra = { planets = 2 } },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.planets } }
    end,
    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.extra.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')

                        local planet_key = get_least_played_planet()

                       if planet_key then
                            SMODS.add_card({
                                set = 'Planet',
                                key = planet_key,
                                key_append = "pl1"
                            })
                        else
                            SMODS.add_card({ set = 'Planet' }) -- fallback
                        end

                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,

    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end
})


SMODS.Consumable {
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Empress",
    key = "rev_empress",
    pos = { x = 3, y = 0 },
    atlas = "rev_tarots",
    config = { max_highlighted = 2, mod_conv = 'm_tiendita_snow' },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Emperor",
    key = "rev_emperor",
    pos = { x = 4, y = 0 },
    config = { extra = { revtarots = 2 } },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.revtarots } }
    end,
    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.extra.revtarots, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({ set = 'tiendita_ReverseTarot' })
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
    end

})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Hierophant",
    key = "rev_hierophant",
    pos = { x = 5, y = 0 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Lovers",
    key = "rev_lovers",
    pos = { x = 6, y = 0 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

  -- rev chariot
  SMODS.Consumable({
    object_type = "Consumable",
    set = "tiendita_ReverseTarot",
    name = "rev_Chariot",
    key = "rev_chariot",
    pos = { x = 7, y = 0 },
    config = {
      max_highlighted = 1,
      mod_conv = "m_tiendita_slime"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS.m_tiendita_slime
  
      return { vars = { 
        card and card.ability.max_highlighted or self.config.max_highlighted,
        localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}
      } }
    end
  })


SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Justice",
    key = "rev_justice",
    pos = { x = 8, y = 0 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Hermit",
    key = "rev_hermit",
    pos = { x = 9, y = 0 },
    config = { extra = { set = 30 } },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.set } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)

            local current = to_number(G.GAME.dollars)
            local target = card.ability.extra.set or 30
            local give = target - current
            ease_dollars(give)

            return true
            end
        }))
        delay(0.6)
    end,

    can_use = function(self, card)
        return true
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Fortune",
    key = "rev_fortune",
    pos = { x = 0, y = 1 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

-- rev strength
SMODS.Consumable {
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Strength",
    key = "rev_strength",
    pos = { x = 1, y = 1 },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    config = { max_highlighted = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    -- SMODS.modify_rank will increment/decrement a given card's rank by a given amount
                    assert(SMODS.modify_rank(G.hand.highlighted[i], -1))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
        delay(0.5)
    end,
}

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Hanged",
    key = "rev_hanged",
    pos = { x = 2, y = 1 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Death",
    key = "rev_death",
    pos = { x = 3, y = 1 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Temperance",
    key = "rev_temperance",
    pos = { x = 4, y = 1 },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    config = { value = 5},
    loc_vars = function(self, info_queue, card)
        local value = card.ability.value or 4
        local empty_slots = G.jokers and ((G.jokers.config.card_limit - #G.jokers.cards)) or 0
        return { vars = { value, (empty_slots * value) } }
    end,

    use = function(self, card, context)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)

                local value = card.ability.value or 4
                local empty_slots = (G.jokers.config.card_limit - #G.jokers.cards)
                local give = math.max(0, empty_slots) * value
                ease_dollars(give)

                return true
            end
        }))
        delay(0.6)
    end,

    can_use = function(self, card)
        return true
    end
})


SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Devil",
    key = "rev_devil",
    pos = { x = 5, y = 1 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Tower",
    key = "rev_tower",
    pos = { x = 6, y = 1 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

--ty to notmario
function suit_search(card, copier)
    local used_tarot = copier or card
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.7,
        func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)

            local cards = {}
            for i = 1, card.ability.val do
                cards[i] = true
                local _suit = card.ability.suit
                local _rank = pseudorandom_element({'A','2','3','4','5','6','7','8','9','T','J','Q','K'}, pseudoseed('suitarot'))

                --Crear carta base
                local _card = create_playing_card({
                    front = G.P_CARDS[_suit .. '_' .. _rank],
                    center = G.P_CENTERS.c_base
                }, G.hand, nil, i ~= 1, nil)

                --Aplicar sello
                _card:set_seal(SMODS.poll_seal({
                    guaranteed = true,
                    type_key = 'vremade_certificate_seal' -- Cambia este key si querés usar otro sello
                }))
            end

            playing_card_joker_effects(cards)
            return true
        end
    }))
end

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Star",
    key = "rev_star",
    pos = { x = 7, y = 1 },
    config = {
      val = 2,
      suit = "D"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.cards >= 1
    end,
    use = function(self, card, area, copier)
      suit_search(card, copier)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Moon",
    key = "rev_moon",
    pos = { x = 8, y = 1 },
    config = {
      val = 2,
      suit = "C"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.cards >= 1 
    end,
    use = function(self, card, area, copier)
      suit_search(card, copier)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Sun",
    key = "rev_sun",
    pos = { x = 9, y = 1 },
    config = {
      val = 2,
      suit = "H"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.cards >= 1
    end,
    use = function(self, card, area, copier)
      suit_search(card, copier)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Judgement",
    key = "rev_judgement",
    pos = { x = 0, y = 2 },
    config = {},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_World",
    key = "rev_world",
    pos = { x = 1, y = 2 },
    config = {
      val = 2,
      suit = "S"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.cards >= 1
    end,
    use = function(self, card, area, copier)
      suit_search(card, copier)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
})