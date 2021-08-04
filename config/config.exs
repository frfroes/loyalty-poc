# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :loyalty_api,
  ecto_repos: [LoyaltyApi.Repo]

config :loyalty_api,
       LoyaltyApi.Repo,
       migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :loyalty_api, LoyaltyApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MMBDKl36I/g9tLcio/u2K07YN+he6cyipnZzPzHFAut5YThFLTLvI+YwXNjzF9oZ",
  render_errors: [view: LoyaltyApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: LoyaltyApi.PubSub,
  live_view: [signing_salt: "G8HHdDWW"]

config :blockchain,
  ecto_repos: [Blockchain.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
