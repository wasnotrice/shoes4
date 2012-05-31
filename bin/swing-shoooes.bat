call jruby --1.9 -e "$:<< 'lib'; require 'shoes'; Shoes.backend = :Swing; require '%1' "
