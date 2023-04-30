defmodule PhxCropperJsWeb.PageController do
  use PhxCropperJsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
