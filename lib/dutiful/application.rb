module Dutiful
  class Application
    def initialize(path)
      @path = path
    end

    def name
      content[:application][:name]
    end

    def files
      content[:files].map { |file| File.new file[:path] }
    end

    def exist?
      files.any? &:exist?
    end

    def sync
      files.each do |file|
        if file.exist?
          result = Dutiful::Config.storage.sync(file) if file.exist?
          yield file, result
        else
          yield file
        end
      end
    end

    def to_s
      output = "#{name}:\n"

      files.each_with_index do |file, index|
        next unless file.exist?

        if file.synced?
          output << "  #{file.path} ✔".green
        else
          output << "  #{file.path} (pending)".yellow
        end

        output << "\n" if index < files.count
      end

      output
    end

    def self.all
      Dir.foreach('db').map do |filename|
        next if filename == '.' or filename == '..'

        application = Dutiful::Application.new "db/#{filename}"
        application if application.exist?
      end.compact
    end

    def self.each
      return enum_for(:each) unless block_given?

      all.each { |application| yield application }
    end

    private

    def content
      @content ||= Tomlrb.load_file(@path, symbolize_keys: true)
    end
  end
end
