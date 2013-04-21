module Shoes
  module Mock
    module CommonMethods
      def initialize(dsl, *args)
      end

      def move(left, top)
        @left, @top = left, top
      end

      def toggle()
        @hidden = !@hidden
      end
    end
  end
end
