# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'singleton'

module Civitas
  class Diario
    include Singleton

    # Este módulo ya proporciona la funcionalidad del patrón Singleton
    # Esto incluye tanto la referencia a la instancia como el constructor de ese atributo
    # También convierte al constructor new en un método privado
    
    def initialize
      @eventos = []
    end

    def ocurre_evento(e)
      @eventos << e
    end

    def eventos_pendientes
      return (@eventos.length > 0)
    end

    def leer_evento
      e = @eventos.shift
      return e
    end

  end
end

#así se obtiene la única instancia del diario Diario.instance