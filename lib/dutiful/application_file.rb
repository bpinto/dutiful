class Dutiful::ApplicationFile
  attr_reader :path

  def initialize(path, condition)
    @condition, @path = condition, path
  end

  def backup
    Dutiful::Config.storage.backup self
  end

  def restore
    Dutiful::Config.storage.restore self
  end

  def backup_path
    Dutiful::Config.storage.path path
  end

  def backup_timestamp
    File.mtime backup_path if has_backup?
  end

  def command
    @condition[:command] if has_condition?
  end

  def expected_output
    @condition[:expected_output] if has_condition?
  end

  def expected_status
    @condition[:expected_status] if has_condition?
  end

  def full_path
    if directory?
      "#{File.expand_path "~/#{path}"}/"
    else
      File.expand_path "~/#{path}"
    end
  end

  def name
    path
  end

  def timestamp
    File.mtime full_path if exist?
  end

  def directory?
    path.chars.last == '/'
  end

  def exist?
    File.exist?(full_path) && meets_conditions?
  end

  def has_backup?
    Dutiful::Config.storage.exist?(self) && meets_conditions?
  end

  def has_condition?
    @condition
  end

  def meets_conditions?
    if has_condition?
      output = `#{command}`

      if expected_status
        $?.exitstatus == expected_status
      else
        $?.success? && output.strip == expected_output
      end
    else
      true
    end
  end

  def tracked?
    exist? || has_backup?
  end

  def in_sync?
    has_backup? && Dutiful::Config.storage.in_sync?(self)
  end

  def to_s
    return "#{path} does not meet conditions (skipping)".yellow unless meets_conditions?

    if exist?
      if has_backup?
        if in_sync?
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
