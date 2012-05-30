module Shoes
  class Check
    def gui_init_open app
      @real = Swt::Widgets::Button.new app.shell, Swt::SWT::CHECK
    end
    attr_accessor :real
  end
end

