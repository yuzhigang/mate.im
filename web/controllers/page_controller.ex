defmodule Mate.PageController do
  use Mate.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
