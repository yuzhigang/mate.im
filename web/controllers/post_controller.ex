defmodule Mate.PostController do
  use Mate.Web, :controller

  alias Mate.ControllerCommon
  alias Mate.Router.Helpers
  alias Mate.Post
  alias Mate.Comment
  alias Mate.User

  @posts_per_page 5

  def index(conn, %{"page" => page} = params) do
    render conn, "index.json", posts: get_posts_by_page(page)
  end

  def show(conn, %{"id" => id}) do
    case get_loaded_post(String.to_integer(id)) do
      post when is_map(post) ->
        render conn, "show.json", post: post
      _ ->
        render conn, "show.json", post: nil
    end
  end

  def create(conn, %{"title" => title, "content" => content}) do
    user_id = ControllerCommon.get_user_id_for_request(conn)
    if nil == user_id do
      ControllerCommon.unauthorized conn
    else
      post = %{id: nil, title: title, content: content, user_id: user_id}

      changeset = Post.changeset(%Post{}, post)
      regex = ~r/^\s*$/
      if Regex.match?(regex,title) || String.length(title) <= 0 do
        changeset = Ecto.Changeset.add_error(changeset, :title, "主题不能为空")
      end
      if changeset.valid? do
        post = Repo.insert!(changeset)
        render conn, "create.json", data: true
      else
        render conn, "create.json", data: false
      end
    end
  end

  def update(conn, %{"id" => id, "title"=> title, "content"=> content}) do
    post = validate_and_get_post(conn,id)
    case post do
      post when is_map(post) ->
        update_params = %{title: title, content: content }
        changeset = Post.changeset(post, update_params)
        if changeset.valid? do
          Repo.update(changeset)
          render conn, "update.json", data: true
        else
          render conn, "update.json", data: false
        end
      _->
        ControllerCommon.unauthorized conn
      end
  end

  def delete(conn, %{"id" => id}) do
    post = validate_and_get_post(conn, id)
    case post do
      post when is_map(post) ->
        (from comment in Comment, where: comment.post_id == ^String.to_integer(id)) |> Repo.delete_all
        Repo.delete(post)
        render conn, "delete.json", data: true
      _ ->
        ControllerCommon.unauthorized conn
    end
  end

  # 按照页获取
  def get_posts_by_page(page) do
    offset = (String.to_integer(page) - 1) * @posts_per_page;
    query = from(p in Post,
      left_join: c in assoc(p, :comments),
      select: %{post: p, comments_count: count(c.id)},
      group_by: p.id,
      order_by: [{:desc, p.updated_at}], 
      limit: ^@posts_per_page,
      offset: ^offset, preload: [:user])
    Repo.all(query)
  end

  # 加载单条
  defp get_loaded_post(id) do
    query = from(p in Post, 
      where: p.id == ^id,
      left_join: c in assoc(p, :comments),
      select: %{post: p, comments_count: count(c.id)},
      group_by: p.id,
      preload: [:user])
    List.first(Repo.all(query))
  end

  defp validate_and_get_post(conn, id) do
    user_id = ControllerCommon.get_user_id_for_request(conn)
    post = Repo.get(Post, String.to_integer(id))
    if user_id == post.user_id do
      post
    else
      nil
    end
  end

end
