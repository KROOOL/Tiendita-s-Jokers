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
            "y tiene {C:attention}5{} cartas, entonces reactiva todas",
            "tus cartas jugadas al anotar {C:attention}#2#{} veces adicionales"
        },
      },

      j_tiendita_bust = {
        name = "Busto",
        text = { --Informacion sobre lo q hace
          "Reactiva todas las cartas de {C:attention}piedra{} jugadas",
        },
      }
    }
  }
}