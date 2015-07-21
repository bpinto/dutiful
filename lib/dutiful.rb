require 'dutiful/application'
require 'dutiful/file'
require 'dutiful/version'
require 'dutiful/storages'
require 'optparse'
require 'rsync'
require 'tomlrb'

module Dutiful
  class Runner
    def self.parse_command(options)
      ARGV << '-h' if ARGV.empty?

      OptionParser.new do |opts|
        opts.banner = 'Usage: dutiful <command> [<options>]'

        opts.on('-b', '--backup', 'Backup all preference files') do
          puts "Storage: #{storage.name}"
          puts

          storage.create_dir

          Dutiful::Application.each do |application|
            puts "#{application.name}:\n"

            application.files.each do |file|
              print "  #{file.path}"
              result = storage.sync(file)

              if result.success?
                puts " ✔"
              else
                puts " ✖ - #{result.error}"
              end
            end
          end
        end

        opts.on('-l', '--list', 'List all preference files') do
          puts "Storage: #{storage.name}"
          puts

          puts Dutiful::Application.all
        end

        opts.on('-r', '--restore', 'Restore all preference files') do
          puts 'Restoring all preference files...'
        end

        opts.on('-w', '--which', 'Display the full path to a preference file') do
          puts 'Displaying preference file path...'
        end

        opts.on_tail('-h', '--help', 'Prints this help') do
          puts opts
          exit
        end

        opts.on_tail('-v', '--version', 'Show version') do
          puts VERSION
          exit
        end
      end.parse!
    end

    def self.storage
      @storage ||= if Dutiful::Storage::Icloud.available?
                     Dutiful::Storage::Icloud
                   end
    end
  end
end
