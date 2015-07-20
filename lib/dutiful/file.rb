module Dutiful
  class File
    attr_reader :path

    def initialize(path)
      @path      = path
      @full_path = ::File.expand_path "~/#{path}"
    end

    def exists?
      ::File.exists? @full_path
    end

    def synced?
      exists?
    end
  end
end
