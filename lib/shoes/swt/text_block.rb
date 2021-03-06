class Shoes
  module Swt
    class TextBlock
      include Common::Clear
      include Common::Toggle
      include Common::Clickable
      include ::Shoes::BackendDimensionsDelegations

      DEFAULT_SPACING = 4

      attr_reader :dsl, :app

      def initialize(dsl)
        @dsl = dsl
        @app = dsl.app.gui
        @opts = @dsl.opts
        @painter = TextBlockPainter.new @dsl
        @app.add_paint_listener @painter
      end

      def redraw
        app.redraw
      end

      def update_position
        redraw
      end

      def get_height
        text_layout, font = set_styles
        text_layout.width = @dsl.element_width
        text_layout.getBounds(0, @dsl.text.length - 1).height.tap{font.dispose}
      end

      def get_size
        text_layout, font = set_styles
        bounds = text_layout.getBounds(0, @dsl.text.length - 1)
        font.dispose
        return bounds.width, bounds.height
      end

      def set_styles
        text_layout = ::Swt::TextLayout.new Shoes.display
        text_layout.setText @dsl.text
        text_layout.setSpacing(@opts[:leading] || DEFAULT_SPACING)
        font = ::Swt::Font.new Shoes.display, @dsl.font, @dsl.font_size,
                               ::Swt::SWT::NORMAL
        style = ::Swt::TextStyle.new font, nil, nil
        text_layout.setStyle style, 0, @dsl.text.length - 1
        return text_layout, font
      end

      def clear
        super
        clear_links
      end

      def replace *values
        clear_links
        # TODO We should never use instance_variable_set rather an accessor
        @dsl.instance_variable_set :@text, values.map(&:to_s).join
        if @dsl.text.length > 1
          @dsl.element_width, @dsl.element_height = get_size
        end
        @dsl.update_text_styles(values)
        redraw
      end

      def contents
      end


      private

      def clear_links
        @dsl.links.each do |link|
          app.clickable_elements.delete link
          ln = link.click_listener
          app.remove_listener ::Swt::SWT::MouseDown, ln if ln
          app.remove_listener ::Swt::SWT::MouseUp, ln if ln
        end
        @dsl.links.clear
      end
    end

    class Banner < TextBlock; end
    class Title < TextBlock; end
    class Subtitle < TextBlock; end
    class Tagline < TextBlock; end
    class Caption < TextBlock; end
    class Para < TextBlock; end
    class Inscription < TextBlock; end
  end
end
