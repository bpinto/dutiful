class Dutiful::ApplicationDefault
  Result = Struct.new(:error, :success?)

  def initialize(hash)
    @description = hash[:description]
    @domain      = hash[:domain]
    @key         = hash[:key]
  end

  def backup
    FileUtils.mkdir_p File.dirname "#{backup_path}"
    File.open(backup_path, 'w') { |file| file << value }

    Result.new nil, true
  rescue => ex
    Result.new ex.message, false
  end

  def backup_value
    value = nil
    File.open(backup_path) { |file| value = file.read }

    value
  end

  def restore
    `defaults write #{@domain} #{@key} #{backup_value}`
    Result.new nil, true
  rescue => ex
    Result.new ex.message, false
  end

  def name
    "#{@domain} #{@key}"
  end

  def value
    @value ||= `defaults read #{@domain} #{@key} 2>/dev/null`
  end

  def exist?
    @exists ||= begin
                   @value = `defaults read #{@domain} #{@key} 2>/dev/null`
                   $?.success?
                 end
  end

  def has_backup?
    File.exist? backup_path
  end

  def should_sync?
    exist? || has_backup?
  end

  def synced?
    value == backup_value
  end

  def to_s
    if exist?
      if has_backup?
        if synced?
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
      "#{name} does not exist (skipping)".yellow
    end
  end

  private

  def backup_path
    Dutiful::Config.storage.path "defaults/#{@domain}/#{@key}"
  end
end
