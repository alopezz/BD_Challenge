# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :contact_info,
  ecto_repos: [ContactInfo.Repo]

# Configures the endpoint
config :contact_info, ContactInfoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BSG4+Eyc/cjIQx/5u22rSxNuqCuQ9U2k2N3b8N4pEVrZOFQLdL0boLz/RL8HlwFP",
  render_errors: [view: ContactInfoWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ContactInfo.PubSub,
  live_view: [signing_salt: "dR4kDyeu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
