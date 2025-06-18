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
