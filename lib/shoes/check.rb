module Shoes
  class Check
    def initialize app
      @real = Shoes.backend::Check.new(app)
    end
    attr_reader :real
  end
end
