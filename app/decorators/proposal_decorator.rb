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

  def add_row_button(f, options={})
    add_item_button f, :rows, options
  end

  def add_group_button(f, options={})
    add_item_button f, :groups, options
  end

  def render_items(f)
    list.map do |list_item|
      if Row === list_item
        f.fields_for :rows, list_item do |row|
          h.render "row_fields", f: row
        end
      else
        f.fields_for :groups, list_item do |group|
          h.render "group_fields", f: group
        end
      end
    end.join("\n").html_safe
  end

  private

  def add_item_button(f, type, options)
    h.link_to_add_association(
      options.delete(:name) || "+ #{type.to_s.singularize.capitalize}",
      f, type, {
        class: 'btn btn-small',
        'data-association-insertion-node'   => '#list',
        'data-association-insertion-method' => 'append',
        force_non_association_create: true
      }.merge(options)
    )
  end
end
