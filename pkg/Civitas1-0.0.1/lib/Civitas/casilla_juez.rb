require_relative "casilla"

module Civitas
  class CasillaJuez < Casilla
    @@carcel = nil
    
    def initialize (numCasillaCarcel, nombre)
      super(nombre)
      @@carcel = numCasillaCarcel
    end
    
    @Override
    def recibe_jugador( actual, todos )
      if jugador_correcto(actual, todos)
        informe(actual, todos)
        todos[actual].encarcelar(@@carcel)
      end
    end
    
    @Override
    def to_string
         "\nNombre: " + super.nombre.to_s + "\nTipo Casilla: JUEZ" + "\n Carcel: " + @@carcel.to_s     
    end
  end
end