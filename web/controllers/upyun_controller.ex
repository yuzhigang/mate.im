defmodule Mate.UpyunController do
  use Mate.Web, :controller


  def bucket(conn, %{"bucket" => bucket}) do  
    config =  Application.get_env(:mate, :upyun, [])
    bucket_config = config[:bucket]
    datetime = :calendar.universal_time()
    timestamps = :calendar.datetime_to_gregorian_seconds(datetime) + 3600
    policy = "{\"bucket\":\""<> bucket <> "\", \"save-key\": \"/{year}/{mon}/{day}/{hour}/{filemd5}{.suffix}\", \"expiration\": #{timestamps}}"
    form_api_secret = bucket_config[bucket]
    encoded_policy = Base.url_encode64(policy)
    base = "https://"<> bucket <> ".b0.upaiyun.com"
    signature = :crypto.hash(:md5,encoded_policy <> "&" <> form_api_secret) 
    |> Base.encode16
    render conn, "bucket.json",
      signature: signature,
      bucket: bucket,
      policy: encoded_policy,
      base: base 

  end

end
