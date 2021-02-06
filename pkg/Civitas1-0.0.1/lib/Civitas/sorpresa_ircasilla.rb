require_relative "sorpresa"
require_relative 'tablero'


module Civitas
  class SorpresaIRCASILLA < Sorpresa
    def initialize (tablero, valor, texto)
      super(valor, texto)
      @tablero = tablero
    end
    
    @Override
    def aplicar_a_jugador(actual, todos) #DONEE
      jugador = todos[actual];   
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        casillaactual = jugador.numCasillaActual
        tirada = @tablero.calcular_tirada(casillaactual, @valor)
        nuevaposicion = @tablero.nueva_posicion(casillaactual, tirada)
        jugador.mover_a_casilla(nuevaposicion)
        @tablero.get_casilla(@valor).recibe_jugador(actual, todos)
      end
    end
    
    @Override
    def to_string
      "\nTipo Sorpresa: IRCASILLA" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end
  end
end
