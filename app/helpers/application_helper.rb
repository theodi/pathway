module ApplicationHelper

  def pretty_date(datetime)
    datetime.strftime("%A, #{datetime.day.ordinalize} %B %Y") unless datetime.blank?
  end

  def link_to_add_fields(name, f, association, opts={})
    new_object = f.object.send(association).build
    id = new_object.object_id

    partial_location = opts[:partial_location]
    partial_location ||= "#{association}/#{association.to_s.singularize}_fields"

    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(partial_location, {f: builder}.merge(opts))
    end

    link_to(name, '#', class: 'add_fields moreLinks', data: { id: id, fields: fields.gsub('\n', '') })
  end

  def breadcrumb(str=nil)
    breadcrumb = link_to "My assessments", assessments_path
    breadcrumb << " > #{link_to(@assessment.title, assessment_path(@assessment))}".html_safe if @assessment
    breadcrumb << " > #{@activity.title}" if @activity
    breadcrumb << " > #{str}" unless str.blank?
    content_tag :h4, breadcrumb, class: "breadcrumb"
  end

end
