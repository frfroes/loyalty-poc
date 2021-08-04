defmodule Blockchain.Repo do
  use Ecto.Repo,
    otp_app: :blockchain,
    adapter: Ecto.Adapters.Postgres
end
