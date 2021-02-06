# encoding: utf-8

require_relative "../Civitas/dado"
#require_relative "../Civitas/tipo_casilla"
# require_relative "../Civitas/tipo_sorpresa"
require_relative "../Civitas/operaciones_juego"
require_relative "../Civitas/estados_juego"
require_relative "../Civitas/diario"
require_relative "../Civitas/casilla"
require_relative "../Civitas/tablero"
require_relative "../Civitas/civitas_juego"
require_relative "../Civitas/gestor_estados"
require_relative "../Civitas/mazo_sorpresas"
require_relative "../Civitas/sorpresa"
require_relative "vista_textual"
require_relative "controlador"

module Civitas
  class TestP3
    def self.main
      @vista = Vista_textual.new
      @nombres = ['Aiden', 'Lucia', 'Marta', 'Alberto']
      
      @juego = CivitasJuego.new(@nombres)

      Dado.instance.set_debug(true)

      controlador = Controlador.new(@juego, @vista)
      
      controlador.juega()

    end
  end
  TestP3.main
end