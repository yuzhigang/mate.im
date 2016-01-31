defmodule Mate.UserView do
  use Mate.Web, :view

  def render("show.json", %{user: user}) do
    avatar = user.avatar
    if nil == avatar do
      avatar = avatar_url(user.email)
    end
    %{
      id: user.id,
      name: user.name,
      avatar: avatar,
      inserted_at: user.inserted_at
    }
  end

end
