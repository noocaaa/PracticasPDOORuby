require_relative "sorpresa"
require_relative "sorpresa_pagarcobrar"

module Civitas
  class SorpresaPORJUGADOR < Sorpresa
    def initialize (valor, texto)
      super(valor, texto)
    end
    
    @Override
    def aplicar_a_jugador(actual, todos) #DONEE
      jugador = todos[actual];
      if jugador_correcto(actual, todos)
        informe(actual, todos)

        sorpresa1 = SorpresaPagarcobrar.new(tip, @valor*-1, "Cobra")
        sorpresa2 = SorpresaPagarcobrar.new(tip, @valor*(todos.length-1), "Paga")

        #el for
        i=0
        loop do
          if i < todos.length()
            if i != actual
              sorpresa1.aplicar_a_jugador(i, todos)
            else
              sorpresa2.aplicar_a_jugador(i, todos)
            end
          end
          i += 1
        end
      end      
    end
    
    @Override 
    def to_string
      "\n Tipo Sorpresa: PORJUGADOR" + "\n Sorpresa: " + super.texto.to_s + "\n Valor: " + super.valor.to_s
    end
    
  end
end