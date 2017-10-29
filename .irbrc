require 'rubygems'

# Awesome Print ----------------------------------------------------------------------------

begin
  require 'awesome_print'
rescue LoadError
else
  AwesomePrint.irb!
end

# Pry --------------------------------------------------------------------------------------

begin
  require 'pry'
rescue LoadError
else
  Pry.start
  exit
end
