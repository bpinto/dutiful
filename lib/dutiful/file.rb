module Dutiful
  class File
    attr_reader :full_path, :path

    def initialize(path)
      @path      = path
      @full_path = ::File.expand_path "~/#{path}"
    end

    def exist?
      ::File.exist? @full_path
    end

    def synced?
      Dutiful::Command.storage.exist?(self) && Dutiful::Command.storage.synced?(self)
    end
  end
end
