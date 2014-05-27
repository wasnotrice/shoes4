class Shoes
  module Common
    # Style methods.
    module Style 

      DEFAULT_STYLES = {
        fill:        Shoes::COLORS[:black],
        stroke:      Shoes::COLORS[:black],
        strokewidth: 1 
      }

      STYLE_GROUPS = {
        art_styles:    [:cap, :click, :fill, :stroke, :strokewidth],
        common_styles: [:displace_left, :displace_top, :hidden],
        dimensions:    [:bottom, :height, :left, :margin, 
                        :margin_bottom, :margin_left, :margin_right, 
                        :margin_top, :right, :top, :width],
        text_styles:   [:align, :click, :emphasis, :family, :fill, :font, 
                        :justify, :kerning, :leading, :rise, :size, :stretch, 
                        :strikecolor, :strikethrough, :stroke, :undercolor, 
                        :underline, :weight, :wrap],
        others:        [:angle1, :angle2, :center, :radius, :wedge]
      }

      # Adds styles, or just returns current style if no argument
      def style(new_styles = nil)
        update_style(new_styles) if need_to_update_style?(new_styles)
        update_dimensions if styles_with_dimensions?
        @style
      end 

      def style_init(arg_styles, new_styles = {})

        default_element_styles = {}
        default_element_styles = self.class::STYLES if defined? self.class::STYLES

        @style = @app.style.merge(default_element_styles)
        @style.merge!(@app.element_styles[self.class]) if @app.element_styles[self.class]
        @style.merge!(new_styles)
        @style.merge!(arg_styles)
      end

      module StyleWith
        def style_with(*styles)
          @supported_styles = []

          unpack_style_groups(styles)
          define_accessor_methods
        end

        def supported_styles
          @supported_styles
        end
        
        def unpack_style_groups(styles)
          styles.each do |style|
            if STYLE_GROUPS[style]
              STYLE_GROUPS[style].each{|style| @supported_styles << style}
            else
              @supported_styles << style
            end
          end
        end

        def define_accessor_methods

          needs_accessors = @supported_styles.reject do |style|
            self.method_defined?(style)
          end

          #define accessors for styles that need them
          needs_accessors.map(&:to_sym).each do |style|

            define_method style do
              @style[style]
            end

            define_method "#{style}=" do |new_style|
              @style[style] = new_style
            end

          end
        end
      end

      def self.included(klass)
        klass.extend StyleWith
      end

      private

      def update_style(new_styles)
        normalized_style = StyleNormalizer.new.normalize(new_styles)
        set_dimensions(new_styles)
        @style.merge! normalized_style
      end
      
      #if dimension is set via style, pass info on to the dimensions setter
      def set_dimensions(new_styles)
        new_styles.each do |key, value|
          self.send(key.to_s+"=", value) if STYLE_GROUPS[:dimensions].include?(key)
        end
      end

      def update_dimensions #so that @style hash matches actual values
        STYLE_GROUPS[:dimensions].each do |style|
          @style[style] = self.send(style.to_s)
        end
      end

      def styles_with_dimensions?
        STYLE_GROUPS[:dimensions].any? {|dimension| @style.has_key? dimension}
      end

      def need_to_update_style?(new_styles)
        new_styles && style_changed?(new_styles)
      end

      # check necessary because update_style triggers a redraw in the redrawing
      # aspect and we want to avoid unnecessary redraws
      def style_changed?(new_styles)
        new_styles.each_pair.any? do |key, value|
          @style[key] != value
        end
      end

    end
  end
end
