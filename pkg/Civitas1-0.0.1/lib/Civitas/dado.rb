require 'singleton'

module Civitas
  class Dado
    include Singleton
 
    attr_reader :ultimoResultado
    
    @@salidaCarcel = 5

    private

      def initialize #DONEE
        @random = Random.new          #generación de número aleatorios
        @ultimoResultado = 0
        @debug = false
      end
    
    public
      def tirar #DONEE
        if !@debug
          @ultimoResultado = rand(6) +1
        else
          @ultimoResultado = 1
        end
        @ultimoResultado
      end
      
      def salgo_de_la_carcel #DONEE
        dado = tirar # cuando se llama a la funcion, ella misma tira. Si no lo queremos asi, debemos poner @ultimoResultado
        if dado >= @@SalidaCarcel
          estado = true
        else
          estado = false
        end
        estado
      end
      
      def quien_empieza(n) #DONEE
        @random.rand(n)
      end
      
      def set_debug(d) #DONEE
        @debug = d
        if d
          Diario.instance.ocurre_evento("El metodo debug esta activado")
        else
          Diario.instance.ocurre_evento("El metodo debug no esta activado")          
        end
      end
      
  end
end
