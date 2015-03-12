require 'thor'
require 'hidden_hippo/cli/database'
require 'hidden_hippo/cli/gui'

module HiddenHippo
  module Cli
    class App < Thor
      desc 'db start|stop|status', 'control the database service'
      subcommand 'db', Database

      desc 'gui start|stop|status', 'control the gui service'
      subcommand 'gui', Gui
    end
  end
end