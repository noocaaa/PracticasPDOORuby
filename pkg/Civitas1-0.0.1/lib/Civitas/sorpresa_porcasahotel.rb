require_relative "sorpresa"

module Civitas
  class SorpresaPORCASAHOTEL < Sorpresa
    
    def initialize (valor, texto)
      super(valor, texto)
    end
    
    @Override
    def aplicar_a_jugador(actual, todos) #DONEE
      jugador = todos[actual];
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        jugador.modificar_saldo(@valor*jugador.cantidad_casas_hoteles)
      end
    end
    
    @Override
    def to_string
      "\nTipo Sorpresa: PORCASAHOTEL" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end 
    
  end
end