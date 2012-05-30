module Shoes
  module ElementMethods
    def check
      Shoes::Check.new self
    end
  end
end


