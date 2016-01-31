defmodule Mate.PageController do
  use Mate.Web, :controller

  def index(conn, _params) do
  	conn 
  	|> put_resp_header("Cache-Control", "no-cache")
  	|> render "index.html"
  end

end
