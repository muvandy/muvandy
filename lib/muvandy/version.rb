require "versionomy"
module Muvandy
  VERSION = Versionomy.create(:major => 1, :minor => 1, :tiny => 1, :release_type => :alpha).to_s
end
