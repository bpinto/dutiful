require 'clamp'

class Dutiful::Command < Clamp::Command
  option ['-v', '--version'], :flag, 'Show version' do
    puts "dutiful #{Dutiful::VERSION}"
    exit 0
  end

  subcommand 'backup', 'Backup all preference files' do
    option ['-v', '--verbose'], :flag, 'Verbose mode'

    def execute
      puts "Storage: #{Dutiful::Command.storage.name}\n\n"

      Dutiful::Application.each do |application|
        puts "#{application.name}:\n"

        application.sync do |file, result|
          if result
            if result.success?
              puts "  #{file.path} ✔".green
            else
              puts "  #{file.path} ✖ - #{result.error}".red
            end
          else
            puts "  #{file.path} does not exist (skipping)".yellow if verbose?
          end
        end
      end
    end
  end

  subcommand 'list', 'List all preference files' do
    def execute
      puts "Storage: #{Dutiful::Command.storage.name}\n\n"

      puts Dutiful::Application.all
    end
  end

  subcommand 'restore', 'Restore all preference files' do
    def execute
      puts 'Not implemented yet'
    end
  end

  subcommand 'which', 'Display the full path to a preference file' do
    def execute
      puts 'Not implemented yet'
    end
  end

  def self.storage
    @storage ||= if Dutiful::Storage::Icloud.available?
                   Dutiful::Storage::Icloud
                 end
  end
end
