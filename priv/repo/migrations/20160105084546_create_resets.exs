defmodule Repo.Migrations.CreateResets do
  use Ecto.Migration

  def change do
    create table(:resets, primary_key: false) do
      add :sha, :string
      add :email, :text

      timestamps

    end
  end

end
