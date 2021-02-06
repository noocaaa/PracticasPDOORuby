module Civitas
  class OperacionInmobiliaria
    attr_reader :num_propiedad, :gestion

    def initialize(gest, ip) #DONEE
      @num_propiedad = ip
      @gestion = gest
    end
    
  end
end
