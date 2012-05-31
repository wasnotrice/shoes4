require 'java'
#require 'swing'

module Shoes
  #include Swing
end

module Shoes
  module Swing
    module App; end
    module Check; end
  end
  class App; include Swing::App end
  class Check; include Swing::Check end
end

require 'shoes/swing/app'
require 'shoes/swing/check'
