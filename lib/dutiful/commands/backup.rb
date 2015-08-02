class Dutiful::Command::Backup < Clamp::Command
  option ['-v', '--verbose'], :flag, 'Verbose mode'

  def execute
    puts "Storage: #{Dutiful::Config.storage.name}\n\n"

    Dutiful::Application.each do |application|
      puts "#{application.name}:\n" if application.should_sync? && application.exist? || verbose?

      application.backup do |file, result|
        if result
          if result.success?
            puts "  #{file.path} ✔".green
          else
            puts "  #{file.path} ✖ - #{result.error}".red
          end
        elsif verbose?
          puts "  #{file}"
        end
      end
    end
  end
end
