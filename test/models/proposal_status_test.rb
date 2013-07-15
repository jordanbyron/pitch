require "test_helper"

describe ProposalStatus do
  before do
    @proposal_status = ProposalStatus.new
  end

  it "must be valid" do
    @proposal_status.valid?.must_equal true
  end
end
