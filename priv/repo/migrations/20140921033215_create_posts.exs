defmodule Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def up do
  	create table(:posts) do
      add :title, :string, size: 140
      add :content, :text
      add :user_id, references(:users)

      timestamps

    end
  end

  def down do
    drop table(:posts)
  end
end
