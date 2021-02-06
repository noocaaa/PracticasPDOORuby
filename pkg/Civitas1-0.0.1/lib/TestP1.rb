# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "dado"
require_relative "diario"
require_relative "tablero"
require_relative "mazo_sorpresas"
require_relative "casilla"

module Civitas
  
  #TAREA 1 OKKKK!!!
  
=begin
  puts "TAREA 1"
  
  j1 = j2 = j3 = j4 = 0
  for i in 1..100 do
    valor = Dado.instance.quienempieza(4)
    if valor == 0
      j1 += 1
    elsif valor == 1
      j2 += 1
    elsif valor == 2
      j3 += 1
    else
      j4 += 1
    end
  end
  puts "j1 #{j1}"
  puts "j2 #{j2}"
  puts "j3 #{j3}"
  puts "j4 #{j4}"
  
  puts "-----------------------------------------------------------------------"
=end
  
  #TAREA 2 - OOOOK!!

=begin  
  puts "TAREA 2"
  
  Dado.instance.setdebug(true)
  puts "Metodo debug activado"
  for i in 1..10 do
    puts Dado.instance.tirar
  end
  Dado.instance.setdebug(false)
  puts "Metodo debug desactivado"
  for i in 1..10 do
    puts Dado.instance.tirar
  end
  
  puts "-----------------------------------------------------------------------"
=end

  #TAREA 3 OOOOKK!!!!!
  
=begin
  puts "TAREA 3"
  
  for i in 1..10 do
    Dado.instance.tirar
    puts Dado.instance.ultimoResultado
    puts Dado.instance.salgodelacarcel
    puts "                    --------------                         "
  end
  
  puts "-----------------------------------------------------------------------"
=end
  
  #TAREA 4 - ES ESTO ??
  
=begin  
  puts "TAREA 4"
  
  puts Tipo_casilla: :descanso
  puts Tipo_sorpresa: :ircarcel
  
  puts "-----------------------------------------------------------------------"
=end  
  
  #TAREA 5 - OK!!!!!

=begin  
  puts "TAREA 5"
  
obj = MazoSorpresas.new()
  sorpresa1 = Sorpresa.new('Sorpresa 1')
  sorpresa2 = Sorpresa.new('Sorpresa 2')
  sorpresa3 = Sorpresa.new('Sorpresa 3')
  
  obj.almazo(sorpresa1)
  obj.almazo(sorpresa2)
  obj.almazo(sorpresa3)
  
  puts "Como son puestos en el mazo"
  puts sorpresa1
  puts sorpresa2
  puts sorpresa3
  
  puts obj.siguiente()
  puts obj.siguiente()
  puts obj.siguiente()
  
  puts "remezcla"
  
  puts obj.siguiente()
  puts obj.siguiente()
  puts obj.siguiente()
 
  puts "-----------------------------------------------------------------------" 
=end
  
  #TAREA 6 - OOOOK!!!!
  
=begin
  puts "TAREA 6"

  puts Diario.instance.eventos_pendientes #debería dar false
  puts Diario.instance.ocurre_evento("UN EVENTO NUEVO")
  puts Diario.instance.eventos_pendientes #debería dar true
  puts Diario.instance.leer_evento #mostrar lo escrito en ocurre_eventos
  
puts "-----------------------------------------------------------------------"
=end
  
  #TAREA 7 - depurador WTF? . NO SE QUE PROBLEMA HAY XD
  
=begin
  puts "TAREA 7"
  
  temp = Tablero.new(8)
  
  uno = Casilla.new('uno')
  dos = Casilla.new('dos')
  tres = Casilla.new('tres')
  q = Casilla.new('q')
  c = Casilla.new('c')
  s = Casilla.new('s')
  
  temp.aniadecasilla(uno)
  temp.aniadecasilla(dos)
  temp.aniadecasilla(tres)
  temp.aniadecasilla(q)
  temp.aniadecasilla(c)
  temp.aniadecasilla(s)
  temp.aniadejuez

  tirada = Dado.instance.tirar
  punto = 4
  destino = temp.nuevaposicion(punto, tirada)
  puts temp.p
  puts tirada
  puts destino
  puts temp.calculartirada(punto, destino)
  
  puts "-----------------------------------------------------------------------"
=end
  
end