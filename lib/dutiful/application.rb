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

    private

    def content
      @content ||= Tomlrb.load_file(@path, symbolize_keys: true)
    end
  end
end
