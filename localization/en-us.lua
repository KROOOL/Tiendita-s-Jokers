local loc_tien = {
  descriptions = {
    --Jokers
    Joker = {
      j_tiendita_yu_sze = {
        name = "Yu Sze", --Nombre
        text = { --Informacion sobre lo q hace
            "This Joker gains {X:mult,C:white}X#2#{} Mult each time",
            "a {C:attention}Stone{} card is scored",
            "{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)",
        },
      },
      j_tiendita_cepillin = {
        name = "Cepillin", --Nombre
        text = { --Informacion sobre lo q hace
          "Retrigger all played cards {C:attention}#2#{} additional times", 
          "if {C:attention}played hand{} is {C:attention}#1#{}",
          "and contains {C:attention}5{} cards",
        },
      },
      j_tiendita_snake = {
        name = "Snake", --Nombre
        text = {
          "If {C:attention}played hand{} has only",
          "{C:attention}1{} card {C:attention}+#1#{} hand size",
          "in the current round,",
          "{C:red}#2#{} discard",
        },
      },
      j_tiendita_souls = {
        name = "Souls", --Nombre
        text = {
            "After {C:attention}#1#{} rounds,",
            "sell this card to",
            "create a free {C:purple}The Soul{} card",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
        },
      },
      j_tiendita_paleta_payaso = {
        name = "Paleta Payaso",
        text = {
            "All scored {C:attention}#1#{} cards have",
            "{C:green}#2# in #3#{} chance to change to another {C:attention}#1#{} card",
            "{C:green}#2# in #4#{} chance to change its {C:attention}#6#",
            "{C:green}#2# in #5#{} chance to change its {C:attention}#7#",
        },
      },
      j_tiendita_damocles = {
        name = "Damocles",
        text = {
            "{X:mult,C:white}X#1#{} Mult,",
            "when {C:attention}blind{} is selected {C:green}#2# in #3#{} chances",
            "to set hands to {C:attention}1{}",
            "and {C:attention}lose all discards{}",
        },
      },
      j_tiendita_moai = {
        name = "Moai", --Nombre
        text = {
            "This Joker gains ",
            "{X:blue,C:white}X#1#{} Chips for each destroyed {C:attention}Stone{} card",
            "{C:chips}+#2#{} Chips for each played {C:attention}Stone{} card",
            "{C:inactive}[Currently {C:chips}+#4#{}{C:inactive} & {X:blue,C:white}X#3#{C:inactive} Chips]{}",
        },
      },
      j_tiendita_d4c = {
        name = "D4C", --Nombre
        text = {
            "If discard hand contain exactly {C:attention}3{}",
            "cards and two of them are of the same {C:attention}rank{}",
            "{C:attention}destroy{} all cards",
        },
      },
      j_tiendita_d6 = {
        name = "D6",
        text = {
            "{C:attention}Sell{} this Joker to destroy all other",
            "Jokers and create {C:attention}random Jokers",
            "{C:attention}equal{} to the amount of Jokers destroyed",
        },
      },
      j_tiendita_lucky_clover = {
        name = "Lucky Clover", --Nombre
        text = {
            "Played {C:attention}#1#{} cards have",
            "{C:green}#2# in #3#{} chance to become",
            "{C:attention}Lucky{} cards when scored",
        },
      },
      j_tiendita_baby = {
        name = "Baby Joker",
        text = {
          "This Joker gains {X:mult,C:white}X#1#{} Mult when",
          "{C:attention}2{}, {C:attention}3{}, {C:attention}4{} or {C:attention}5{} is played",
          "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
        },
      },
      j_tiendita_balloon = {
        name = "Balloon", --Nombre
        text = {
            "{C:mult}+#1#{} Mult each round",
            "{C:green}#2# in #3#{} chance this",
            "card is destroyed at end of round",
            "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)",
        },
      },
      j_tiendita_otherhalf = {
        name = "Other Half Joker",
        text = {
            "{C:mult}+#1#{} Mult if played",
            "hand contains",
            "{C:attention}#2#{} or fewer cards",
        }
      },
      j_tiendita_piggy_bank = {
       name = "Piggy Bank",
        text = {
            "This Joker gains {C:money}$#2#{} of",
            "{C:attention}sell value{} per each {C:money}$#1#{}",
            "that you have when",
            "exiting the shop",
        },
      },
      j_tiendita_junaluska = {
        name = "Junaluska", --Nombre
        text = {
            "{C:chips}+#1#{} Chips",
            "{C:green}#2# in #3#{} chance this",
            "card is destroyed",
            "at end of round",
        },
      },
      j_tiendita_red_delicious = {
        name = "Red Delicious", --Nombre
          text = {
              "{X:blue,C:white} X#1#{} Chips",
              "{C:green}#2# in #3#{} chance this",
              "card is destroyed",
              "at end of round",
          },
      },
      j_tiendita_alien = {
        name = "Alien Joker",
          text = {
              "{C:chips}+10{} Chips per {C:blue}Planet{}",
              "card used this run",
              "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
          }
      },
      j_tiendita_bald = {
        name = "Bald Joker",
          text = {
              "{C:mult}+#1#{} Mult",
              "{C:green}#2# in #3#{} chance to ",
              "{X:mult,C:white}X#4#{} Mult",
          }
      },
      j_tiendita_bust = {
        name = "Bust", --Nombre
          text = { --Informacion sobre lo q hace
              "Retrigger all played {C:attention}Stone{} cards",
          },
      },
      j_tiendita_headshot = {
        name = "Headshot",
        text = {
            "This Joker gains {X:mult,C:white}X#2#{} Mult",
            "when {C:attention}Blind{} is defeated using",
            "only {C:attention}1{} hand, if Blind isn't",
            "defeated then this Joker destroys itself",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
        },
      },
    },

    --Enhanced
    Enhanced = {
      m_tiendita_slime = {
        name = "Slime Card",
        text = {
          "{C:attention}#1# in #2#{} chance to add a",
          "permanent copy to deck and",
          "draw it to {C:attention}hand{}"
        },
      },
      m_tiendita_snow = {
        name = "Snow Card",
        text = {
          "{C:mult}X2{} Mult based on",
          "the number of Snow Cards played",
          "before this one in the hand",
          "{C:inactive}(Example: +2, +4, +8, +16, etc.){}"
        }
      }
    },

    --Reverse rev_tarots
    tiendita_ReverseTarot = {
      c_tiendita_rev_chariot = {
        name = "Reverse The Chariot",
        text = {
          "Enhances {C:attention}#1#{} selected",
          "card into a",
          "{C:attention}#2#"
        }
      },
      c_tiendita_rev_strength = {
        name = "Reverse The Strength",
        text = {
          "Decreases rank of",
          "up to {C:attention}2{} selected",
          "cards by {C:attention}1{}"
        }
      },
      c_tiendita_rev_empress = {
        name = "Reverse The Empress",
        text = {
          "Enhances {C:attention}#1#{} selected",
          "card into a",
          "{C:attention}#2#"
        }
      },
      c_tiendita_rev_fool = {
        name = "Reverse The Fool",
        text = {
          "Creates the last",
          "{C:rev_tarots}Reverse Tarot{} card",
          "used during this run",
          "{s:0.8,C:rev_tarots}Reverse The Fool{s:0.8} excluded",
        }
      },
      c_tiendita_rev_emperor = {
        name = "Reverse The Emperor",
        text = {
          "Creates up to {C:attention}#1#{}",
          "random {C:rev_tarots}Reverse Tarot{} cards",
          "{C:inactive}(Must have room)",
        }
      },
      c_tiendita_rev_hermit = {
        name = "Reverse The Hermit",
        text = {
          "Set money to {C:money}$#1#{}",
        }
      },
      c_tiendita_rev_star = {
        name = "Reverse The Star",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Sealed{}",
          "{C:diamonds}Diamond{} to your hand",
        }
      },
      c_tiendita_rev_moon = {
        name = "Reverse The Moon",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Sealed{}",
          "{C:clubs}Clubs{} to your hand",
        }
      },
      c_tiendita_rev_sun = {
        name = "Reverse The Sun",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Sealed{}",
          "{C:hearts}Hearts{} to your hand",
        }
      },
      c_tiendita_rev_world = {
        name = "Reverse The Moon",
        text = {
          "Add {C:attention}#1#{} random {C:attention}Sealed{}",
          "{C:spades}Spades{} to your hand",
        }
      },
      c_tiendita_rev_temperance = {
        name = "Reverse Temperance",
        text = {
          "Gives {C:money}$#1#{} for each",
          "empty {C:attention}Joker{} slot",
          "{C:inactive}(Currently {C:money}$#2#{}{C:inactive}){}"

        }
      },
      c_tiendita_rev_priestess = {
        name = "Reverse Priestess",
        text = {
          "Creates up to {C:attention}#1#",
          "{C:planet}Planet{} cards for your",
          "least played {C:attention}poker hand{}",
          "{C:inactive}(Must have room){}",

        }
      },
      c_tiendita_rev_death = {
        name = "Reverse Death",
        text = {
          "Select {C:attention}#1#{} cards,",
          "transfer {C:attention}enhancement{}, {C:attention}edition{},",
          "and {C:attention}seal{} from the {C:attention}left{} card",
          "to the {C:attention}right{} card",
          "{C:inactive}(Drag to rearrange)"
        }
      },
      c_tiendita_rev_judgement = {
        name = "Reverse Judgement",
        text = {
          "Destroy the {C:attention}leftmost{}",
          "{C:attention}Joker{}, also destroy eternal",
          "{C:inactive}(Drag to rearrange)"
        }
      },
      c_tiendita_rev_hanged = {
        name = "Reverse Hanged Man",
        text = {
          "Generate {C:attention}#1#{} random cards",
        }
      },

    },

    --Blinds
    Blind = {
      bl_tiendita_toon = {
        name = "The Toon", --Nombre
          text = { --Informacion sobre lo q hace
              "Must play 4 cards",
          },
      }
    },
  },
  misc = {
    dictionary = {
      k_lucky = "Lucky",
      k_nye = "NyE",
      k_change = "Change!!",
      k_blow = "Blow Up",
      k_pop = "¡POP!",
      k_dojya = "DOJYAAA~N",
      k_damocles = "Greed",
      k_spotted = "SPOTTED!!",
      b_tiendita_reversetarot_cards = "Reverse Tarot Cards",
      k_tiendita_reversetarot = "Reverse Tarot",
    },
    labels = {
      tiendita_reversetarots = "Reverse Tarot Cards",
    }
  }
}
return loc_tien 