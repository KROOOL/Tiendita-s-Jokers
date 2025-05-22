--Queria hacer otra cosa para d4c pero no jalo, si alguien lee esto y lo arregla le doy 5 peso
--O si yo del futuro quiere recordar la idea: si la mano descartada contiene un par destruye estos pares
local joker = {
    name = "D4C", --Nombre
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

return joker