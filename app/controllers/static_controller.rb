class StaticController < ApplicationController

  def kiyaku
      render file: "/app/views/kiyaku/kiyaku.html", layout: true
  end

  def privacy
      render file: "/app/views/kiyaku/privacy.html", layout: true
  end

end