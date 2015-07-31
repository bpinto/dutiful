module Dutiful
  class Application
    def initialize(path)
      @path = path
    end

    def name
      content[:application][:name]
    end

    def files
      content[:files].map { |file| ApplicationFile.new file[:path] }
    end

    def exist?
      files.any? &:exist?
    end

    def sync
      files.each do |file|
        if file.exist? || file.has_backup?
          result = Dutiful::Config.storage.sync(file)
          yield file, result if block_given?
        else
          yield file if block_given?
        end
      end
    end

    def to_s
      output = "#{name}:\n"

      output << files.map do |file|
        "  #{file}" if file.exist? || file.has_backup?
      end.compact.join("\n")
    end

    def self.all
      Dir['db/*.toml'].map do |filename|
        Dutiful::Application.new filename
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
