require_relative "sorpresa"

module Civitas
  class SorpresaPAGARCOBRAR < Sorpresa
    def initialize (valor, texto)
      super(valor, texto)
    end
    
    @Override
    def aplicar_a_jugador(actual, todos) #DONEE
      jugador = todos[actual];
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        jugador.modificar_saldo(@valor)
      end
    end
  
    @override
    def to_string
      "\nTipo Sorpresa: PAGARCOBRAR" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end
  end
end