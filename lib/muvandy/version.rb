require "versionomy"
module Muvandy
  VERSION = Versionomy.create(:major => 1, :minor => 2, :tiny => 2, :release_type => :alpha).to_s
end
