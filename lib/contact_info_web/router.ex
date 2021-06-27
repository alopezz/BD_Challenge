defmodule ContactInfoWeb.Router do
  use ContactInfoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # Don't use CSRF protection in dev environment
    if Mix.env() not in [:dev, :test] do
      plug :protect_from_forgery
    end
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug ContactInfoWeb.JwtAuthPlug
  end

  pipeline :logging do
    plug ContactInfoWeb.LogPlug
  end

  scope "/", ContactInfoWeb do
    pipe_through :browser
    pipe_through :auth
    pipe_through :logging

    resources "/", ContactInfoController,
      only: [:index, :new, :show, :create, :update, :delete],
      param: "case_id"

    post "/search", ContactInfoController, :search
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ContactInfoWeb.Telemetry
    end
  end
end
