module Civitas
  
  class Casilla
      attr_reader :nombre

      def initialize(nombre)
        @nombre = nombre      
      end

      def jugador_correcto(actual, todos)
        actual >= 0 && actual < todos.length()
      end
      
      def recibe_jugador(actual, todos)
        informe(actual, todos);
      end
    
      @Override
      def to_string
        "\n Nombre: " + @nombre.to_s + "\n Tipo Casilla: Descanso"
      end
         
      def informe( actual, todos )
        jugador = todos[actual]
        texto = "El jugador #{jugador.nombre} ha caido en la casilla #{@nombre}"
        Diario.instance.ocurre_evento(texto)
      end
      
      public :nombre

  end  
end