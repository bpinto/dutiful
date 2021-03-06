class Dutiful::Command::Main < Clamp::Command
  option ['-v', '--version'], :flag, 'Show version' do
    Dutiful::Logger.info "dutiful #{Dutiful::VERSION}"
    exit 0
  end

  subcommand 'backup',  'Backup all preference files', Dutiful::Command::Backup
  subcommand 'init',    'Initialize the configuration file', Dutiful::Command::Init
  subcommand 'list',    'List all preference files', Dutiful::Command::List
  subcommand 'restore', 'Restore all preference files', Dutiful::Command::Restore
end
