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

    def exists?
      files.any? &:exists?
    end

    def to_s
      output = "#{name}:\n"

      files.each do |file|
        next unless file.exists?

        if file.synced?
          output << "  #{file.path} ✔"
        else
          output << "  #{file.path} ✖"
        end
      end

      output
    end

    def self.all
      Dir.foreach('db').map do |filename|
        next if filename == '.' or filename == '..'

        application = Dutiful::Application.new "db/#{filename}"
        application if application.exists?
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
