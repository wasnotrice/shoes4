module Shoes
  module Swt
    class App
      def initialize
        @real = ::Swt::Widgets::Shell.new Swt.display
      end
      attr_reader :real
    end
  end
end

