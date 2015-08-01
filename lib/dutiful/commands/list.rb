class Dutiful::Command::List < Clamp::Command
  option ['-v', '--verbose'], :flag, 'Verbose mode'

  def execute
    puts "Storage: #{Dutiful::Config.storage.name}\n\n"

    Dutiful::Application.each do |application|
      puts "#{application.name}:\n" if application.exist? || application.has_backup? || verbose?

      application.files.map do |file|
        puts "  #{file}" if file.exist? || file.has_backup? || verbose?
      end.compact.join("\n")
    end
  end
end
