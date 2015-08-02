class Dutiful::ApplicationFile
  attr_reader :full_path, :path

  def initialize(path, condition)
    @command         = condition[:command] if condition
    @expected_output = condition[:expected_output] if condition
    @expected_status = condition[:expected_status] if condition
    @path            = path

    if directory?
      @full_path = "#{File.expand_path "~/#{path}"}/"
    else
      @full_path = File.expand_path "~/#{path}"
    end
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

  def meets_conditions?
    if has_condition?
      output = `#{@command}`

      if @expected_status
        $?.exitstatus == @expected_status
      else
        $?.success? && output.strip == @expected_output
      end
    else
      true
    end
  end

  def directory?
    path.chars.last == '/'
  end

  def exist?
    File.exist? full_path
  end

  def has_backup?
    Dutiful::Config.storage.exist? self
  end

  def has_condition?
    @command
  end

  def should_sync?
    (exist? || has_backup?) && meets_conditions?
  end

  def synced?
    has_backup? && Dutiful::Config.storage.synced?(self)
  end

  def to_s
    return "#{path} does not meet conditions (skipping)".yellow unless meets_conditions?

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
