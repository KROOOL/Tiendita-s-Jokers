local joker = {
    name = "Cepillin", --Nombre
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
return joker
