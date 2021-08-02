defmodule LoyaltyApi.Repo do
  use Ecto.Repo,
    otp_app: :loyalty_api,
    adapter: Ecto.Adapters.Postgres
end
