# encoding:utf-8

require_relative "casilla"
require_relative "casilla_juez"

module Civitas
  class Tablero 
    #DONE
    def initialize(numCasilla) #visibilidad de paquete, es publica. Y si es publica no hace falta ponerlo porque ya viene dado
      #atributos de instancia
      @casillas = Array.new     #contenedor de las casillas del juego
      @porSalida = 0            #número de veces que se ha pasado por la salida
      @tieneJuez = false        #si tablero tiene una casilla de este tipo

      if numCasilla >= 1 #número de casilla donde se encuentra la cárcel. NO SE SI ESTO SE DEBERIA PONER AQUÍ
        @numCasillaCarcel = numCasilla
      else
        @numCasillaCarcel = 1
      end

      salida = Casilla.new('Salida')
      @casillas << salida 
    end
    
    private
      def correcto_sin #DONEE
        for i in @casillas
          if i.nombre == 'juez'
            @tieneJuez = true
          end
        end
        (@casillas.length > @numCasillaCarcel) && @tieneJuez
      end

      def correcto(numCasilla) #DONEE
        correcto_sin && (numCasilla < @casillas.length) && numCasilla >= 0
      end

    public
      attr_reader :numCasillaCarcel, :casillas #DONE
      
      def get_por_salida #DONEE
        if @porSalida > 0
          @porSalida -= 1
          salida = @porSalida + 1
        else
          salida = @porSalida
        end
        salida
      end
      
      def aniade_casilla(casilla) #DONEE
        if @casillas.length == @numCasillaCarcel
          carcel = Casilla.new_casilla('Carcel')
          @casillas << carcel
        end
        
        @casillas << casilla
        
        if @casillas.length == @numCasillaCarcel
          carcel = Casilla.new('Carcel')
          @casillas << carcel
        end
      end
      
      def aniade_juez #DONEE
        for i in @casillas #nos aseguramos de que no este, para no crearlo duplicado
          if i.nombre == 'juez'
            @tieneJuez = true
          end
        end
        
        if !@tieneJuez
          aniade_casilla(CasillaJuez.new(@numCasillaCarcel, "Juez")) #modificado de new a new_casillajuez
          @tieneJuez = true
        end
      end
      
      def get_casilla(numCasilla) #DONEE
        if correcto(numCasilla)
          ret = @casillas[numCasilla]
        else 
          ret = nil #null en ruby
        end
        ret
      end
      
      def nueva_posicion(actual,tirada) #DONEE
        if correcto_sin
          pos = (actual + tirada)
          if pos > (actual + tirada)
            @porSalida += 1
            salida = pos - @casillas.size
          else
            salida = pos
          end
        else
          salida = -1
        end
        salida
      end
      
      def calculartirada(origen,destino) #DONEE
        tir = destino - origen
        if tir < 0
          salida = tir + @casillas.length
        else 
          salida = tir
        end
        salida + 1
      end
      
  end
end
