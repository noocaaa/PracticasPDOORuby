require_relative "jugador"
require_relative "diario"

module Civitas
  class JugadorEspeculador < Jugador
    
     attr_accessor :fianza
    
    @@FactorEspeculador = 2
    
    def initialize (player, fianza)
      #(nombre,saldo,puedecomprar,numcasilla,encarcelado,propiedades,salvoconducto)
      super(player.nombre,player.saldo,player.puedeComprar,player.numCasillaActual,player.encarcelado,player.propiedades,player.salvoconducto)
      
      @fianza = fianza
      
      for i in(0...self.propiedades.size)
        self.propiedades.at(i).actualiza_propietario_por_conversion(self)
      end
    end

    @Override
    def CasasMax
      super.CasasMax*@@FactorEspeculador;
    end

    @Override
    def HotelesMax
      super.HotelesMax*@@FactorEspeculador;
    end

    @Override
    def to_string
      puts "\n El jugador es un JugadorEspeculador y tiene " + @propiedades.length.to_s + " propiedades"
    end

    @Override
    def paga_impuestos
      if super.encarcelado
        dev = false
      else 
        dev = paga(cantidad/@@FactorEspeculador)
      end
      dev
    end

    @Override
    def debe_ser_encarcelado
      if super.encarcelado
        devuelve=false
      else
        if !super.tiene_salvaconducto 
          if super.puedogastar(@fianza)
            super.paga(@fianza)
            devuelve = false
          else
            devuelve = true
          end
        else
          texto = "El jugador " + @nombre + " se libra de la carcel."
          super.perder_salvoconducto
          Diario.instance.ocurre_evento(texto)
          devuelve = false
        end
      end
      devuelve  
    end

  end
end