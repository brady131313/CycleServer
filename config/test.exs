import Config

config :cycle_server,
  client_secret: "test_client_secret"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cycle_server, Cycle.Repo,
  username: "postgres",
  password: "password",
  hostname: "localhost",
  database: "cycle_server_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cycle_server, CycleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "6u37HogAQPk4qAgwH/myrHuGf2wbhJhPrpkHtlaEUDtDL3r0y+/1yBiY5NLOSX/i",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
