defmodule Mate.PostView do
  use Mate.Web, :view

  def render("index.json", %{posts: posts}) do
    render_many(posts, Mate.PostView, "index_post.json")
  end

  def render("show.json", %{post: post}) do
    render_one(post, Mate.PostView, "post.json")
  end
  def render("create.json",%{data: data}) do
      %{data: data}
  end
  def render("update.json",%{data: data}) do
      %{data: data}
  end
  def render("delete.json",%{data: data}) do
      %{data: data}
  end
  def render("post.json", %{post: %{post: post, 
    comments_count: comments_count}}) do
    avatar = post.user.avatar
    if nil == avatar do
      avatar = avatar_url(post.user.email)
    end
    %{id: post.id,
      title: post.title,
      content: post.content,
      user: %{
          id: post.user.id,
          name: post.user.name,
          avatar: avatar,
          inserted_at: post.user.inserted_at
        },
      comments_count: comments_count,
      inserted_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end

  def render("index_post.json", %{post: %{post: post, 
    comments_count: comments_count}}) do
    avatar = post.user.avatar
    if nil == avatar do
      avatar = avatar_url(post.user.email)
    end
    %{id: post.id,
      title: post.title,
      user: %{
          id: post.user.id,
          name: post.user.name,
          avatar: avatar,
          inserted_at: post.user.inserted_at
        },
      comments_count: comments_count,
      inserted_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end
end
