require "test_helper"

describe Proposal do
  before do
    @proposal = Proposal.new
  end

  it "must be valid" do
    @proposal.valid?.must_equal true
  end
end
