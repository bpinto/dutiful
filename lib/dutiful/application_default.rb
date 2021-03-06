class Dutiful::ApplicationDefault
  Result = Struct.new(:error, :success?)

  def initialize(hash)
    @description = hash[:description]
    @domain      = hash[:domain]
    @key         = hash[:key]
    @type        = hash[:type]
  end

  def backup
    FileUtils.mkdir_p File.dirname "#{backup_path}"
    File.open(backup_path, 'w') { |file| file << value }

    Result.new nil, true
  rescue => ex
    Result.new ex.message, false
  end

  def backup_value
    File.read(backup_path)
  end

  def parsed_backup_value
    case @type
    when '-bool'
      backup_value == '1' ? true : false
    else
      backup_value
    end
  end

  def restore
    `defaults write #{@domain} #{@key} #{@type} #{parsed_backup_value}`
    Result.new nil, true
  rescue => ex
    Result.new ex.message, false
  end

  def name
    @key
  end

  def value
    @value ||= `defaults read #{@domain} #{@key} 2>/dev/null`.strip
  end

  def exist?
    @exists ||= begin
                   value
                   $?.success?
                 end
  end

  def has_backup?
    File.exist? backup_path
  end

  def tracked?
    exist? || has_backup?
  end

  def in_sync?
    value == backup_value
  end

  def to_s
    if exist?
      if has_backup?
        if in_sync?
          "#{name} ✔".green
        else
          "#{name} (modified)".yellow
        end
      else
        "#{name} (pending backup)".yellow
      end
    elsif has_backup?
      "#{name} (pending restore)".yellow
    else
      "#{name} does not exist (skipping)".light_black
    end
  end

  private

  def backup_path
    Dutiful::Config.storage.path "defaults/#{@domain}/#{@key}"
  end
end
