# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pog,
  ecto_repos: [Pog.Repo],
  title: System.get_env("POG_TITLE", "Kalvad")

# Configures the endpoint
config :pog, PogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wExmU1axckPdY4NBtZVXif9AnbUvj4gb5Feb+nWqy/J5S304b91/gi3+Q5wK8dHG",
  render_errors: [view: PogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Pog.PubSub,
  live_view: [signing_salt: "+pFxIF60"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kaffy,
  admin_title: "Team",
  admin_logo: "/images/logo.png",
  admin_logo_mini: "/images/logo.png",
  home_page: [kaffy: :dashboard],
  otp_app: :pog,
  ecto_repo: Pog.Repo,
  router: PogWeb.Router

config :pog, Pog.Cldr,
  default_locale: "en",
  locales: ["fr", "en"],
  gettext: PogWeb.Gettext,
  data_dir: "./priv/cldr"

config :pog, Pog.Mailer, adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
