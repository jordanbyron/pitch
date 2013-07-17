class RowAttributes
  attr_reader :parent, :row_attributes

  def initialize(parent, row_attributes)
    @parent         = parent
    @row_attributes = row_attributes.values

    process
  end

  private

  def process
    association = parent.association(:rows)

    row_attributes.each do |attributes|
      attributes = attributes.with_indifferent_access

      # Clear any unnecessary associations
      if Proposal === parent
        attributes[:group_id]    = nil
        attributes[:proposal_id] = parent.id
      elsif Group === parent
        attributes[:group_id]    = parent.id
        attributes[:proposal_id] = nil
      end

      if attributes[:id].blank?
        parent.rows.build(attributes.except(*Row::UNASSIGNABLE_KEYS))
      else
        existing_record = Row.find(attributes[:id])

        target_record = association.target.detect { |record| record == existing_record }

        if target_record
          existing_record = target_record
        else
          association.add_to_target(existing_record)
        end

        parent.send(:assign_to_or_mark_for_destruction,
                    existing_record, attributes, true)
      end
    end
  end
end
