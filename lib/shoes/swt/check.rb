module Shoes
  module Swt
    class Check
      def initialize app
        @real = ::Swt::Widgets::Button.new app.shell.real, ::Swt::SWT::CHECK
      end
      attr_accessor :real
    end
  end
end

