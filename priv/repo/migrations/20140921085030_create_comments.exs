defmodule Repo.Migrations.CreateComments do
  use Ecto.Migration

  def up do
  	create table(:comments) do
      add :content, :text
      add :user_id, references(:users)
      add :post_id, references(:posts)

      timestamps

    end

  end

  def down do
  	drop table(:comments)
  end
end
