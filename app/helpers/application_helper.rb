module ApplicationHelper
  class CaptionRule
    attr_reader :class_name, :caption
      def initialize(caption, class_name)
      @caption = caption
      @class_name = class_name
    end
  end

  def tag_cloud_maker(tags)
    content_tag(:p, :id=>'show_tags_field') do
      tag_cloud(tags, %w(css1 css2 css3 css4)) do |tag, css_class|
        concat link_to(tag.name, yield(tag.name), :class=>css_class, :title=>tag.taggings_count)
        concat ' '
      end
    end
  end

  def action_button(resource, activated_proc, stoped_proc)
    content_tag(:div, :class=>'dropdown action_button') do
      concat content_tag(:button, :class => "btn btn-default dropdown-toggle", :type => "button", "data-toggle" => "dropdown", "aria-expanded" => "false") {
        concat content_tag(:span, :class => "caret") {}
      }
      concat content_tag(:ul, :class => "dropdown-menu dropdown-menu-right", :role => "menu") {
        concat content_tag(:li) {
          link_to('Activate', activated_proc.call(resource), :method => :post, :data => { confirm: 'Are you sure?' })
        }
        concat content_tag(:li) {
          link_to('Stop', stoped_proc.call(resource), :method => :post, :data => { confirm: 'Are you sure?' })
        }
        concat content_tag(:li) {
          link_to('Remove', resource, :method => :delete, :data => { confirm: 'Are you sure?' })
        }
      }
    end
  end

  def done_button(resource, path_str)
    content_tag(:div, :class=>'action_button') do
      concat link_to('', path_str, :method => :post, :class => "btn btn-link glyphicon glyphicon-check", :title => "Set done", :data => { confirm: 'Are you sure?' })			
    end
  end

  def appointment_status_button1(resource, open_path_str, done_path_str)
    content_tag(:div, :class=>'dropdown action_button') do
      concat content_tag(:button, :class => "btn btn-default dropdown-toggle", :type => "button", "data-toggle" => "dropdown", "aria-expanded" => "false") {
        concat content_tag(:span, :class => "caret") {}
      }
      concat content_tag(:ul, :class => "dropdown-menu", :role => "menu") {
        concat content_tag(:li) {
          link_to('Open', open_path_str, :method => :post, :data => { confirm: 'Are you sure?' })
        }
        concat content_tag(:li) {
          link_to('Done', done_path_str, :method => :post, :data => { confirm: 'Are you sure?' })
        }
      }
    end
  end

  def caption(rules, rule_type, caption)
    rule = rules[rule_type]
    content_tag(:h2, :class => rule.class_name, :title => rule.caption) do
      caption
    end
  end

  def conditionable_caption(resource, caption)
    rules_hash = {}
    rules_hash[:removed] = CaptionRule.new('Removed', 'removed_caption')
    rules_hash[:stoped] = CaptionRule.new('Stoped', 'stoped_caption')
    rules_hash[:active] = CaptionRule.new('Active', 'active_caption')
    caption(rules_hash, resource.get_condition, caption)
  end

  def opportunity_statusable_caption(resource, caption)
    rules_hash = {}
    rules_hash[:finished] = CaptionRule.new('Finished', 'removed_caption')
    rules_hash[:canceled] = CaptionRule.new('Canceled', 'stoped_caption')
    rules_hash[:open]     = CaptionRule.new('Open', 'active_caption')
    caption(rules_hash, resource.get_status, caption)
  end

  def statusable_caption(resource, caption)
    if resource.get_status == :done then
      class_name = 'done_caption'
    else
      class_name = 'opened_caption'
    end
      content_tag(:p,	:class => class_name) do
      caption
    end
  end

  def set_statuses(model, path_proc)
    statuses_paths = {}
    model.statuses.each do |status|  	
      statuses_paths[status] = path_proc.call(status)
    end
    statuses_paths
  end

  def state_button(paths_hash)
    content_tag(:div, :class=>'dropdown action_button') do
      concat content_tag(:button, :class => "btn btn-default dropdown-toggle", :type => "button", "data-toggle" => "dropdown", "aria-expanded" => "false") {
        concat content_tag(:span, :class => "caret") {}
      }
      concat content_tag(:ul, :class => "dropdown-menu", :role => "menu") {
        paths_hash.each do |status, path|
          concat content_tag(:li) {
            link_to(status.name, path, :method => :post, :remote => true, :data => { confirm: 'Are you sure?' })
          }
        end
      }
    end
  end

  def get_company_name(id)
    if id != nil
      Company.find(id.to_i).name
    end
  end

  def get_person_name(id)
    if id != nil
      Person.find(id.to_i).name
    end
  end

  def not_null_property(value, property_name)
    value ? value.send(property_name) : ''
  end

end
