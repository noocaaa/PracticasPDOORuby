# encoding:utf-8

module Civitas
  class Jugador
    include Comparable
    
    attr_reader  :CasasPorHotel, :encarcelado, :numCasillaActual, :PasoPorSalida, :nombre, :propiedades, :puedeComprar, :saldo, :CasasMax, :HotelesMax, :PrecioLibertad, :salvoconducto
       
    private :CasasMax, :HotelesMax, :PrecioLibertad, :PasoPorSalida
    
    @@CasasMax = 4
    @@CasasPorHotel = 4
    @@HotelesMax = 4
    @@PasoPorSalida = 1000
    @@PrecioLibertad = 200
    @@SaldoInicial = 7500
      
    def initialize (nombre, saldo, puedecomprar, numcasilla, encarcelado, propiedades, salvoconducto) 
      @encarcelado = encarcelado
      @nombre = nombre
      @numCasillaActual = numcasilla
      @puedeComprar = puedecomprar
      @saldo = saldo
      @propiedades = propiedades
      @salvoconducto = salvoconducto
    end
    
    protected :initialize
    
    def self.new_jugador(otro) #constructor de copia #DONEE
      if self != otro
        new(otro.nombre, otro.saldo, otro.puedeComprar, otro.numCasillaActual, otro.propiedades, otro.salvoconducto)
      end
    end
    
    def self.new_nombre(nombre)
      new(nombre, @@SaldoInicial, true, 0, false, Array.new, nil)
    end
    
    def cancelar_hipoteca (ip)
      result = false
      if(@encarcelado)
        return result
      end
      
      if(existe_la_propiedad(ip))
        propiedad = @propiedades[ip]
        cantidad = propiedad.get_importe_cancelar_hipoteca
        puedoGastar = puedo_gastar(cantidad)
        
        if(puedoGastar)
          result = propiedad.cancelar_hipoteca(self)
          
          if(result)
            Diario.instance.ocurre_evento("El jugador " + @nombre + " cancela la hipoteca de 
              la propiedad " + ip.to_s)
          end
        end
      end
      
      return result
    end
    
    @Override
    def to_string  
      puts "El jugador " + @nombre + " tiene: \n Saldo: " + @saldo.to_s + "\n Casilla Actual: " + @numCasillaActual.to_s + "\n Encarcelado: " + @encarcelado.to_s + "\n Número de propiedades: " + @propiedades.length.to_s
    end
    
    def cantidad_casas_hoteles
      numtotal = 0
      for i in @propiedades do
        numtotal += @propiedades[i].cantidad_casas_hoteles
      end
      numtotal
    end
    
    @Override
    def compare_to (otro)
      @saldo <=> otro.saldo
    end
    
    def comprar (titulo)  
      result = false
      
      if(@encarcelado)
        return result
      end
      

      if@puedeComprar

        precio = titulo.precioCompra
        
        if(puedo_gastar(precio))
          result = titulo.comprar(self)

          if(result)
            @propiedades << titulo
            Diario.instance.ocurre_evento("El jugador " + @nombre + " compra la propiedad " + titulo.nombre)
          end
          
          @puedeComprar = false
        end
      end
      result
    end
    
    def construir_casa (ip)  
      result = false
      puedoEdificarCasa = false
      
      if @encarcelado
        result
      else
        existe = existe_la_propiedad(ip)
        if existe
          propiedad = @propiedades.at(ip)
          puedoEdificarCasa = puedo_edificar_casa(propiedad)

          if propiedad.numCasas < @@CasasMax 
            puedoEdificarCasa = true
          end
          
          if puedoEdificarCasa
            result = propiedad.construir_casa(self)
            if result
              Diario.instance.ocurre_evento("El jugador " + @nombre + " construye casa en la propiedad " + @propiedades[ip].nombre);                     
            end
          end
        end
      end   
      result
    end
    
    def construir_hotel (ip) 
      result = false
      if @encarcelado
        result
      end
      
      if existe_la_propiedad(ip)
        propiedad = @propiedades[ip]
        puedoEdificarHotel = puedo_edificar_hotel(propiedad)
        precio = propiedad.precioEdificar
        
        if puedo_gastar(precio)
          if propiedad.numHoteles < @@HotelesMax
            if propiedad.numCasas >= @@CasasPorHotel
              puedoEdificarHotel = true
            end
          end
        end
        
        if puedoEdificarHotel
          result = propiedad.construir_hotel(self)
          casashotel = @@CasasPorHotel
          propiedad.derruir_casas(casashotel, self)
          Diario.instance.ocurre_evento("El jugador " + @nombre + " construye hotel en la propiedad " + @propiedades[ip].nombre)
        end
      end
      result
    end
    
    def debe_ser_encarcelado
      if @encarcelado
        devuelve=false
      else
        if !tiene_salvaconducto 
          devuelve = true
        else
          texto = "El jugador " + @nombre + " se libra de la carcel."
          perder_salvoconducto
          Diario.instance.ocurre_evento(texto)
          devuelve = false
        end
      end
      devuelve
    end  
    
    def en_bancarrota
      @saldo < 0
    end
    
    def encarcelar (numCasillaCarcel)
      if debe_ser_encarcelado
        mover_a_casilla(numCasillaCarcel)
        @encarcelado = true
        Diario.instance.ocurre_evento('Jugador ha sido encarcelado')
      end
      @encarcelado
    end
  
    def hipotecar(ip)
      result = false
      if is_encarcelado
        result
      end
      if existe_la_propiedad(ip)
        propiedad = @propiedades[ip]
        result = propiedad.hipotecar(self)
      end
      if result
        Diario.instance.ocurre_evento("El jugador " + @nombre + " hipoteca la propiedad " + @propiedades.at(ip))
      end
      result
    end

    def modificar_saldo (cantidad)
      @saldo += cantidad
      texto = "Se ha incrementado el saldo del jugador " + @nombre 
      Diario.instance.ocurre_evento(texto)
      true
    end
    
    def mover_a_casilla(numCasilla)
        if @encarcelado
            devuelve = true;
        else
            @numCasillaActual = numCasilla;
            @puedeComprar = true; #debería ser falso
            texto = "Se ha movido el Jugador " +  @nombre + " a la casilla.";
            Diario.instance.ocurre_evento(texto);
            devuelve = true;
        end
        devuelve 
    end
    
    def obtener_salvoconducto (s)
      if !is_encarcelado
        devuelve = true
        @salvoconducto = s
      else
        devuelve = false
      end
      devuelve
    end
    
    def paga (cantidad)
      num = cantidad * -1
      modificar_saldo(num)
    end
    
    def paga_alquiler(cantidad)
      if @encarcelado
        dev = false
      else 
        dev = paga(cantidad)
      end
      dev
    end
    
    def paga_impuestos (cantidad)
      if @encarcelado
        dev = false
      else 
        dev = paga(cantidad)
      end
      dev
    end
    
    def pasa_por_salida
      modificar_saldo(@@PasoPorSalida)
      texto = "El jugador" + self.nombre + "ha pasado por la salida. Y su saldo se ha visto incrementado. Ahora tiene un saldo de" + @saldo
      Diario.instance.ocurre_evento(texto)
      true
    end
    
    #se añade casilla para poder comprobar que la casilla se puede comprar
    def puede_comprar_casilla #HE MODIFICADO DEVUELVE POR PUEDECOMPRAR
      if @encarcelado
        @puedeComprar = false
      else 
        @puedeComprar = true
      end
      @puedeComprar
    end
    
    def recibe (cantidad) 
      if @encarcelado
        dev = false
      else 
        dev = modificar_saldo(cantidad)
      end
      dev  
    end
    
    def salir_carcel_pagando
      if @encarcelado && puede_salir_carcel_pagando
        paga(@@PrecioLibertad)
        @encarcelado = false;
        texto = "El jugador " + self.nombre + " ya no esta encarcelado. Ha salido de la clase pagando."
        Diario.instance.ocurre_evento(texto)
        dev = true
      else
        dev = false
      end
      dev
    end
    
    def salir_carcel_tirando
      if Dado.instance.salgo_de_la_carcel && @encarcelado
        @encarcelado = false
        dev = true
        texto = "El jugador " + self.nombre + " ha salido de la carcel tirando."
        Diario.instance.ocurre_evento(texto)
      else
        dev = false
      end
      dev
    end
    
    def tiene_algo_que_gestionar
      @propiedades != nil
    end
    
    def tiene_salvoconducto
      @salvoconducto != nil
    end
    
    def vender (ip)
      devuelve = false
      if !@encarcelado
        if existe_la_propiedad(ip)
          if @propiedades[ip].vender(self)
            Diario.instance.ocurre_evento('El jugador ' + @nombre + ' ha vendido la propiedad.')
            devuelve = true
            @propiedades.delete_at(ip)
          end
        end
      end
      devuelve
    end
    
  private
    def existe_la_propiedad (ip)
      dev = false;
      for i in @propiedades
        if i ==  @propiedades[ip]
          dev = true
        end
      end
      dev
    end
    
    def perder_salvoconducto
      @salvoconducto.usada
      @salvoconducto = nil
    end
    
    def puede_salir_carcel_pagando
      @saldo >= @@PrecioLibertad
    end
    
    def puedo_edificar_casa (propiedad)
      if puedo_gastar(propiedad.precioEdificar) && propiedad.numCasas < @@CasasMax
        dev = true
      else
        dev = false
      end
      dev
    end
    
    def puedo_edificar_hotel(propiedad)
      if  puedo_gastar(propiedad.precioEdificar) && propiedad.numCasas < @@CasasMax && propiedad.numCasas >= @@CasasPorHotel
        dev = true
      else
        dev = false
      end
      dev
    end
    
    def puedo_gastar (precio)
      dev = false
      if !@encarcelado and @saldo >= precio
        dev = true;
      end
      dev   
    end
    
    def CasasMax
      @CasasMax
    end
   
    def HotelesMax
      @HotelesMax
    end
      
  end
end

