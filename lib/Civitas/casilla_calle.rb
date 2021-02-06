require_relative "casilla"

module Civitas
  class CasillaCalle < Casilla
    attr_reader :tituloPropiedad
    
    def initialize (titulo)
        super
        @tituloPropiedad = titulo
    end
    
    @Override
    def recibe_jugador(actual, todos)
      if jugador_correcto(actual, todos)

        informe(actual, todos)
        jugador = todos[actual]
        

        if !@tituloPropiedad.tiene_propietario
          jugador.puede_comprar_casilla
        else
          @tituloPropiedad.tramitar_alquiler(jugador)
        end
      end
    end
    
    @Override
    def to_string
      "\nNombre: " + @titulo.nombre.to_s + "\nTipo Casilla: CALLE"    
    end
    
    public :tituloPropiedad
  end
end
