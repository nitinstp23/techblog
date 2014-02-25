module Techblog
  module Info
    # Load all info from info.yml
    info     = YAML.load_file('config/info.yml')

    EMAIL    = info["email"]
    GITHUB   = info["github"]
    TWITTER  = info["twitter"]
    LINKEDIN = info["linkedin"]
    COMPANY  = info["company"]

  end
end
