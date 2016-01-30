defmodule Mate.AuthView do
  use Mate.Web, :view

  def render("signup.json", %{data: data}) do
    %{data: data}
  end
  def render("signin.json", %{token: data}) do
    %{token: data}
  end
  def render("verify.json", %{verify: data}) do
    %{verify: data}
  end

  def render("email.json", %{available: data}) do
    %{available: data}
  end



end
