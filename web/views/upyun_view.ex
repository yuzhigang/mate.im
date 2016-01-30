defmodule Mate.UpyunView do
  use Mate.Web, :view

  def render("bucket.json", %{signature: signature, bucket: bucket,
   policy: policy, base: base}) do
    %{signature: signature,
      bucket: bucket,
      policy: policy,
      base: base}
  end
end
