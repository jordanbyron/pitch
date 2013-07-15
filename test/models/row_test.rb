require "test_helper"

describe Row do
  before do
    @row = Row.new
  end

  it "must be valid" do
    @row.valid?.must_equal true
  end
end
