Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

require 'looksee'
Looksee.editor = 'vim %f +%l'

require 'hirb'

# load Rails config if running as a Rails console
load File.dirname(__FILE__) + '/.railsrc' if defined?(Rails) && Rails.env
