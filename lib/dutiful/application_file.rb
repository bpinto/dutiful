class Dutiful::ApplicationFile
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
      if has_backup?
        if synced?
          "#{path} ✔".green
        else
          "#{path} (modified)".yellow
        end
      else
        "#{path} (pending backup)".yellow
      end
    elsif has_backup?
      "#{path} (pending restore)".yellow
    else
      "#{path} does not exist (skipping)".yellow
    end
  end
end
