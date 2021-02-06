require_relative "casilla"

module Civitas
  class CasillaImpuesto < Casilla
    
    def initialize(cantidad, nombre)
      super(nombre)
      @importe = cantidad
    end
    
    @Override
    def recibe_jugador(actual, todos)
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        todos[actual].paga_impuesto(@importe)
      end
    end
    
    @Override
    def to_string
      "\nNombre: " + @titulo.nombre.to_s + "\nTipo Casilla: IMPUESTO" + "\n Importe: " + @importe.to_s    
    end
  end
end
