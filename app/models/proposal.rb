class Proposal < ActiveRecord::Base
  has_many :groups
  has_many :rows

  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'

  belongs_to :proposal_status

  accepts_nested_attributes_for :groups, allow_destroy: true

  def rows_attributes=(attributes_collection)
    association = association(:rows)

    attributes_collection.values.each do |attributes|
      attributes = attributes.with_indifferent_access

      # Clear any group association
      attributes[:group_id] = nil

      if attributes[:id].blank?
        rows.build(attributes.except(*UNASSIGNABLE_KEYS))
      else
        existing_record = Row.find(attributes[:id])

        raise association.loaded?.inspect
        target_record = association.target.detect { |record| record == existing_record }

        if target_record
          existing_record = target_record
        else
          association.add_to_target(existing_record)
        end

        assign_to_or_mark_for_destruction(existing_record, attributes, true)

        raise existing_record.inspect
      end
    end
  end
end
