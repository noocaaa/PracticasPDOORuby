# encoding:utf-8

require_relative 'vista_textual'
require_relative '../Civitas/civitas_juego'
require_relative '../Civitas/operaciones_juego'
require_relative '../Civitas/operacion_inmobiliaria'
require_relative '../Civitas/gestiones_inmobiliarias'

module Civitas
  class Controlador
    def initialize( juego, vista )
      @juego = juego
      @vista = vista
    end

    def juega
      @vista.set_civitas_juego(@juego)

      until @juego.final_del_juego      
        @vista.pausa
        siguientePaso = @juego.siguiente_paso
        @vista.mostrar_siguiente_operacion(siguientePaso)
        
        unless siguientePaso == Civitas::Operaciones_juego::PASAR_TURNO
          @vista.mostrar_eventos
        end
        
        unless @juego.final_del_juego
          case siguientePaso
          when Civitas::Operaciones_juego::COMPRAR
            if @vista.comprar == Civitas::Respuestas::SI
              if @juego.comprar
                puts "\nLa propiedad ha sido comprada"
              else
                puts "\nLa propiedad no se puede comprar"
              end
            end
            @juego.siguiente_paso_completado(siguientePaso)

          when Civitas::Operaciones_juego::GESTIONAR
            tipoGestion = @vista.gestionar

            unless tipoGestion == Civitas::GestionesInmobiliarias::TERMINAR
              iPropiedad = @vista.iPropiedad
              case tipoGestion
              when Civitas::GestionesInmobiliarias::CONSTRUIR_CASA
                if @juego.construir_casa(iPropiedad)
                  puts "\nSe ha construido una casa en la propiedad"
                else
                  puts "\nNo se ha podido construir una casa en la propiedad"
                end
                
              when Civitas::GestionesInmobiliarias::CONSTRUIR_HOTEL
                if @juego.construir_hotel(iPropiedad)
                  puts "\nSe ha construido un hotel en la propiedadn"
                else
                  puts "\nNo se ha podido construir un hotel en la propiedad"
                end
                
              when Civitas::GestionesInmobiliarias::HIPOTECAR
                if @juego.hipotecar(iPropiedad)
                  puts "\nSe ha hipotecado la propiedad"
                else
                  puts "\nNo se ha podido hipotecar la propiedad"
                end
              when Civitas::GestionesInmobiliarias::CANCELAR_HIPOTECA
                if @juego.cancelar_hipoteca(iPropiedad)
                  puts "\nSe ha cancelado la hipoteca de la propiedad"
                else
                  puts "\nNo se ha podido cancelar la hipoteca de la propiedad"
                end
              when Civitas::GestionesInmobiliarias::VENDER
                if @juego.vender(iPropiedad)
                  puts "\nSe ha vendido la propiedad"
                else
                  puts "\nNo se ha podido vender la propiedad"
                end
              end
            end 
            
            @juego.siguiente_paso_completado(siguientePaso)

          when Civitas::Operaciones_juego::SALIR_CARCEL
            tipoSalida = @vista.salir_carcel
            case tipoSalida
            when Civitas::SalidasCarcel::PAGANDO
              if @juego.salir_carcel_pagando
                puts "\nSe ha conseguido salir de la carcel pagando"
              else
                puts "\nNo se ha podido salir de la carcel pagando"
              end
            when Civitas::SalidasCarcel::TIRANDO
              if @juego.salir_carcel_tirando
                puts "\nSe ha conseguido salir de la carcel tirando el dado"
              else
                puts "\nNo se ha podido salir de la carcel tirando el dado"
              end
            end
            @juego.siguiente_paso_completado(siguientePaso)
          end
          
        end  
      end
      @vista.muestra_ranking
    end
  end
end