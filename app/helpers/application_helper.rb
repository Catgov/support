require 'support/navigation/feedex_section'
require 'support/navigation/section_groups'

module ApplicationHelper
  def all_section_groups
    Support::Navigation::SectionGroups.new(current_user)
  end

  def feedex_section
    Support::Navigation::FeedexSection.new(current_user)
  end

  def in_feedex?
    current_page?(controller: "anonymous_feedback/explore", action: :new) ||
      current_page?(controller: 'anonymous_feedback', action: :index)
  end

  def nav_link_to(section, options = { is_active: false })
    list_class = case
      when options[:is_active] then 'active'
      when !section.accessible? then 'disabled'
      else '' end

    content_tag(:li, class: list_class, id: options[:id]) do
      link_to section.label, section.link
    end
  end
end
