class Shoes::Swt::Check
  def initialize(app)
    @real = Swt::Widgets::Button.new app.gui.shell, Swt::SWT::CHECK
  end
  attr_accessor :real
end

