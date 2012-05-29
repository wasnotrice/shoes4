call jruby --1.9 -e "$:<< 'lib'; require 'shoes'; Shoes.backend = :SWT; require '%1' "
