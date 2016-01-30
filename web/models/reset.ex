defmodule Mate.Reset do
  use Mate.Web, :model

  @primary_key false
  schema "resets" do
    field :email, :string
    field :sha, :string

    timestamps 


  end

  def changeset(reset, params \\ nil) do
    reset
    |> cast(params, ~w(email sha))
    |> validate_format(:email, ~r/@/, message: "无效邮箱")
  end

  def get_hash(email) do
    datetime = :calendar.universal_time()
    timestamps = :calendar.datetime_to_gregorian_seconds(datetime)
    key = email <> to_string(timestamps)
    :crypto.hash(:sha256,key)
     |> Base.encode16
     |> String.downcase    
  end
  
  def can_send(reset) do
    datetime = :calendar.universal_time()
    timestamps = :calendar.datetime_to_gregorian_seconds(datetime)
    update_timestamps = 
      :calendar.datetime_to_gregorian_seconds(Ecto.DateTime.to_erl(reset.updated_at))
    if (timestamps - update_timestamps) >= 3600 do
      true
    else
      false
    end
  end

  def can_reset(reset) do
    datetime = :calendar.universal_time()
    timestamps = :calendar.datetime_to_gregorian_seconds(datetime)
    update_timestamps = 
      :calendar.datetime_to_gregorian_seconds(Ecto.DateTime.to_erl(reset.updated_at))
    if (timestamps - update_timestamps) >= 10800 do
      false
    else
      true
    end
  end

end
