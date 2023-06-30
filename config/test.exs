import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :svg_island, SvgIslandWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "SeaOlNZuz3/O8BH5ZzGxgXkspV34UJOt7q/2Aq2KCq8VK7nFDM+PUZr/z9ntMPt2",
  server: false

# In test we don't send emails.
config :svg_island, SvgIsland.Mailer,
  adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
