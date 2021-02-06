# encoding: UTF-8

require_relative "tablero"
require_relative "diario"
require_relative "operaciones_juego"
require_relative "mazo_sorpresas"
require_relative "dado"
require_relative "gestor_estados"
require_relative "estados_juego"
require_relative "jugador"
require_relative "titulo_propiedad"

#casilla
require_relative "casilla"
require_relative "casilla_calle"
require_relative "casilla_juez"
require_relative "casilla_impuesto"
require_relative "casilla_sorpesa"

#sorpresa
require_relative "sorpresa"
require_relative "sorpresa_ircarcel"
require_relative "sorpresa_ircasilla"
require_relative "sorpresa_pagarcobrar"
require_relative "sorpresa_porcasahotel"
require_relative "sorpresa_porjugador"
require_relative "sorpresa_salircarcel"
require_relative "sorpresa_especulador"


module Civitas
  class CivitasJuego
    attr_reader :jugadores, :indiceJugadorActual
    
    def initialize(nombres)
      @jugadores = Array.new
      for n in nombres do
        @jugadores << Jugador.new_nombre(n)
      end
      
      @gestorEstados = Gestor_estados.new
      @estado = @gestorEstados.estado_inicial

      @indiceJugadorActual = Dado.instance.quien_empieza(@jugadores.length)

      @mazo = MazoSorpresas.new
      @tablero = Tablero.new(5)

      inicializar_tablero(@mazo)
      inicializar_mazosorpresas(@tablero)
    end
    
    def cancelar_hipoteca (ip)
      get_jugador_actual.cancelar_hipoteca(ip)
    end
    
    def comprar 
      jugadoractual = get_jugador_actual
      numcasillaactual = jugadoractual.numCasillaActual
      casilla = @tablero.get_casilla(numcasillaactual)
      titulo = casilla.tituloPropiedad
      res = jugadoractual.comprar(titulo)
      res
    end
    
    def construir_casa (ip)
      get_jugador_actual.construir_casa(ip)
    end
    
    def construir_hotel (ip)
      get_jugador_actual.construir_hotel(ip)
    end
    
    def final_del_juego
      banc = false
      for i in @jugadores
        if i.en_bancarrota
          banc = true
        end
      end
      banc
    end
    
    def get_casilla_actual
      @tablero.get_casilla(get_jugador_actual.numCasillaActual)      
    end
    
    def get_jugador_actual
      @jugadores[@indiceJugadorActual]
    end
    
    def hipotecar (ip)
      get_jugador_actual.hipotecar(ip);
    end
    
    def info_jugador_texto
      get_jugador_actual.to_s #en mi código to_string
    end
    
    def salir_carcel_pagando
      get_jugador_actual.salir_carcel_pagando
    end
    
    def salir_carcel_tirando
      get_jugador_actual.salir_carcel_tirando
    end
    
    def siguiente_paso 
      jugadoractual = get_jugador_actual
      operacion = @gestorEstados.operaciones_permitidas(jugadoractual, @estado)
      
      if operacion == Civitas::Operaciones_juego::PASAR_TURNO
        pasar_turno
        siguiente_paso_completado(operacion)
        jugadoractual.to_string
      elsif operacion == Civitas::Operaciones_juego::AVANZAR
        avanza_jugador
        siguiente_paso_completado(operacion)
      end
      operacion
    end
    
    def siguiente_paso_completado (operacion)
      @estado = @gestorEstados.siguiente_estado(get_jugador_actual, @estado, operacion)
    end
    
    def vender (ip)
      get_jugador_actual.vender(ip);  
    end
    
    #se ha cambiado la visibilidad de private a public para poder usarlo en VistaTextual
    def ranking 
      @jugadores.sort { |a,b| a.compare_to(b) }
    end
    
  private
    def avanza_jugador 
        jugadoractual = get_jugador_actual #1.1
        posicionactual = jugadoractual.numCasillaActual #1.2
        tirada = Dado.instance.tirar #1.3
        posicionnueva = @tablero.nueva_posicion(posicionactual, tirada) #1.4
        casilla = @tablero.get_casilla(posicionnueva) #1.5
        contabilizar_pasos_por_salida(jugadoractual) #1.6  
        jugadoractual.mover_a_casilla(posicionnueva) #1.7
        casilla.recibe_jugador(@indiceJugadorActual, @jugadores) #1.8 donde hay error de memoria
        contabilizar_pasos_por_salida(jugadoractual) #1.9  
    end
    
    def contabilizar_pasos_por_salida (jugadorActual)
        while (@tablero.get_por_salida > 0) do
          jugadorActual.pasa_por_salida        
        end
    end
    
    def inicializar_mazosorpresas(tablero) 
      @mazo.al_mazo(SorpresaIRCARCEL.new(tablero))
      @mazo.al_mazo(SorpresaIRCARCEL.new(tablero))

      @mazo.al_mazo(SorpresaIRCASILLA.new(tablero, 6, "Ve a la Casilla 6"))
      @mazo.al_mazo(SorpresaIRCASILLA.new(tablero, 3, "Ve a la Casilla 15"))
      @mazo.al_mazo(SorpresaIRCASILLA.new(tablero, 11, "Ve a la Casilla 11"))

      @mazo.al_mazo(SorpresaPAGARCOBRAR.new(-1000, "Pagar a otro jugador 1000"))
      @mazo.al_mazo(SorpresaPAGARCOBRAR.new(-1000, "Pagas a la banca"))
      @mazo.al_mazo(SorpresaPAGARCOBRAR.new(800, "Recibes dinero"))

      @mazo.al_mazo(SorpresaPORCASAHOTEL.new(100, "Pagas por cada casa y cada hotel"))
      @mazo.al_mazo(SorpresaPORCASAHOTEL.new(50, "Pagas por cada casa y cada hotel"))

      @mazo.al_mazo(SorpresaPORJUGADOR.new(100, "Recibes dinero de los demas"))
      @mazo.al_mazo(SorpresaPORJUGADOR.new(-100, "Le das a cada jugador"))
      @mazo.al_mazo(SorpresaPORJUGADOR.new(300, "Recibes dinero de los demas"))

      @mazo.al_mazo(SorpresaSALIRCARCEL.new(@mazo))
      @mazo.al_mazo(SorpresaSALIRCARCEL.new(@mazo))
      
      @mazo.al_mazo(SorpresaESPECULADOR.new(200, "Te conviertes en un jugador especulador."))
    end
    
    
    
    def inicializar_tablero (mazo) 
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Madrid", 50, 20, 100, 100, 50)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Barcelona", 50, 20, 120, 150, 60)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Granada", 50, 20, 100, 100, 50)))
        @tablero.aniade_casilla(CasillaSorpresa.new(mazo, "Primera Sorpresa"))

        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Paris", 60, 20, 140, 200, 70)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Lyon", 64, 20, 160, 250, 80)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Montpellier", 80, 20, 200, 300, 90)))
        @tablero.aniade_casilla(CasillaSorpresa.new(mazo, "Segunda Sorpresa"))

        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Londres", 85, 20, 220, 350, 100)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Glasgow", 90, 20, 240, 400, 110)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Liverpool", 95, 20, 260, 450, 120)))
        @tablero.aniade_casilla(Casilla.new("Parking"))

        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Nueva York", 110, 20, 300, 500, 130)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Chicago", 115, 20, 320, 550, 140)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Los Angeles", 120, 20, 340, 600, 150)))
        @tablero.aniade_casilla(CasillaImpuesto.new(400, "impuesto"))
        @tablero.aniade_juez
        @tablero.aniade_casilla(CasillaSorpresa.new(mazo, "Tercera Sorpresa"))

        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Canberra", 125, 20, 360, 650, 160)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Melbourne", 140, 20, 400, 700, 170)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Sydney", 145, 20, 420, 750, 180)))
        @tablero.aniade_casilla(CasillaSorpresa.new(mazo, "Cuarta Sorpresa"))

        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Quebec", 155, 20, 440, 800, 190)))
        @tablero.aniade_casilla(CasillaCalle.new(TituloPropiedad.new("Calle Ontario", 170, 20, 460, 850, 200)))
      
    end
    
    def pasar_turno
      @indiceJugadorActual = (@indiceJugadorActual +1) % @jugadores.size            
    end
  end
  
end

  

