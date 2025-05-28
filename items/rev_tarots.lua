SMODS.ConsumableType {
    key = 'tiendita_ReverseTarot',
    default = 'c_tiendita_fool',
    primary_colour = HEX("9d3c3c"),
    secondary_colour = HEX("9d3c3c"),
    collection_rows = { 5, 6 },
    shop_rate = 4
}

  G.C.SECONDARY_SET.rev_tarots = HEX("9d3c3c")

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