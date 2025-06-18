--Slime
SMODS.Enhancement {
    key = 'slime',
    atlas = 'enhancers',
    pos = { x = 0, y = 0 },
    config = { extra = { copy = 1, odds = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds, card.ability.extra.copy } }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            if pseudorandom('odds') < G.GAME.probabilities.normal / card.ability.extra.odds then
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local copy_card = copy_card(card, nil, nil, G.playing_card)
                copy_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, copy_card)
                G.hand:emplace(copy_card)
                copy_card.states.visible = nil

                G.E_MANAGER:add_event(Event({
                    func = function()
                        copy_card:start_materialize()
                        return true
                    end
                }))
                return {
                    message = localize('k_copied_ex'),
                    colour = G.C.CHIPS,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.calculate_context({ playing_card_added = true, cards = { copy_card } })
                                return true
                            end
                        }))
                    end
                }
            end
        end
    end
}

-- Snow
SMODS.Enhancement {
    key = 'snow',
    atlas = 'enhancers',
    pos = { x = 1, y = 0 },
    config = { smult = 1, mult_gain = 2},

    calculate = function(self, card, context)
        if G.snowball_mult == nil then
            G.snowball_mult = self.config.smult
        end

        if context.main_scoring and context.cardarea == G.play then
            card.ability.smult = card.ability.smult + G.snowball_mult

            G.snowball_mult = G.snowball_mult * self.config.mult_gain

            return {
                mult = G.snowball_mult
            }
        end

        if context.after and not context.main_scoring then
            G.snowball_mult = nil
        end
    end
}

--Platinum ya no
SMODS.Enhancement {
    key = 'lead',
    atlas = 'enhancers',
    pos = { x = 0, y = 1 },
    config = { h_chips = 60 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.h_chips } }
    end,
}

--Wood
SMODS.Enhancement {
    key = 'wood',
    atlas = 'enhancers',
    pos = {x = 2, y = 0},
    config = {extra = {wchips = 0, chips_gain = 5}},
    loc_vars = function (self, info_queue, card)
        return { vars = {card.ability.extra.wchips, card.ability.extra.chips_gain}}
    end,

    calculate = function (self, card, context)
        if context.before and context.cardarea == G.play then
            card.ability.extra.wchips =  card.ability.extra.wchips + card.ability.extra.chips_gain

            if card.facing == "front" then
                G.E_MANAGER:add_event(Event({trigger = 'after',card:flip()}))
            end
            local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
            local rank_suffix = card.base.id == 14 and 2 or math.min(card.base.id+1, 14)
            if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
            elseif rank_suffix == 10 then rank_suffix = 'T'
            elseif rank_suffix == 11 then rank_suffix = 'J'
            elseif rank_suffix == 12 then rank_suffix = 'Q'
            elseif rank_suffix == 13 then rank_suffix = 'K'
            elseif rank_suffix == 14 then rank_suffix = 'A'
            end
            card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            if card.facing == "back" then
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,card:flip()}))
            end
        end
        if context.main_scoring and context.cardarea == G.play then
            return {
                chips = card.ability.extra.wchips
            }
        end
    end
}

--Geode
SMODS.Enhancement {
    key = "geode",
    atlas = 'enhancers',
    pos = { x = 4, y = 0 },
    config = {gdollars = 3, ggdollars = 7, value = nil},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.gdollars, card.ability.ggdollars} }
    end,
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,

    calculate = function(self, card, context, info_queue)
        if context.main_scoring and context.cardarea == G.play then
            math.randomseed(pseudorandom('geode'))
            card.ability.value = math.random(card.ability.gdollars, card.ability.ggdollars)
            return { 
                dollars = card.ability.value
            }
        end

        if context.after and context.cardarea == G.play then
            local to_remove = {}
            for _, c in ipairs(context.scoring_hand) do
                if c.ability.gdollars == 3 then
                    c.destroyed = true
                    table.insert(to_remove, c)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c:start_dissolve()
                            c:remove_from_deck()
                            return true
                        end
                    }))
                end
            end
            if #to_remove > 0 then
                SMODS.calculate_context({
                    remove_playing_cards = true,
                    removed               = to_remove
                })
            end
        end    
    end
}

