defmodule LoyaltyApiWeb.Router do
  use LoyaltyApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :customer do
    plug(:accepts, ["json"])
    plug(LoyaltyApiWeb.Plugs.CustomerAuth)
  end

  scope "/loyalty", LoyaltyApiWeb do
    pipe_through(:customer)

    post("/points/redeem/:code", LoyaltyController, :redeem_points)
    post("/coupon/claim/:uid", LoyaltyController, :claim_coupon)
    get("/transactions", LoyaltyController, :get_transactions)
  end

  scope "/accounts", LoyaltyApiWeb do
    pipe_through(:api)

    post("/customer", AccountsController, :create_customer)
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
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: LoyaltyApiWeb.Telemetry)
    end
  end
end
