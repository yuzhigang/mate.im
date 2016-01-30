defmodule Mate.CommentView do
  use Mate.Web, :view

  def render("index.json", %{comments: comments}) do
    render_many(comments, Mate.CommentView, "comment.json")
  end

  def render("create.json",%{data: data}) do
      %{data: data}
  end

  def render("delete.json",%{data: data}) do
      %{data: data}
  end
  
  
  def render("comment.json", %{comment: comment}) do
    avatar = comment.user.avatar
    if nil == avatar do
      avatar = avatar_url(comment.user.email)
    end
    %{id: comment.id,
      content: comment.content,
      user: %{
          id: comment.user.id,
          name: comment.user.name,
          avatar: avatar
        },
      inserted_at: comment.inserted_at
    }
  end
end
