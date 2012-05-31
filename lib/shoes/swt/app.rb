class Shoes::Swt::App
  def initialize(display)
    @shell = Swt::Widgets::Shell.new display
  end
    
  attr_reader :shell
    
  def open
    # bla bla bla
  end
end
