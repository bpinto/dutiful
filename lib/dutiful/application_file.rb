module Dutiful
  class ApplicationFile
    attr_reader :full_path, :path

    def initialize(path)
      @path      = path
      @full_path = File.expand_path "~/#{path}"
    end

    def backup_path
      Dutiful::Config.storage.path path
    end

    def backup_timestamp
      File.mtime backup_path if has_backup?
    end

    def timestamp
      File.mtime full_path if exist?
    end

    def exist?
      File.exist? full_path
    end

    def has_backup?
      Dutiful::Config.storage.exist? self
    end

    def synced?
      has_backup? && Dutiful::Config.storage.synced?(self)
    end

    def to_s
      if exist?
        return "#{path} ✔".green if synced?

        if has_backup?
          return "#{path} (modified)".yellow
        else
          return "#{path} (pending backup)".yellow
        end
      end

      "#{path} (pending restore)".yellow if has_backup?
    end
  end
end
