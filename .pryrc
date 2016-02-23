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

begin
  require 'looksee'
rescue LoadError
end
Looksee.editor = 'vim %f +%l' if defined? Looksee

# Hirb ------------------------------------------------------------------------

begin
  require 'hirb'
rescue LoadError
end
if defined? Hirb
  # from https://github.com/pry/pry/wiki/FAQ#how-can-i-use-the-hirb-gem-with-pry
  # Slightly dirty hack to fully support in-session Hirb.disable/enable toggling
  Hirb::View.instance_eval do
    def enable_output_method
      @output_method = true
      @old_print = Pry.config.print
      Pry.config.print = proc do |*args|
        Hirb::View.view_or_page_output(args[1]) || @old_print.call(*args)
      end
    end

    def disable_output_method
      Pry.config.print = @old_print
      @output_method = nil
    end
  end

  Hirb.enable
end

# Rails -----------------------------------------------------------------------

# load Rails config if running as a Rails console
load File.dirname(__FILE__) + '/.railsrc' if defined? Rails && Rails.env
