class Dutiful::Command::List < Clamp::Command
  option ['-v', '--verbose'], :flag, 'Verbose mode'

  def execute
    Dutiful::Logger.set false, verbose?
    Dutiful::Logger.info "Storage: #{Dutiful::Config.storage.name}\n\n"

    Dutiful::Application.each do |application|
      Dutiful::Logger.info "#{application.name}:\n" if application.should_sync? || verbose?

      application.files.map do |file|
        Dutiful::Logger.info "  #{file}" if file.should_sync? || verbose?
      end.compact.join("\n")
    end
  end
end
