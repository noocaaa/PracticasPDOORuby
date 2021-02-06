# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'singleton'

module Civitas
  class Dado
    include Singleton
    
    private

      def initialize
        @random = 0           #generación de número aleatorios
        @ultimoResultado = 0
        @debug = false
        @@salidaCarcel = 5
      end
    
    public
      def tirar
        if !@debug
          @ultimoResultado = rand(5) +1
        else
          @ultimoResultado = 1
        end
        return @ultimoResultado
      end
      
      def salgodelacarcel
        dado = tirar # cuando se llama a la funcion, ella misma tira. Si no lo queremos asi, debemos poner @ultimoResultado
        if dado >=5 
          estado = true
        else
          estado = false
        end
        return estado
      end
      
      def quienempieza(n)
        return rand(n)
      end
      
      def setdebug(d)
        @debug = d
        if d
          Diario.instance.ocurre_evento("El metodo debug esta activado")
        else
          Diario.instance.ocurre_evento("El metodo debug no esta activado")          
        end
      end

      attr_reader :ultimoResultado
      
  end
end
