module Shoes
  class << self
    attr_reader :backend
    def backend=(name)
      require "shoes/#{name.downcase}"
      backends = {
        :SWT => Shoes::Swt
      }
      @backend = backends.fetch(name)
    end
  end
end
