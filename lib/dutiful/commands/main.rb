class Dutiful::Command::Main < Clamp::Command
  option ['-v', '--version'], :flag, 'Show version' do
    puts "dutiful #{Dutiful::VERSION}"
    exit 0
  end

  subcommand 'backup',  'Backup all preference files',  Dutiful::Command::Backup
  subcommand 'list',    'List all preference files',    Dutiful::Command::List
  subcommand 'restore', 'Restore all preference files', Dutiful::Command::Restore
  subcommand 'sync',    'Sync all preference files',    Dutiful::Command::Sync
end
