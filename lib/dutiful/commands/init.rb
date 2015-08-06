class Dutiful::Command::Init < Clamp::Command
  def execute
    if File.exist? Dutiful::Config::PATH
      Dutiful::Logger.warning "Configuration file already exist: '~/.dutiful/config.toml'."
      exit 1
    end

    FileUtils.mkdir_p Dutiful.dir
    FileUtils.cp File.expand_path("#{Dutiful.dir}/template/config.toml"), Dutiful::Config::PATH

    Dutiful::Logger.success "Configuration file successfully created: '~/.dutiful/config.toml'."
  end
end
