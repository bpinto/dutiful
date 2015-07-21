require 'clamp'

class Dutiful::Command < Clamp::Command
  option ['-v', '--version'], :flag, 'Show version' do
    puts "dutiful #{Dutiful::VERSION}"
    exit 0
  end

  subcommand 'backup', 'Backup all preference files' do
    def execute
      puts "Storage: #{Dutiful::Command.storage.name}"
      puts

      Dutiful::Command.storage.create_dir

      Dutiful::Application.each do |application|
        puts "#{application.name}:\n"

        application.files.each do |file|
          print "  #{file.path}"
          result = Dutiful::Command.storage.sync(file)

          if result.success?
            puts " ✔"
          else
            puts " ✖ - #{result.error}"
          end
        end
      end
    end
  end

  subcommand 'list', 'List all preference files' do
    def execute
      puts "Storage: #{Dutiful::Command.storage.name}"
      puts

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
