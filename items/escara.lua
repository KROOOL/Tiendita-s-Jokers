--functions/hooks

--Create UTILS
TIN_UTIL = TIN_UTIL or {}

-- Calculate how many colonial joker
function TIN_UTIL.calculate_colonial_xMult(card)
  local step = card.ability.extra.xMult or 0.5
  local count = 0

  if G.jokers and G.jokers.cards then
    for _, current_card in pairs(G.jokers.cards) do
      if current_card ~= card
         and string.lower(current_card.ability.name) == "colonial joker" then
        count = count + 1
      end
    end
  end
  count = count + 1
  if count <= 1 then
    return 1
  else
    return 1 + (count - 1) * step
  end
end

--Transformar caras
local original_get_id = Card.get_id

function Card:get_id()
    if self.ability.equizde == 11 then
        return 13
    end

    if original_get_id then
        return original_get_id(self)
    end

    return self.base and self.base.id or 0
end
