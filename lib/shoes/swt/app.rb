module Shoes
  class App
    def initialize
      @shell = Swt::Shell.new Swt::Display.new
    end
    attr_reader :shell
  end
end

