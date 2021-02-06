require_relative "jugador"
require_relative "jugador_especulador"
require_relative "titulo_propiedad"
require_relative "sorpresa"
require_relative "sorpresa_especulador"

module Civitas
  
  nombres = Array.new
  
  alberto = Jugador.new_nombre("Alberto")
  
  nombres << alberto
  
  uno = TituloPropiedad.new("Calle Granada", 50, 20, 100, 100, 50)
  
  puts "     Propiedad que se va a incorporar a Alberto     "
  puts uno.nombre
  
  puts "     Propiedad ha sido incorporada a Alberto     "
  nombres[0].comprar(uno)
  
  puts nombres[0].propiedades[0].to_string
  
  puts "\n Ahora aplicamos la sorpresa para convertirse en jugador especulador"
  
  surprise = SorpresaESPECULADOR.new(200, "Sorpresa Jugador Especulador")    
  surprise.aplicar_a_jugador(0, nombres)
  
  puts nombres[0].to_string
  
  puts "Vemos si la propiedad se ha mantenido en el jugador especulador"
  puts nombres[0].propiedades.to_string
  
end