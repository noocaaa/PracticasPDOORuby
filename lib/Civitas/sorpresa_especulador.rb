require_relative "jugador_especulador"
require_relative "sorpresa"

module Civitas
  class SorpresaESPECULADOR < Sorpresa
    
    def initialize (valor, texto)
      super(valor, texto)
    end
    
    @Override
    def aplicar_a_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
       
        jugador = JugadorEspeculador.new(todos[actual], 200)
        
        todos.delete_at(actual)
        todos.insert(actual, jugador)

      end
    end
    
    @Override
    def to_string
      "\n Tipo Sorpresa: Jugador Especulador" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end
    
  end
end
