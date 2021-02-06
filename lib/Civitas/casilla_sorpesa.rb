# encoding:utf-8

require_relative "casilla"

module Civitas
  class CasillaSorpresa < Casilla
    
    def initialize (mazo, nombre)
      super(nombre)
      @mazo = mazo
    end

    @Override
    def recibe_jugador(actual, todos)
      if jugador_correcto(actual, todos)
          sorpresa = @mazos.siguiente
          informe(actual, todos)
          sorpresa.aplicar_a_jugador(actual, todos)
      end
    end
    
    @Override
    def to_string
      "\n Nombre: " + super.nombre.to_s + "\n Tipo Casilla: SORPRESA" 
    end
  end
end
