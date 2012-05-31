module Shoes
  class Check
    def initialize app
      @gui = Shoes.backend::Check.new(app)
    end
    attr_reader :gui

    def real
      @gui.real
    end
  end
end

