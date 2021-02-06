require_relative "tablero"
require_relative "sorpresa"

module Civitas
  class SorpresaIRCARCEL < Sorpresa
    
    def initialize (tablero)
      super(-1, "El jugador se va a la carcel")
      @tablero = tablero
    end
    
    @Override
    def aplicar_a_jugador_ir_carcel(actual, todos) #DONEE
      jugador = todos[actual]
      if jugador_correcto(actual, todos)
          informe(actual, todos)
          jugador.encarcelar(@tablero.numCasillaCarcel)
      end
    end
    
    @Override
    def to_string
     "\n Tipo Sorpresa: IRCASILLA" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end
    
  end
end
