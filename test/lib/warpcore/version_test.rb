require_relative '../../test_helper'

describe WarpCore do

  it "must be defined" do
    WarpCore::VERSION.wont_be_nil
  end

end
