return {
  descriptions = {
    Joker = {

      j_tiendita_yu_sze = {
        name = "Yu Sze",
        text = { --Informacion sobre lo q hace
          "Este comodín obtiene {X:mult,C:white} X#2# {} multi",
          "cada vez que una carta de {C:attention}piedra{}",
          "es jugada",
          "{C:inactive}(Actual {X:mult,C:white} X#1# {C:inactive} multi)",
        },
      },

      j_tiendita_cepillin = {
        name = "Cepillin",
        text = { --Informacion sobre lo q hace
           "Cuando tu mano jugada es {C:attention}#1#{}",
            "y tiene {C:attention}5{} cartas, reactiva todas",
            "tus cartas al anotar {C:attention}#2#{} veces adicionales"
        },
      },

      j_tiendita_bust = {
        name = "Busto",
        text = { --Informacion sobre lo q hace
          "Reactiva todas las cartas de {C:attention}piedra{} jugadas",
        },
      },

      j_tiendita_junaluska = {
        name = "Junaluska",
        text = { --Informacion sobre lo q hace
          "{C:chips}+#1#{} fichas",
          "{C:green}#2# en #3#{} probabilidades",
          "de que la carta se destruya",
          "al final de la ronda",
        },
      },

      j_tiendita_red_delicious = {
        name = "Red Delicious",
        text = { --Informacion sobre lo q hace
          "{X:blue,C:white}X#1#{} fichas",
          "{C:green}#2# en #3#{} probabilidades",
          "de que la carta se destruya",
          "al final de la ronda",
        },
      },

      j_tiendita_lucky_clover = {
        name = "Trébol de la suerte",
        text = { --Informacion sobre lo q hace
          "Las cartas jugadas de {C:attention}#1#{}",
          "tienen {C:green}#2# en #3#{} de volverse",
          "cartas de la {C:attention}suerte{}",
        },
      },


      j_tiendita_moai = {
        name = "Moái",
        text = { --Informacion sobre lo q hace
          "Este comodín gana",
          "{X:blue,C:white}X#1#{} fichas por cada carta de {C:attention}piedra{} destruida",
          "{C:chips}+#2#{} fichas por cada carta de {C:attention}piedra{} jugada}",
          "{C:inactive}[Acutal {C:chips}+#4#{}{C:inactive} & {X:blue,C:white}X#3#{C:inactive} fichas]{}",
        },
      },

      j_tiendita_snake = {
        name = "Serpiente",
        text = {
          "Si tu {C:attention}mano jugada{} tiene solo",
          "{C:attention}1{} carta {C:attention}+#1#{} tamaño de la mano",
          " en esta ronda",
          "{C:red}#2#{} descarte",
        }
      },

      j_tiendita_paleta_payaso = {
        name = "Paleta Payaso",
        text = {
            "Todas las cartas de {C:attention}figura{} jugadas tienen",
            "{C:green}#2# en #3#{} probabilidades de convertirse en otra carta de {C:attention}figura{}",
            "{C:green}#2# en #4#{} probabilidades de cambiar su {C:attention}Mejora",
            "{C:green}#2# en #5#{} probabilidades de cambiar su {C:attention}Edición",
        },
      },

      j_tiendita_souls = {
        name = "Almas",
        text = {
            "Después de {C:attention}#1#{} rondas",
            "vende esta carta para",
            "crear una carta de {C:purple}El alma{}",
            "{C:inactive}(actual {C:attention}#2#{C:inactive}/#1#)",
        },
      },

      j_tiendita_balloon = {
        name = "Globo",
        text = {
            "{C:attention}+#1#{} multi cada ronda",
            "{C:green}#2# en #3#{} probabilidades de que la carta",
            "se destruya al final de la ronda",
            "{C:inactive}(Actual {C:attention}+#4#{C:inactive} multi)",
        },
      },

    

    }
  },

  misc = {
    dictionary = {
      k_lucky = "Suerte",
      k_nye = "NyE",
      k_change = "¡¡Cambio!!",
      k_blow = "Inflado",
      k_pop = "¡POP!",
      k_dojya = "DOJYAAA~N"
    }
  }

}