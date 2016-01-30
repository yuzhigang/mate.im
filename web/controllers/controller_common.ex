defmodule Mate.ControllerCommon do
  import Plug.Conn
  import Phoenix.Controller

  alias Mate.User
  require Joken

  def create_token(id,name,email,avatar) do
    secret = get_jwt_secret()
    user_avatar = avatar
    if nil == user_avatar do
      user_avatar = avatar_url(email)
    end
    %{id: id, name: name, avatar: user_avatar}
    |> Joken.token
    |> Joken.with_exp(current_time() + 604800)
    |> Joken.with_signer(Joken.hs256(secret))
    |> Joken.sign
    |> Joken.get_compact
  end

  def verified_token(my_token) do
    secret = get_jwt_secret()
    my_token
    |> Joken.token
    |> Joken.with_signer(Joken.hs256(secret))
    |> Joken.with_validation("exp", &(&1 > current_time()))
    |> Joken.verify
  end


  def get_user_for_request(conn) do
    user_id = get_user_id_for_request(conn)
    if user_id do
     Repo.get(User, user_id)
    else
      nil
    end
  end

  def get_user_id_for_request(conn) do
    token = get_token_for_request(conn)
    if token do
      verified_token = verified_token(token)
      if verified_token.error do
        nil
      else
        verified_token.claims["id"]
      end
    else
      nil
    end
  end

  def unauthorized(conn) do
    conn 
    |> put_status(401)
    |> text "unauthorized"
  end
  
  def avatar_url(email) do
    hash = email
          |> String.strip
          |> (fn data -> :crypto.hash(:md5, data) end).()
          |> :erlang.bitstring_to_list
          |> Enum.map(&(:io_lib.format("~2.16.0b", [&1])))
          |> List.flatten
        "https://secure.gravatar.com/avatar/#{hash}?s=80&d=identicon"
  end

  defp current_time() do
    datetime = :calendar.universal_time()
    :calendar.datetime_to_gregorian_seconds(datetime)
  end

  defp get_token_for_request(conn) do
    authorization = get_req_header(conn,"authorization")
    if length(authorization) == 1 do
      authorization = String.split(List.first(authorization))
      authorization = List.last(authorization)
      authorization
    else
      nil
    end
  end

  defp get_jwt_secret() do
    config =  Application.get_env(:mate, :jwt, [])
    config[:secret]
  end
end