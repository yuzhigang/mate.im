defmodule Mate.AuthController do
  use Mate.Web, :controller

  alias Mate.User
  alias Mate.ControllerCommon


  def signup(conn, %{"email" => email, "name" => name, "password" => password}) do
    user = %{email: email, name: name, password: password}
    # validate_result = User.validate(user)

    changeset = User.changeset(%User{}, user)
    regex = ~r/^\s*$/

    bad_name_list = [
      "root", "admin", "administrator", "post", "bot", "robot", "master", "webmaster",
      "account", "people", "user", "users", "project", "projects",
      "search", "action", "favorite", "like", "love", "none", "nil",
      "team", "teams", "group", "groups", "organization",
      "organizations", "package", "packages", "org", "com", "net",
      "help", "doc", "docs", "document", "documentation", "blog",
      "bbs", "forum", "forums", "static", "assets", "repository",
      "public", "private"
    ]

    if (name in bad_name_list) || 
      Regex.match?(regex,name) do
      changeset = Ecto.Changeset.add_error(changeset, :name,"无效的用户名")
    end

    if changeset.valid? do
      changeset = Ecto.Changeset.put_change(changeset, :password,
       user.password |> User.encrypt_password |> to_string)
      case Repo.insert(changeset) do
        {:ok, _user} ->
        	render conn, "signup.json", data: "用户创建成功，请用邮箱登陆"
        {:error, _changeset} ->
        	conn 
        	|> put_status(400)
        	|> render  "signup.json", data: "用户名或邮件可能已经被占用或密码过短"
      end
    else
        conn 
        |> put_status(400)
        |> render  "signup.json", data: "用户名或邮件可能已经被占用或密码过短" 
    end
  end
  
  def signin(conn, %{"email"=> email,"password" => password}) do
  	user = User.get_user_by_email(email)

  	if nil == user do
  		conn 
  	  	|> put_status(401)
  	  	|> render "signin.json", token: ""
  	else
        if User.valid_password?(user, password) do
        	my_token =ControllerCommon.create_token(user.id,
            user.name, user.email, user.avatar)
         	render conn, "signin.json", token: my_token
        else
          render conn, "signin.json", token: ""
        end
  	end
  end

  def verify(conn, %{"token" => my_token}) do
    my_verified_token  = ControllerCommon.verified_token(my_token)

    if my_verified_token.error do
      render conn, "verify.json", verify: false
    else
      render conn, "verify.json", verify: true
    end
  end

  def email(conn, %{"email" => email}) do
  	user = User.get_user_by_email(email)
    if nil == user do
   		render conn, "email.josn", available: true
    else
    	render conn, "email.json", available: false
    end
  end


end
