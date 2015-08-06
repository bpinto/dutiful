class Dutiful::Command::Restore < Clamp::Command
  option ['-q', '--quiet'], :flag, 'Quiet mode'
  option ['-v', '--verbose'], :flag, 'Verbose mode'

  def execute
    Dutiful::Logger.set quiet?, verbose?
    Dutiful::Logger.info "Storage: #{Dutiful::Config.storage.name}\n\n"

    Dutiful::Application.each do |application|
      Dutiful::Logger.info "#{application.name}:\n" if application.should_sync? && application.has_backup? || verbose?

      application.restore do |file, result|
        if result
          if result.success?
            Dutiful::Logger.success "  #{file.name} ✔"
          else
            Dutiful::Logger.error "  #{file.name} ✖ - #{result.error}"
          end
        elsif verbose?
          Dutiful::Logger.info "  #{file}"
        end
      end
    end
  end
end
