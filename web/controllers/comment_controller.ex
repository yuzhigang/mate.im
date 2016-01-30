defmodule Mate.CommentController do
  use Mate.Web, :controller

  alias Mate.ControllerCommon
  alias Mate.Router.Helpers
  alias Mate.Post
  alias Mate.Comment
  alias Mate.Notification
  alias Mate.User

  @comments_per_page 5

  def index(conn, %{"post_id"=>post_id, "page" => page} = params) do
    render conn, "index.json", comments: get_comments_by_page(post_id,page)
  end


  def create(conn, %{"post_id" => post_id, "content" => content}) do
    user_id = ControllerCommon.get_user_id_for_request(conn)
    if nil == user_id do
      ControllerCommon.unauthorized conn
    else
      comment = %{post_id: String.to_integer(post_id), 
                user_id: user_id, content: content}
      changeset = Comment.changeset(%Comment{}, comment)
      ## 验证comment的有效性
      if changeset.valid? do
        comment = Repo.insert!(changeset)
        post = from(p in Post, where: p.id == ^comment.post_id, preload: :user)
        |> Repo.one

        post
        |> Post.changeset(%{updated_at: comment.inserted_at})
        |> Repo.update
        render conn, "create.json", data: true
      else
        render conn, "create.json", data: false
      end
    end

  end


  def delete(conn, %{"id" => id}) do
    comment = validate_and_get_comment(conn,id)
    case comment do
      comment when is_map(comment) ->
          Repo.delete(comment)
          render conn, "delete.json", data: true
      _->
        ControllerCommon.unauthorized conn
    end
  end

  # 按照页获取
  defp get_comments_by_page(post_id,page) do
    offset = (String.to_integer(page) - 1) * @comments_per_page;
    Repo.all(from c in Comment, where: c.post_id == ^post_id,
     order_by: [{:desc, c.inserted_at}], limit: ^@comments_per_page,
      offset: ^offset, preload: [:user])
  end

  defp validate_and_get_comment(conn, id) do
    user_id = ControllerCommon.get_user_id_for_request(conn)
    comment = Repo.get(Comment, String.to_integer(id))
    if nil != comment do
      if user_id == comment.user_id do
        comment
      else
        nil
      end
    end
  end



end
