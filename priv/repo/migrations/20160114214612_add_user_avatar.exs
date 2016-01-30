
defmodule Repo.Migrations.AddUsersAvatar do
  use Ecto.Migration

  def up do
  	alter table(:users) do
  		add :avatar, :text
  	end

  end

  def down do

  	alter table(:users) do
  		remove :avatar
  	end
  end
end
