module Shoes
  class Check
    def initialize app
      @real = Swt::Button.new app.shell, Swt::SWT::CHECK
    end
    attr_accessor :real
  end
end

