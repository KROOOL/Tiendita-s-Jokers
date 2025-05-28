local current_mod = SMODS.current_mod
Tiendita = SMODS.current_mod

tin_config = SMODS.current_mod.config

local mod_path = SMODS.current_mod.path

if tin_config["Jokers"] == nil then
  tin_config["Jokers"] = true
end

--thanks to notmario, i learn how to do this thing with his code
local joker_list = {
    --Comunes
    "balloon",
    "piggy_bank",
    "junaluska",
    "red_delicious",
    "alien",
    "bald",

    --Inusuales
    "d4c",
    "d6",
    "lucky_clover",
    "baby",
    "otherhalf",
    "bust",
    "headshot",

    --Raros
    "snake",
    "souls",
    "paleta_payaso",
    "damocles",
    "moai",

    --Legendarios
    "yu_sze",
    "cepillin",

}

if not tin_config["Jokers"] then
  joker_list = {}
end

for _, v in ipairs(joker_list) do
  print(v)
  local joker = SMODS.load_file("items/jokers/"..v..".lua")()
  if not joker then
    goto continue
  end
  joker.key = v
  joker.atlas = "TienditaJokers"
  if not joker.pos then
    joker.pos = { x = 0, y = 0 }
  end

  local joker_obj = SMODS.Joker(joker)
  for k_, v_ in pairs(joker) do
    if type(v_) == 'function' then
      joker_obj[k_] = joker[k_]
    end
  end

  ::continue::
end

SMODS.Atlas {
    key = 'TienditaJokers',
    path = 'TienditaJokers.png',
    px = 71,
    py = 95,
}

SMODS.Atlas({
  key = "modicon",
  path = "tin_icon.png",
  px = 32,
  py = 32
})

SMODS.Atlas({ 
  key = "enhancers", 
  atlas_table = "ASSET_ATLAS", 
  path = "enhancers.png", 
  px = 71, 
  py = 95 
})

SMODS.Atlas({
  key = "rev_tarots",
  atlas_table = "ASSET_ATLAS",
  path = "rev_tarots.png",
  px = 71, 
  py = 95
})

assert(SMODS.load_file("items/enhancers.lua"))()
assert(SMODS.load_file("items/rev_tarots.lua"))()

--Blinds WIPS
--Las vo a poner aca pq no creo hacer mas de 10 (espero)
--SMODS.Atlas({key = 'tiendita_blinds', path = 'Blinds.png', px = 34, py = 34, frames = 21, atlas_table = 'ANIMATION_ATLAS'})

--SMODS.Blind{ -- The Toon
--    key = 'toon',
--    debuff = {h_size_ge = 4},
--    boss = {min = 3},
--
--    debuff_hand = function(self, cards, check)
--        if not G.GAME.blind.disabled then
--            local condition = true
--            if self.debuff.h_size_ge and #cards < self.debuff.h_size_ge then
--              return condition
--            end
--        end
--    end, 
--
--    boss_colour = HEX('cccccc'),
--
--    pos = {y = 0},
--    atlas = 'tiendita_blinds'   
--}
