module Shoes
  def self.app &blk
    App.new &blk
  end
  
  class App
    include ElementMethods
    
    def initialize &blk
      gui_init
      instance_eval &blk
      gui_open
    end
  end
end
