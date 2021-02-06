# encoding: utf-8

require_relative '../Civitas/operaciones_juego'
require_relative '../Civitas/civitas_juego'
require_relative '../Civitas/operacion_inmobiliaria'
require_relative '../Civitas/diario'
require_relative '../Civitas/respuestas'
require_relative '../Civitas/salidas_carcel'
require 'io/console'

module Civitas

  class Vista_textual
    
    attr_reader :iPropiedad, :iGestion
    
    def mostrar_estado(estado) #HECHO POR LOS PROFESORES
      puts estado
    end

    
    def pausa #HECHO POR LOS PROFESORES
      print "Pulsa una tecla"
      STDIN.getch
      print "\n"
    end

    def lee_entero(max,msg1,msg2) #HECHO POR LOS PROFESORES
      ok = false
      begin
        print msg1
        cadena = gets.chomp
        begin
          if (cadena =~ /\A\d+\Z/)
            numero = cadena.to_i
            ok = true
          else
            raise IOError
          end
        rescue IOError
          puts msg2
        end
        if (ok)
          if (numero >= max)
            ok = false
          end
        end
      end while (!ok)

      return numero
    end



    def menu(titulo,lista) #HECHO POR LOS PROFESORES
      tab = "  "
      puts titulo
      index = 0
      lista.each { |l|
        puts tab+index.to_s+"-"+l
        index += 1
      }
      opcion = lee_entero(lista.length,"\n"+tab+"Elige una opcion: ",tab+"Valor erroneo")
      return opcion
    end

    
    def comprar #DONE!
      opc = Array.new
      opc = ['Si', 'No']
      opcion = menu("Desea comprar la calle?", opc)
      
      listares = [Civitas::Respuestas::SI, Civitas::Respuestas::NO]
      
      listares[opcion]
    end

    def gestionar #DONE!
      opciones = [GestionesInmobiliarias::VENDER, GestionesInmobiliarias::HIPOTECAR,
        GestionesInmobiliarias::CANCELAR_HIPOTECA, GestionesInmobiliarias::CONSTRUIR_CASA,
        GestionesInmobiliarias::CONSTRUIR_HOTEL, GestionesInmobiliarias::TERMINAR
      ]
      
      final = Array.new
      propiedades = Array.new

      
      opciones.each { |g| final << g.to_s  }
      
      @iGestion = menu("Seleccione la gestión inmobiliaria.", final)
      
      unless opciones[@iGestion] == GestionesInmobiliarias::TERMINAR 
        @juegoModel.get_jugador_actual.propiedades.each { |p| propiedades << p.nombre }
        @iPropiedad = menu("Seleccione la propiedad.", propiedades)
      end
      
      opciones[@iGestion]
    end

    def mostrar_siguiente_operacion(operacion) #DONE!
      puts "\n Siguiente operación: " + operacion.to_s + "\n"
    end

    def mostrar_eventos #DONE!
      puts "\n---------------- EMPEZAMOS A LEER EL DIARIO------------------"
      while Diario.instance.eventos_pendientes
        puts Diario.instance.leer_evento
      end
      puts "----------------- DEJAMOS DE LEER EL DIARIO------------------\n"
    end
    
    def salir_carcel #DONE!
      opc = Array.new
      opc = ['Pagando', 'Tirando el dado']
      opcion = menu('Elige la forma para intentar salir de la carcel', opc)
             
      listasal = [Civitas::SalidasCarcel::PAGANDO, Civitas::SalidasCarcel::TIRANDO]
      
      listasal[opcion]
    end
    
    def set_civitas_juego(civitas) #HECHO POR LOS PROFESORES
        @juegoModel=civitas
        self.actualizar_vista
    end

    def actualizar_vista #DONE!
      jugadoractual = @juegoModel.get_jugador_actual
      casilla = @juegoModel.get_casilla_actual
      puts jugadoractual.to_string
      puts casilla.to_string
    end

  end

end