defmodule Mate.Router do
  use Mate.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Mate do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    
  end

  # Other scopes may use custom stacks.
  scope "/api", Mate do
     pipe_through :api

     resources "/posts", PostController, except: [:new, :edit] do
      resources "/comments", CommentController, except: [:new, :show, :edit, :update]
    end


     post "auth/signup", AuthController, :signup
     post "auth/signin", AuthController, :signin
     get "auth/email", AuthController, :email
     get "auth/verify", AuthController, :verify
     get "upyun/bucket", UpyunController, :bucket
  end
end
