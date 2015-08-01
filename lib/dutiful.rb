module Dutiful
  def self.dir
    File.dirname(__dir__)
  end
end

require 'dutiful/application'
require 'dutiful/application_file'
require 'dutiful/commands'
require 'dutiful/config'
require 'dutiful/storage'
require 'colorize'
require 'rsync'
require 'tomlrb'
