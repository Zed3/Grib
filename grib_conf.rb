class GribConf < Hash
  attr_accessor :conf_name
  ValidParams = [
    "server",
    "target-groups",
    "target-people",
    "summary",
    "description",
    "description-file",
    "testing-done",
    "branch",
    "change-description",
    "revision-range",
    "submit-as",
    "username",
    "password",
    "parent",
    "tracking-branch",
    "repository-url",
    "diff-filename",
    "http-username",
    "http-password"
  ]
  ValidFlags = [
    "new",
    "reopen",
    "guess-summary",
    "guess-description",
    "disable-proxy",
    "diff-only",
  ]
  AllOptions = ValidParams + ValidFlags

  def []=(k,v)
    unless AllOptions.include?(k)
      $LOG.warn("Invalid option: #{k} with value #{v} in grib conf: #{@conf_name}")
      return
    end
    if ValidFlags.include?(k) && !v.class.name.match(/(True|False)Class/)
      $LOG.warn("Invalud boolean value: #{v} for flag: #{k} in configuration: #{@conf_name}. using #{!!v} instead")
      v = !!v
    end
    super(k,v)
  end

  def initialize(file_path_or_hash ,options = {:name => "Unnamed Gribdata"})
    if file_path_or_hash.is_a?(String)
      file = File.new(file_path_or_hash, "rw")
      @conf_name = file.basename
      gribdata = yaml_path,YAML.load(file)
    elsif file_path_or_hash.is_a?(Hash)
      @conf_name = options[:name]
      gribdata = file_path_or_hash
    else
      $LOG.error("invalid argument type: #{file_path_or_hash.class.name}")
      return
    end

    gribdata.each do |key,value|
      self[key] = value
    end
  end
end