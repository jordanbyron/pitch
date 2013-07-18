class ProposalsController < ApplicationController
  before_filter :find_proposal, only: %w[edit update destroy]

  def index
    @proposals = Proposal.order("updated_at DESC").decorate
  end

  def new
    @proposal = Proposal.new.decorate
  end

  def create
    @proposal = Proposal.new(proposal_params)

    @proposal.created_by = current_user
    @proposal.updated_by = current_user

    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      @proposal = @proposal.decorate
      render :new
    end
  end

  def update
    @proposal.attributes = proposal_params
    @proposal.updated_by = current_user

    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      render :edit
    end
  end

  def destroy
    @proposal.destroy

    flash[:notice] = "Proposal deleted"
    redirect_to proposals_path
  end

  private

  def proposal_params
    rows_attributes = [:id, '_destroy', :description, :sku, :quantity, :price,
                        :position]

    params.require(:proposal).permit(:customer_name, :description,
      rows_attributes: rows_attributes,
      groups_attributes: [:id, '_destroy', :name, :position,
        rows_attributes: rows_attributes])
  end

  def find_proposal
    @proposal = Proposal.find(params[:id]).decorate
  end
end
