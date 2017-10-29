require 'rubygems'

# Pry --------------------------------------------------------------------------------------

begin
  require 'pry'
rescue LoadError
else
  Pry.start
  exit
end
