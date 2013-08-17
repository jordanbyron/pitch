class ProposalsController < ApplicationController
  include Tubesock::Hijack

  before_filter :find_proposal, only: %w[show edit update destroy stream]

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
    @proposal = Proposal.new # (proposal_params)

    @proposal.created_by = current_user
    @proposal.updated_by = current_user

    if @proposal.save
      redirect_to edit_proposal_path(@proposal)
    else
      @proposal = @proposal.decorate
      render :new
    end
  end

  def stream
    channel = "proposal_#{@proposal.id}"

    hijack do |tubesock|
      # Listen on its own thread
      redis_thread = Thread.new do
        # Needs its own redis connection to pub
        # and sub at the same time
        Redis.new.subscribe channel do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        # pub the message when we get one
        # note: this echoes through the sub above
        Redis.new.publish channel, m
      end

      tubesock.onclose do
        # stop listening when client leaves
        redis_thread.kill
      end
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
