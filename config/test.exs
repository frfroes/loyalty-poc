use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :loyalty_api, LoyaltyApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "loyalty_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :loyalty_api, LoyaltyApiWeb.Endpoint,
  http: [port: 4002],
  server: false

config :blockchain, Blockchain.Repo,
  username: "postgres",
  password: "postgres",
  database: "blockchain_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
