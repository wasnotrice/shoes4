module Shoes
  def self.app &blk
    App.new.tap do |s|
      s.instance_eval &blk
    end
  end
  
  class App
    def initialize
      @shell = Shoes.backend::App.new
    end

    attr_reader :shell

    def check
      Shoes::Check.new self
    end
  end
end
