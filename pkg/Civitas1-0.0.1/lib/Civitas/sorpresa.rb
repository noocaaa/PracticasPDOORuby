#encoding: utf-8

require_relative "diario"

module Civitas
  class Sorpresa
  
    def initialize(valor, texto)
      @tablero = nil
      @mazo = nil
      @texto = texto
      @valor = valor
    end
    
    def informe (actual, todos) #DONEE
      Diario.instance.ocurre_evento("Se esta aplicando una sorpresa al jugador " + todos[actual].nombre)
    end
        
    def jugador_correcto (actual, todos) #DONEE
      todos.length > actual && actual >= 0
    end
    
    @Override
    def to_string #DONEE
       "\n Sorpresa: " + @texto.to_s + "\n Valor: " + @valor.to_s
    end
 
    private

      def aplicar_a_jugador(actual, todos)     
      end
      
  end
end
