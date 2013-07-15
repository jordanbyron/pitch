require 'decorator_strategy'

class ProposalsController < ApplicationController
  expose :proposals, strategy: DecoratorStrategy
  expose :proposal, attributes: :proposal_params

  def create
    proposal.created_by = current_user
    proposal.updated_by = current_user

    if proposal.save
      redirect_to edit_proposal_path(proposal)
    else
      render :new
    end
  end

  def update
    proposal.updated_by = current_user

    if proposal.save
      redirect_to edit_proposal_path(proposal)
    else
      render :edit
    end
  end

  private

  def proposal_params
    params.require(:proposal).permit(:customer_name, :description,
      rows_attributes: [:id, '_destroy', :description, :sku, :quantity, :price,
                        :position],
      groups_attributes: [:id, '_destroy', :name, :position])
  end
end