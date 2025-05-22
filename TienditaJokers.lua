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
  if v == "hyperjimbo" then
    joker.atlas = "mf_hyperjimbo"
  end
  if v == "rot_cartomancer" then
    joker.atlas = "mf_rot_cartomancer"
  end
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