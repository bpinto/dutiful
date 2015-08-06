class Dutiful::Command::Main < Clamp::Command
  option ['-v', '--version'], :flag, 'Show version' do
    Dutiful::Logger.info "dutiful #{Dutiful::VERSION}"
    exit 0
  end

  option ['--init'], :flag, 'Initialize your computer with dutiful.' do
    if File.exist? Dutiful::Config::PATH
      Dutiful::Logger.warning "Configuration file already exist: '~/.dutiful/config.toml'."
      exit 1
    end

    FileUtils.mkdir_p Dutiful.dir
    FileUtils.cp File.expand_path("#{Dutiful.dir}/template/config.toml"), Dutiful::Config::PATH

    Dutiful::Logger.success "Configuration file successfully created: '~/.dutiful/config.toml'."
    exit 0
  end

  subcommand 'backup',  'Backup all preference files',  Dutiful::Command::Backup
  subcommand 'list',    'List all preference files',    Dutiful::Command::List
  subcommand 'restore', 'Restore all preference files', Dutiful::Command::Restore
end
