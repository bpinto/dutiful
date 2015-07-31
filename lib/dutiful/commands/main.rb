class Dutiful::Command::Main < Clamp::Command
  option ['-v', '--version'], :flag, 'Show version' do
    puts "dutiful #{Dutiful::VERSION}"
    exit 0
  end

  subcommand 'sync', 'Sync all preference files', Dutiful::Command::Sync
  subcommand 'list', 'List all preference files', Dutiful::Command::List

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
end
