module ApplicationHelper

  def page_identifier
    if current_page?(controller: 'static', action: 'about')
      'page-about'
    else
      'page'
    end
  end

end
