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
    config = { max_highlighted = 2, mod_conv = 'm_tiendita_chaos' },
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
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
    config = {
      max_highlighted = 2,
      mod_conv = "m_tiendita_wood"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function (self, card)
        return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_tiendita_wood

        return { vars = {
            card and card.ability.max_highlighted or self.config.max_highlighted,
            localize{type = "name_text", set = 'Enhanced', key = self.config.mod_conv}
        }}
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Lovers",
    key = "rev_lovers",
    pos = { x = 6, y = 0 },
    config = {
        max_highlighted = 1,
        mod_conv = "m_tiendita_tin"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS.m_tiendita_tin
  
      return { vars = { 
        card and card.ability.max_highlighted or self.config.max_highlighted,
        localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}
      } }
    end
})

  -- rev chariot
  SMODS.Consumable({
    object_type = "Consumable",
    set = "tiendita_ReverseTarot",
    name = "rev_Chariot",
    key = "rev_chariot",
    pos = { x = 7, y = 0 },
    config = {
      max_highlighted = 2,
      mod_conv = "m_tiendita_lead"
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function (self, card)
        return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_tiendita_lead

        return { vars = {
            card and card.ability.max_highlighted or self.config.max_highlighted,
            localize{type = "name_text", set = 'Enhanced', key = self.config.mod_conv}
        }}
    end
  })


--rev justice
SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Justice",
    key = "rev_justice",
    pos = { x = 8, y = 0 },
    config = { },
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

            local current = G.GAME.dollars
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

--rev wheel_of_fortune
SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Fortune",
    key = "rev_fortune",
    pos = { x = 0, y = 1 },
    config = { extra = {odds = 4}},
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.probabilities.normal, card.ability.extra.odds } }
    end,
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    use = function(self, card, area, copier)
    if pseudorandom('rev_wheel') < G.GAME.probabilities.normal / card.ability.extra.odds then
        -- Get eligible jokers that are NOT negative
        local upgradable_jokers = {}
        for _, j in ipairs(SMODS.Edition:get_edition_cards(G.jokers, false)) do
            if not j.edition.negative then
                table.insert(upgradable_jokers, j)
            end
        end

        -- If there's no eligible joker (safety check), do nothing
        if #upgradable_jokers == 0 then return end

        -- Pick one at random
        local eligible_card = pseudorandom_element(upgradable_jokers, pseudoseed('rev_wheel'))

        -- Determine new edition
        local edicion
        if eligible_card.edition.foil then
            edicion = {holo = true}
        elseif eligible_card.edition.holo then
            edicion = {polychrome = true}
        elseif eligible_card.edition.polychrome then
            edicion = {negative = true}
        end

        -- Apply new edition
        eligible_card:set_edition(edicion, true)
    else
        -- Failure feedback
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                        'tm' or 'cm',
                    offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
    end
end,
    can_use = function(self, card)
    for _, joker in ipairs(SMODS.Edition:get_edition_cards(G.jokers, false)) do
        if not joker.edition.negative then
            return true -- At least one joker is upgradable
        end
    end
    return false -- All jokers are already negative
end

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

function do_random_enhanced_draw(card, copier, count, seal_chance, edition_chance)
    count          = tonumber(count) or 0
    seal_chance    = tonumber(seal_chance) or 1
    edition_chance = tonumber(edition_chance) or 1

    local used_tarot = copier or card
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay   = 0.7,
        func    = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)

            local cen_pool = {}
            for _, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                if v.key ~= 'm_stone' and not v.overrides_base_rank then
                    cen_pool[#cen_pool + 1] = v
                end
            end

            local created = {}
            for i = 1, count do
                created[i] = true

                -- Rank al azar
                local rank = pseudorandom_element(
                    {'A','2','3','4','5','6','7','8','9','T','J','Q','K'},
                    pseudoseed('rank_'..i)
                )
                -- Palo al azar
                local suits = {'C','D','H','S'}
                local suit  = pseudorandom_element(suits, pseudoseed('suit_'..i))

                --Enhancement
                local enh = pseudorandom_element(
                    cen_pool,
                    pseudoseed('encanto_'..i)
                )

                --Crea nueva carta
                local new_card = create_playing_card({
                    front  = G.P_CARDS[suit..'_'..rank],
                    center = enh or G.P_CENTERS.c_base
                }, G.hand, true, i ~= 1, { G.C.SECONDARY_SET.Rotarot })

                --Sello
                if pseudorandom(pseudoseed('seal_'..i)) < seal_chance then
                    local seal = SMODS.poll_seal()
                    if seal then new_card:set_seal(seal) end
                end

                --Edition
                if pseudorandom(pseudoseed('edition_'..i)) < edition_chance then
                    local ed = poll_edition(wheel_of_fortune, nil, true, true)
                    if ed then new_card:set_edition(ed, nil, true) end
                end
            end

            playing_card_joker_effects(created)
            return true
        end
    }))
