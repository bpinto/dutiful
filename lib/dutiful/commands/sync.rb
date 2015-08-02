class Dutiful::Command::Sync < Clamp::Command
  option ['-v', '--verbose'], :flag, 'Verbose mode'

  def execute
    puts "Storage: #{Dutiful::Config.storage.name}\n\n"

    Dutiful::Application.each do |application|
      puts "#{application.name}:\n" if application.should_sync? || verbose?

      application.sync do |file, result|
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
