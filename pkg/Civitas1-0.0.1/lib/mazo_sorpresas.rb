# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "sorpresa"
require_relative "diario"

module Civitas
  class MazoSorpresas
    
    private
    
      def init
        @barajada = false               #para saber si esta barajada o no
        @usadas = 0                     #contar el número de cartas del mazo que ya han sido usadas
        @sorpresas = Array.new          #almacenar las cartas Sorpresa
        @cartasEspeciales = Array.new   #almacena carta sorpresa SALIRDELACARCEL cuando es retirada del mazo
      end
    
    public
    
      def initialize
        init
        @debug   = false           #activar/desactivar modo depuración
        @ultimaSorpresa = nil     #guardar la ultima sorpresa que ha salido
      end
      
      def initialize(d = false)
        @debug = d
        init 
        @ultimaSorpresa = nil
        if @debug
          Diario.instance.ocurre_evento("El metodo debug ha sido activado")
        end
      end
      
      def almazo(s)
        if !@barajado
          @sorpresas << s
        end
      end
      
      def siguiente
        
        if !@barajada or @usadas == (@sorpresas.length) 
          puts "uno"
          if !@debug
            @usadas = 0
            @sorpresas.shuffle!
            @barajada = true
            puts "dos"
          end
        end
        
        @usadas = @usadas + 1;
        @ultimaSorpresa = @sorpresas[0]
        @sorpresas.delete_at(0)
        @sorpresas << @ultimaSorpresa
        
        return @ultimaSorpresa
      end
      
      def inhabilitarcartaespecial(sorpresa)
        for s in @sorpresas do
          if sorpresa == i
              @cartasEspeciales << sorpresa
              @sorpresas.delete(sorpresa)
              Diario.instance.ocurre_evento("Se ha inhabilitado la carta especial")
          end
        end  
      end
      
      def habilitarcartaespecial(sorpresa)
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
