class RowsController < ApplicationController
  respond_to :json

  before_filter :find_proposal

  def index
    respond_with @proposal.rows.order("position")
  end

  def create
    render json: @proposal.rows.create(row_params)
  end

  def update
    respond_with Row.update(params[:id], row_params)
  end

  def destroy
    respond_with Row.destroy(params[:id])
  end

  private

  def find_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end

  def row_params
    params.require(:row).permit(:description, :position, :sku, :price, :quantity)
  end
end
