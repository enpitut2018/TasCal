class StaticController < ApplicationController

  def kiyaku
      render file: "/app/views/kiyaku/kiyaku.html", layout: true
  end

  def privacy
      render file: "/app/views/kiyaku/privacy.html", layout: true
  end

  def about
      render file: "/app/views/about/about.html.erb", layout: true
  end

end