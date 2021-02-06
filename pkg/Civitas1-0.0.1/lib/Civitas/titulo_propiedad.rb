# encoding:utf-8

module Civitas
  class TituloPropiedad

    attr_reader :hipotecado, :nombre, :numCasas, :numHoteles, :precioCompra, :precioEdificar, :propietario

    public

      def initialize( nom, ab, fr, hb, pc, pe )
        @@factorInteresesHipoteca = 1.1
        @nombre = nom
        @alquilerBase = ab;
        @factorRevalorizacion = fr;
        @hipotecaBase = hb;
        @precioCompra = pc;
        @precioEdificar = pe;
        @hipotecado = false;
        @numCasas = @numHoteles = 0; 
        @propietario = nil;
      end

      def cancelar_hipoteca( jugador )
        result = false
        if (get_hipotecado)
          if (es_este_el_propietario(jugador))
            jugador.paga(get_importe_cancelar_hipoteca)
            @hipotecado = false
            result = true
          end
        end
        result
      end
      
      def cantidad_casas_hoteles
        (@numCasas + @numHoteles)
      end

      def comprar(jugador)
        res = false
        if !tiene_propietario
          @propietario = jugador
          @propietario.paga(@precioCompra)
          res = true
        end
        res
      end

      def construir_casa( jugador )
        res = false
        if es_este_el_propietario(jugador) and @numCasas <= 4
          jugador.paga(@precioEdificar)
          @numCasas += 1
          res = true
        end
        res
      end

      def construir_hotel( jugador )
        res = false
        if es_este_el_propietario(jugador) and @numCasas >=4 and @numHoteles <=4
          @propietario.paga(@precioEdificar)
          @numHoteles += 1
          res = true
        end
        res
      end

      def derruir_casas( n, jugador )
        if es_este_el_propietario(jugador) && @numCasas >= n
            @numCasas = @numCasas - n;
            estado = true;
        else
            estado = false;
        end
        estado;
      end

      def get_importe_cancelar_hipoteca
        get_importe_hipoteca*@@factorInteresesHipoteca
      end

      def hipotecar( jugador )
        salida = false
        if (!@hipotecado && es_este_el_propietario(jugador))
          @propietario.recibe(get_importe_hipoteca)
          @hipotecado = true
          salida = true;
        end
        salida       
      end

      def tiene_propietario
        @propietario ? true : false
      end

      def tramitar_alquiler(jugador)
        
        if tiene_propietario && !es_este_el_propietario(jugador)
          jugador.paga_alquiler(get_precio_alquiler)
          @propietario.recibe(get_precio_alquiler)
        end
      end

      def vender( jugador )
        if es_este_el_propietario(jugador) && !hipotecado
            @propietario.recibe(get_precio_venta)
            @propietario.propiedades.delete(self)
            @propietario = nil
            @numCasas = 0
            @numHoteles = 0
            estado = true
        else
            estado = false
        end
        estado
      end
      
      def actualiza_propietario_por_conversion(jugador)
        @propietario = jugador
        Diario.instance.ocurre_evento("El propietario ha cedido la propiedad a otro jugador")
      end
      
      @Override
      def to_string
        return "\n Las caracteristicas del titulo de Propiedad son las siguientes: \n\n" +
        " Nombre: " + @nombre + 
        "\n Alquiler Base: " + @alquilerBase.to_s +
        "\n Factor Revalorizacion: " + @factorRevalorizacion.to_s +
        "\n Hipoteca Base: " + @hipotecaBase.to_s + 
        "\n Precio Compra: " + @precioCompra.to_s +
        "\n Precio Edificar: " + @precioEdificar.to_s +
        "\n Hipotecado: " + @hipotecado.to_s + 
        "\n Numero Casas: " + @numCasas.to_s +
        "\n Numero Hoteles: " + @numHoteles.to_s +
        "\n Propietario: " + @propietario.nombre.to_s
      end
      
      
    private
      def es_este_el_propietario(jugador)
        estado = false
        if tiene_propietario
          if @propietario.to_s == jugador.to_s #deberia ser @propietario == jugador, pero por alguna razon peta por la memoria dada.
            estado = true
          end
        end
        
        
        estado
      end

      def get_importe_hipoteca
        @hipotecaBase * (1 + (@num_casas * 0.5) + (@num_hoteles*2.5))
      end

      def get_precio_alquiler
        precioalq = @alquilerBase*(1+(@numCasas*0.5)+(@numHoteles*2.5))
          if @hipotecado || propietario_encarcelado
            precioalq = 0;
          end
        precioalq      
      end

      def get_precio_venta
        @precioCompra + @precioEdificar*@factorRevalorizacion*(@numCasas + 5*@numHoteles)
      end

      def propietario_encarcelado
        @propietario.encarcelado
      end  
      
      public :nombre
  end
end

 
  