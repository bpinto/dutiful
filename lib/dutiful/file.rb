module Dutiful
  class File
    attr_reader :full_path, :path

    def initialize(path)
      @path      = path
      @full_path = ::File.expand_path "~/#{path}"
    end

    def exists?
      ::File.exists? @full_path
    end

    def synced?
      Dutiful::Runner.storage.exists?(self) && Dutiful::Runner.storage.synced?(self)
    end
  end
end
