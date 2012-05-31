module Shoes
  def self.app &blk
    App.new &blk
  end
  
  class App
    include Shoes::ElementMethods
    
    def initialize &blk
      @gui = Shoes.backend::App.new(Swt.display)
      instance_eval &blk
      @gui.open
    end
    attr_reader :gui
  end
end
