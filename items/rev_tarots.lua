SMODS.ConsumableType {
    key = 'tiendita_ReverseTarot',
    default = 'c_tiendita_fool',
    primary_colour = HEX("9d3c3c"),
    secondary_colour = HEX("9d3c3c"),
    collection_rows = { 5, 6 },
    shop_rate = 4
}

  G.C.SECONDARY_SET.rev_tarots = HEX("9d3c3c")


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