--Chaos
SMODS.Enhancement {
    key = "chaos",
    atlas = 'enhancers',
    pos = { x = 3, y = 0 },
    config = {chipi = 10, chipii = 50, varoi = 1, varoii = 3, multi = 1, multii = 15, xmulti = 1.1, xmultii = 2, efecto = 0},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.chipi, card.ability.chipii, card.ability.varoi, card.ability.varoii, card.ability.multi, card.ability.multii, card.ability.xmulti, card.ability.xmultii} }
    end,

    calculate = function(self, card, context, info_queue)
        if context.main_scoring and context.cardarea == G.play then
            math.randomseed(pseudorandom('chaos'))
            if pseudorandom('chaos') < 1 / 4 then
                card.ability.efecto = card.ability.xmulti + math.random() * (card.ability.xmultii - card.ability.xmulti)
                return { 
                    Xmult = card.ability.efecto
                }
            elseif pseudorandom('chaos') < 2 / 4 then
                card.ability.efecto = math.random(card.ability.varoi, card.ability.varoii)
                return { 
                    dollars = card.ability.efecto
                }
            elseif pseudorandom('chaos') < 3 / 4 then
                card.ability.efecto = math.random(card.ability.multi, card.ability.multii)
                return { 
                    mult = card.ability.efecto
                }
            else
                card.ability.efecto = math.random(card.ability.chipi, card.ability.chipii)
                return { 
                    chips = card.ability.efecto
                }
            end
        end  
    end
}

--Royal Card 
SMODS.Enhancement{
    key = "royal",
    atlas = "enhancers",
    pos = {x = 1, y = 1},
    config = {equizde = 11},
    loc_vars = function (self, info_queue, card)
        return {vars = {"King"}}
    end,
}

--Tin
SMODS.Enhancement{
    key = "tin",
    atlas = "enhancers",
    pos = {x = 4, y = 0},
    config = {tmult = 3},
    loc_vars = function (self, info_queue, card)
        return { vars = {card.ability.tmult}}
    end,

    calculate = function (self, card, context, info_queue)
        if context.main_scoring and context.cardarea == G.play then
            return{
                Xmult = card.ability.tmult
            }
        end
        if context.after and context.cardarea == G.play then
            G.E_MANAGER:add_event(Event({trigger = 'after', card:set_ability(G.P_CENTERS.m_tiendita_tin3, nil, true)}))
        end
    end
}

--Tin2
SMODS.Enhancement{
    key = "tin2",
    atlas = "enhancers",
    pos = {x = 3, y = 0},
    config = {tmult = 2},
    loc_vars = function (self, info_queue, card)
        return { vars = {card.ability.tmult}}
    end,

    calculate = function (self, card, context, info_queue)
        if context.main_scoring and context.cardarea == G.play then
            return{
                Xmult = card.ability.tmult
            }
        end
        if context.after and context.cardarea == G.play then
            G.E_MANAGER:add_event(Event({trigger = 'after', card:set_ability(G.P_CENTERS.m_tiendita_tin3, nil, true)}))
        end
    end
}

--Tin3
SMODS.Enhancement{
    key = "tin3",
    atlas = "enhancers",
    pos = {x = 2, y = 0},
    config = {tmult = 1.5},
    loc_vars = function (self, info_queue, card)
        return { vars = {card.ability.tmult}}
    end,

    calculate = function (self, card, context, info_queue)
        if context.main_scoring and context.cardarea == G.play then
            return{
                Xmult = card.ability.tmult
            }
        end
        if context.after and context.cardarea == G.play then
            local to_remove = {}
            for _, c in ipairs(context.scoring_hand) do
                if c.ability.tmult == 1.5 then
                    c.destroyed = true
                    table.insert(to_remove, c)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            c:start_dissolve()
                            c:remove_from_deck()
                            return true
                        end
                    }))
                end
            end
            if #to_remove > 0 then
                SMODS.calculate_context({
                    remove_playing_cards = true,
                    removed               = to_remove
                })
            end
        end
    end
}