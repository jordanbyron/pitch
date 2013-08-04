class ProposalDecorator < Draper::Decorator
  delegate_all

  def number
    [model.proposal_number, model.revision].join('-')
  end

  def status
    model.proposal_status.try(:name)
  end

  def list
    (model.rows + model.groups).sort_by(&:position)
  end

  def to_json
    {
      id: model.id,
      number: number,
      customer_name: model.customer_name,
      description: model.description
    }
  end
end
