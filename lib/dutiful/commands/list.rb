class Dutiful::Command::List < Clamp::Command
  option ['-v', '--verbose'], :flag, 'Verbose mode'

  def execute
    puts "Storage: #{Dutiful::Config.storage.name}\n\n"

    Dutiful::Application.each do |application|
      puts "#{application.name}:\n" if application.should_sync? || verbose?

      application.files.map do |file|
        puts "  #{file}" if (file.should_sync?) || verbose?
      end.compact.join("\n")
    end
  end
end
