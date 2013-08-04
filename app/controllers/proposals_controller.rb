class ProposalsController < ApplicationController
  before_filter :find_proposal, only: %w[show edit update destroy]

  def index
    @proposals = Proposal.order("updated_at DESC").decorate
  end

  def show
    respond_to do |format|
      format.json { render json: @proposal.to_json }
    end
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
      respond_to do |format|
        format.html { redirect_to edit_proposal_path(@proposal) }
        format.json { render json: @proposal.to_json }
      end

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
    params.require(:proposal).permit(:customer_name, :description)
  end

  def find_proposal
    @proposal = Proposal.find(params[:id]).decorate
  end
end
