require 'spec_helper'

module WsjtxUtils
  describe HeartbeatMessage do
    it { is_expected.to have_attributes(schema: nil, version: nil, revision: nil) }
  end
end
