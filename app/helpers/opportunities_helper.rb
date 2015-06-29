module OpportunitiesHelper
  def opportunity_ico(opportunity)
    class_name = 'glyphicon '
	class_name << 'glyphicon-eye-open' if opportunity.get_stage == :awareness
	class_name << 'glyphicon-search' if opportunity.get_stage == :interest
	class_name << 'glyphicon-fire' if opportunity.get_stage == :decision
	class_name << 'glyphicon-usd' if opportunity.get_stage == :buy		

	content_tag(:span, :class => class_name, "aria-hidden" => "true", :title => opportunity.get_stage.to_s) {
	}
  end

  def stage_pager(opportunity)	
    disable_prev_style = opportunity.is_first_stage? ? ' disabled': ''
	disable_prev_style = "previous" + disable_prev_style

	disable_next_style = opportunity.is_last_stage? ? ' disabled': ''
	disable_next_style = "next" + disable_next_style

	content_tag(:ul, :class => "pager") {
	  concat content_tag(:li, :class => disable_prev_style) {
        concat link_to("&larr; Prev stage".html_safe, prev_stage_opportunity_path(opportunity), :method => :post)
	  }
	  concat @opportunity.get_stage.to_s
	  concat content_tag(:li, :class => disable_next_style) {
        concat link_to("Next stage &rarr;".html_safe, next_stage_opportunity_path(opportunity), :method => :post)
	  }
	}
  end

  def set_opportunity_status_paths(opportunity, company, person, stage)
    if company
      set_statuses(Opportunity, lambda {|u| opportunity_set_status_from_company_path(id: opportunity, status_name: u.value.to_s, company_parent_id: company)})
    elsif person
      set_statuses(Opportunity, lambda {|u| opportunity_set_status_from_person_path(id: opportunity, status_name: u.value.to_s, person_parent_id: person)})
    else
      set_statuses(Opportunity, lambda {|u| opportunity_set_status_path(id: opportunity, status_name: u.value.to_s, stage: stage)})
    end
  end

  def opportunity_status_selector(opportunity, status_paths)
    content_tag(:div, :class => 'list-group') {
      status_paths.each do |status, path|
        concat link_to(status.name, path, :method => :post, :data => { confirm: 'Are you sure?' }, :class => "list-group-item #{opportunity.get_status == status.value ? 'active' : ''}")
      end
    }
  end

end
