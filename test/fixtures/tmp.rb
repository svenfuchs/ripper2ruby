  def find_credentials creds
    case creds
    when File:
      YAML.load_file(creds.path)
    when String:
      YAML.load_file(creds)
    when Hash:
      creds
    else
      raise ArgumentError, "Credentials are not a path, file, or hash."
    end
  end
