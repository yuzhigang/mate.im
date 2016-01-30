defmodule Mate.Post do
  use Mate.Web, :model

  schema "posts" do
    field :title, :string
    field :content, :string

    timestamps 

    belongs_to :user, Mate.User
    has_many :comments, Mate.Comment
  end

  def changeset(post, params \\ nil) do
    post
    |> cast(params, ~w(content title user_id))
  end
end
