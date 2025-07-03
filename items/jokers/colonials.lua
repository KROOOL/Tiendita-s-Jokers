local joker = {
  name = "Colonial Joker",
  atlas = 'TienditaJokers',
  rarity = 2,
  cost = 6,
  blueprint_compat = true,
  eternal_compat = true,
  unlocked = true,
  discovered = true,
  pos = { x = 6, y = 2 },
  config = { extra = { xMult = 0.5 } },
  loc_vars = function(self, info_queue, card)
    local xMult = TIN_UTIL.calculate_colonial_xMult(card)
    return { vars = { card.ability.extra.xMult, xMult } }
  end,

  calculate = function(self, card, context)
    if context.joker_main then
      local xMult = TIN_UTIL.calculate_colonial_xMult(card)
      if xMult ~= 1 then
        return { x_mult = xMult, card = card }
      end
    end
  end,
}

local smods_showman_ref = SMODS.showman
function SMODS.showman(card_key)
    if card_key == "j_tiendita_colonials"
       and next(SMODS.find_card("j_tiendita_colonials")) then
        return true
    end
    return smods_showman_ref(card_key)
end


return joker

