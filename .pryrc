# Pry configuration

Pry.prompt = [
  proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " },
  proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " },
]

# from https://github.com/pry/pry/wiki/FAQ#how-do-i-stop-executing-a-bindingpry-call-in-a-loop
Pry::Commands.block_command('enable-pry', 'Enable `binding.pry` feature') do
  ENV['DISABLE_PRY'] = nil
end

# Looksee ---------------------------------------------------------------------

require 'looksee'
Looksee.editor = 'vim %f +%l'

# Hirb ------------------------------------------------------------------------

require 'hirb'

# Rails -----------------------------------------------------------------------

# load Rails config if running as a Rails console
load File.dirname(__FILE__) + '/.railsrc' if defined? Rails && Rails.env
