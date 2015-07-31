class Dutiful::Config
  PATH = File.expand_path '~/.dutiful/config.toml'

  def self.storage
    @storage ||= if content[:storage]
      name = content[:storage][:name]
      path = content[:storage][:path]

      Dutiful::Storage.new name: name, path: path
    else
      Dutiful::Storage.find { |storage| storage.available? }
    end
  end

  private

  def self.content
    @content ||= Tomlrb.load_file(PATH, symbolize_keys: true) rescue {}
  end
end
