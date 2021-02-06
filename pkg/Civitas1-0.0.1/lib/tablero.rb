# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

# encoding:utf-8

require_relative "casilla"

module Civitas
  class Tablero 
  
    def initialize(numCasilla) #visibilidad de paquete, es publica. Y si es publica no hace falta ponerlo porque ya viene dado
      #atributos de instancia
      @casillas = Array.new     #contenedor de las casillas del juego
      @porSalida = 0            #número de veces que se ha pasado por la salida
      @tieneJuez = false        #si tablero tiene una casilla de este tipo
      
      if numCasilla > 1 #número de casilla donde se encuentra la cárcel. NO SE SI ESTO SE DEBERIA PONER AQUÍ
        @numCaillaCarcel = numCasilla
      else
        @numCasillaCarcel = 1
      end
      
      salida = Casilla.new('Salida');
      @casillas << salida 
    end
    
    private
      def correcto_sin
        if @tieneJuez && @numCasillaCarcel < @casillas.length 
          devuelve = true
        else 
          devuelve = false
        end
        return devuelve
      end
      
      def correcto(numCasilla)
        if correcto and (numCasilla >= 0 ) and (numCasilla < @casillas.length)
          devuelve = true
        else
          devuelve = false
        end
        return devuelve
      end
     
    public
      attr_reader :numCasillaCarcel
      
      def p
        return @casillas.length
      end
      
      def getporsalida
        if @porSalida > 0
          @porSalida -= 1
          salida = @porSalida + 1
        else
          salida = @porSalida
        end
        return salida
      end
      
      def aniadecasilla(casilla)
        if @casillas.length == @numCasillaCarcel
          carcel = Casilla.new('Carcel')
          @casillas << carcel
        end
        
        @casillas << casilla
        
        if @casillas.length == @numCasillaCarcel
          carcel = Casilla.new('Carcel')
          @casillas << carcel
        end
      end
      
      def aniadejuez
        if !@tieneJuez
          juez = Casilla.new('Juez')
          @casillas << juez
          @tieneJuez = true
        end
      end
      
      def getcasilla(numCasilla)
        if numCasilla >= 0 && numCasilla < @casillas.length
          ret = @casillas[numCasilla]
        else 
          ret = nil #null en ruby
        end
        return ret
      end
      
      def nuevaposicion(actual,tirada)
        if correcto_sin
          pos = actual + tirada
          if pos > @casillas.length
            devuelve = pos - @casillas.length
            @porSalida += 1
          else
            devuelve = pos
          end
        else
          return devuelve
        end
        return devuelve
      end
      
      def calculartirada(origen,destino)
        tir = destino - origen
        if tir < 0
          tir = tir + @casillas.length
        end
        return tir
      end
  end
end
