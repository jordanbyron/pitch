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

  def add_row_button(f)
    add_item_button f, :rows
  end

  def add_group_button(f)
    add_item_button f, :groups
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

  def add_item_button(f, type)
    h.link_to_add_association "Add #{type.to_s.singularize.capitalize}", f,
      type, class: 'btn',
      'data-association-insertion-node' => '#list',
      'data-association-insertion-method' => 'append'
  end
end
