class Dutiful::Logger
  def self.set(quiet, verbose)
    @quiet   = quiet
    @verbose = verbose
  end

  def self.info(message)
    puts message unless @quiet
  end

  def self.success(message)
    puts message.green unless @quiet
  end

  def self.warning(message)
    puts message.yellow unless @quiet
  end

  def self.error(message)
    puts message.red unless @quiet
  end
end
