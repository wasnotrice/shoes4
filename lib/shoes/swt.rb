require 'java'
require 'swt'

module Shoes
  include Swt
end

module Shoes
  module Swt
    module App; end
    module Check; end
  end
  class App; include Swt::App end
  class Check; include Swt::Check end
end

require 'shoes/swt/app'
require 'shoes/swt/check'
