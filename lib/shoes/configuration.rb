module Shoes
  class << self
    attr_reader :backend
    def backend=(name)
      require "shoes/#{name.downcase}"
      @backend = eval "Shoes::#{name.to_s.capitalize}"
    end
  end
end