end

SMODS.Consumable({
    object_type = "Consumable",
    set       = 'tiendita_ReverseTarot',
    name      = "rev_Hanged",
    key       = "rev_hanged",
    pos       = { x = 2, y = 1 },
    config    = {
        amount         = 2,
        seal_chance    = 0.6,
        edition_chance = 0.3
    },
    cost      = 3,
    atlas     = "rev_tarots",
    unlocked  = true,
    discovered= true,
    loc_vars  = function(self, info_queue, card)
        return { vars = { tonumber(self.config.amount) or 0 } }
    end,
    use = function(self, card, area, copier)
        do_random_enhanced_draw(
            card,
            copier,
            self.config.amount,
            self.config.seal_chance,
            self.config.edition_chance
        )
    end,
    can_use = function(self, card)
        return #G.hand.cards >= 1
    end,
})


--reverse death 
--jaja la neta no se como hice esto, un saludo a la bandita que la sigue cotorreando y 
--a gpt por ayudarme a mis fallos de logica, cada dia mas aca y aca
SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Death",
    key = "rev_death",
    pos = { x = 3, y = 1 },
    config = { max_highlighted = 2, min_highlighted = 2 },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
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

        -- Detecta carta de la izquierda
        local leftmost = G.hand.highlighted[1]
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].T.x < leftmost.T.x then
                leftmost = G.hand.highlighted[i]
            end
        end


        --Copia solo los encantamientos
        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local src = leftmost
                    local dst = G.hand.highlighted[i]
                    if dst ~= src then
                        --1) Enhancement
                        if src.config.center and dst.config.center ~= src.config.center then
                            dst:set_ability(src.config.center)
                        end
                        
                        --2) Edition
                        if src.edition and dst.edition ~= src.edition then
                            dst:set_edition(src.edition)
                        elseif dst.edition then
                            dst:set_edition(nil)
                        end
                        
                        --3) Seal
                        if src.seal and dst.seal ~= src.seal then
                            dst:set_seal(src.seal)
                        end
                    end
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
    config = {
        max_highlighted = 1,
        mod_conv = "m_tiendita_geode"},
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    can_use = function(self, card)
      return #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted
    end,
    loc_vars = function(self, info_queue, card)
      info_queue[#info_queue + 1] = G.P_CENTERS.m_tiendita_geode
  
      return { vars = { 
        card and card.ability.max_highlighted or self.config.max_highlighted,
        localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}
      } }
    end
})

SMODS.Consumable({
    object_type = "Consumable",
    set = 'tiendita_ReverseTarot',
    name = "rev_Tower",
    key = "rev_tower",
    pos = { x = 6, y = 1 },
    config = {
        max_highlighted = 1,
        mod_conv = "m_tiendita_slime"},
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
                    type_key = 'vremade_certificate_seal'
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
    config = {
        max_highlighted = 1,
        min_highlighted = 1
    },
    cost = 3,
    atlas = "rev_tarots",
    unlocked = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.max_highlighted} }
    end,
    use = function(self, card, area, copier)
        local leftmost = nil
        for _, j in ipairs(G.jokers.cards) do
            if not leftmost or j.T.x < leftmost.T.x then
                leftmost = j
            end
        end

        if not leftmost then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    G.HUD:show_message("No Jokers found", nil, 2)
                    return true
                end
            }))
            return
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                leftmost:start_dissolve({HEX("ff0000")}, nil, 1.5)
                leftmost:remove_from_deck()
                return true
            end
        }))

        delay(0.6)
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards > 0
    end,
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