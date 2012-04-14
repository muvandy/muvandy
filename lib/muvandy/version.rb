require "versionomy"
module Muvandy
  VERSION = Versionomy.create(:major => 1, :tiny => 2, :release_type => :alpha).to_s
end
