class Dutiful::Command::List < Clamp::Command
  def execute
    puts "Storage: #{Dutiful::Config.storage.name}\n\n"

    puts Dutiful::Application.all
  end
end
