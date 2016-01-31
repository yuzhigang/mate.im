defmodule Mate.UserController do
  use Mate.Web, :controller

  import Mate.ControllerCommon
  alias Mate.User
  alias Mate.Post




  def show(conn, %{"id" => id}) do
    case Repo.get(User, String.to_integer(id)) do
      user when is_map(user) ->
        render conn, "show.json", user: user
      _ ->
        ControllerCommon.home(conn)
    end
  end

  def update(conn, %{"id" => id, "user" => params}) do
    user = Repo.get(User, String.to_integer(id))
    if params["oldpassword"] != nil && params["password"] != nil do
      if User.valid_password?(user,params["oldpassword"]) do
        params = :maps.remove("oldpassword",params)
        update_user_password(conn,user,params)
      else
        unauthorized conn
      end
    else
      user_id = get_session(conn, :user_id)
      if user_id == user.id do
        params = :maps.remove("oldpassword",params)
        params = :maps.remove("password",params)
        update_user_profile(conn,user,params)
      else
        unauthorized conn
      end
    end

  end

  defp update_user_password(conn,user,params) do
    changeset = User.changeset(user, params)
    if changeset.valid? do
      changeset = Ecto.Changeset.put_change(changeset, :password, 
      params["password"] 
            |> User.encrypt_password 
            |> to_string)  

      Repo.update(changeset)
      show(conn,%{"id" => Integer.to_string(user.id)})
    else
      render conn, "edit.html", user: user, errors: changeset.errors, user_id: get_session(conn, :user_id)
    end
  end

  defp update_user_profile(conn,user,params) do
    changeset = User.changeset(user, params)
    if changeset.valid? do
      Repo.update(changeset)
      json conn, %{error: 0}
    else
      errors = Enum.map(changeset.errors, fn {f, d} ->
          %{ "error" => d }
        end)
      json conn, %{error: 1, payload: errors}
    end
  end





end
