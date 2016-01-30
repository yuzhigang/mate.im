defmodule Mate.Comment do
  use Mate.Web, :model

  schema "comments" do
    field :content, :string

    timestamps 

    belongs_to :post, Mate.Post
    belongs_to :user, Mate.User
  end

  def changeset(comment, params \\ nil) do
    comment
    |> cast(params, ~w(content post_id user_id))
  end
end
