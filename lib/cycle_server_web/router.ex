defmodule CycleWeb.Router do
  use CycleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CycleWeb.ClientSecretPlug
  end

  scope "/api", CycleWeb do
    pipe_through :api

    resources "/articles", ArticleController, except: [:new, :edit]
    post "/articles/:id/like", ArticleController, :inc_likes
    post "/articles/:id/dislike", ArticleController, :dec_likes
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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: CycleWeb.Telemetry
    end
  end
end
