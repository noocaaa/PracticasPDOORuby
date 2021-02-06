require_relative "sorpresa"

module Civitas
  class SorpresaSALIRCARCEL < Sorpresa
    
    def initialize (mazo)
      super(-1, 'Evitando la carcel')
      @mazo = mazo
    end
    
    def salir_del_mazo #DONEE
      @mazo.inhabilitar_carta_especial(self)
    end
    
    @Override
    def aplicar_a_jugador(actual, todos) #DONEE
      jugador = todos[actual];
      continuar = true
      if jugador_correcto(actual, todos)
        informe(actual, todos)

        #el for
        i = 0
        loop do
          if i < todos.length and continuar
            if todos[i].tiene_salvo_conducto
              continuar = false
            end
          end
          i += 1
        end

        if !continuar 
          jugador.obtener_salvo_conducto(self)
          salir_del_mazo
        end
      end
    end
    
    @Override
    def to_string
      "\nTipo Sorpresa: SALIRCARCEL" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end
    
    def usada
      @mazo.habilitarcartaespecial(self)
    end
  
  end
end