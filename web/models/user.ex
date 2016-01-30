defmodule Mate.User do
  use Mate.Web, :model
  alias Mate.Repo

  schema "users" do
    field :email,      :string
    field :name,       :string
    field :password,   :string
    field :avatar,     :string, default: nil
    timestamps 
    has_many :comments, Mate.Comment
    has_many :posts, Mate.Post

  end

  def changeset(user, params \\ nil) do
    user
    |> cast(params, ~w(name email password), ~w(avatar))
    |> validate_length(:password, min: 6, message: "密码至少%{count}位")
    |> validate_format(:email, ~r/@/, message: "邮箱不正确")
    |> unique_constraint(:name, name: :users_name_key, message: "名字已经使用了")
    |> unique_constraint(:email, name: :users_email_key, message: "邮箱已经使用了")
  end

  def valid_password?(record, password) do
    salt = String.slice(record.password, 0, 29)
    {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
    "#{hashed_password}" == record.password
  end

  def encrypt_password(password) do
    if password != nil do
      {:ok, salt} = :bcrypt.gen_salt
      {:ok, hashed_password} = :bcrypt.hashpw(password, salt)
      hashed_password
    end
  end

  def update_password(changeset,password) do
    changeset = Ecto.Changeset.put_change(changeset, :password, 
      password
      |> encrypt_password 
      |> to_string)
    Repo.update(changeset)
  end

  def get_user_by_email(email) do
    query = from u in Mate.User, where: u.email == ^email
    Repo.one query
  end
end
