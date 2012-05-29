module Shoes
  class << self
    attr_reader :backend
    def backend=(name)
      @backend = name
      require "shoes/#{name.downcase}"
    end
  end
end