module ApplicationHelper
  def flash_class(level)
    case level.to_sym
      # allow either standard rails flash category symbols...
      when :notice then "info"
      when :success then "success"
      when :alert then "warning"
      when :error then "danger"
      # ... or bootstrap class symbols
      when :info then "info"
      when :warning then "warning"
      when :danger then "danger"
      # and default to being alarming
      else "danger"
    end
  end

  def page_title
    @title || controller_name.gsub( /Controller/, "" ).humanize
  end

  def amount_in_currency(price)
    number_to_currency(price, :unit => "£")
  end

  def render_pagination collection
    will_paginate collection,:page_links => false, renderer: BootstrapPagination::Rails
  end
end
