require_relative "diario"

module Civitas
  class MazoSorpresas
    
    private
    
      def init #DONEE
        @barajada = false               #para saber si esta barajada o no
        @usadas = 0                     #contar el número de cartas del mazo que ya han sido usadas
        @sorpresas = Array.new          #almacenar las cartas Sorpresa
        @cartasEspeciales = Array.new   #almacena carta sorpresa SALIRDELACARCEL cuando es retirada del mazo
        @ultimaSorpresa
        @debug
      end
      
      def set_debug (d) #DONEE
        Civitas::Diario.instance.ocurre_evento("Set Debug = #{d}")
        @debug = d
      end
    
    public
          
      def initialize(d = false) #DONEE
        init 
        @debug = d
        if @debug
          Diario.instance.ocurre_evento("El metodo debug ha sido activado")
        else
          Diario.instance.ocurre_evento("El metodo debug no ha sido activado")
        end
      end
      
      def al_mazo(s) #DONEE
        if !@barajado
          @sorpresas << s
        end
      end
      
      def siguiente #DONEE
        if !@barajada or @usadas >= (@sorpresas.length)
          if !@debug
            @usadas = 0
            @sorpresas.shuffle
            @barajada = true
          end
        end
        
        @usadas = @usadas + 1;
        @ultimaSorpresa = @sorpresas.at(0)
        @sorpresas.delete_at(0)
        @sorpresas << @ultimaSorpresa
        
        @ultimaSorpresa #devuelve ultima sorpresa
      end
      
      def inhabilitar_carta_especial(sorpresa) #DONEE
        for s in @sorpresas do
          if sorpresa == s
              @cartasEspeciales << sorpresa
              @sorpresas.delete(sorpresa)
              Diario.instance.ocurre_evento("Se ha inhabilitado la carta especial")
          end
        end  
      end
      
      def habilitar_carta_especial(sorpresa) #DONEE
        for i in @cartasEspeciales do
          if sorpresa == i
              @sorpresas << sorpresa
              @cartasEspeciales.delete(sorpresa)
              Diario.instance.ocurre_evento("Se ha habilitado la carta especial")
          end
        end         
      end
      
  end
end
