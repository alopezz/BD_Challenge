use Mix.Config

# Configure your database
config :contact_info, ContactInfo.Repo,
  username: "postgres",
  password: "postgres",
  database: "contact_info_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :contact_info, ContactInfoWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :contact_info, ContactInfoWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/contact_info_web/(live|views)/.*(ex)$",
      ~r"lib/contact_info_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure authentication
auth_required = !System.get_env("SKIP_AUTH")
config :contact_info, :auth_required, auth_required

default_public_pem = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2osnYa7m59V5TSCFURXOdtjGP8CEZdMZ5ptN1ZEN8mwPhi1sfhR9XGlfsl6YjkGlaz2yBreJ4q/sTL6yARea9z7iZOoMzDXj/nAWWEUuI5TJ/vkNMprUMjBd+XfH2hBDCQM3l+9sq6Ovthoxb9/2pfTmuc+k30XR41GBv3F694KSNrpDtbQABRYJNsuU2QMP1xgPst7ceBvShQic4a8sW+c8xuDO8LUvPudVG7z/Azvzj4nJjsfAkCCUpTKLJmDhWu22TMYxWY/zussxjurdUMptQuNDYP/QrIStJsZokvCBgtHvTgZ/rCw5oe3XYhxXEOfO0qTKKt/D8yf9faRRzwIDAQAB
-----END PUBLIC KEY-----
"""

config :contact_info, :public_pem, System.get_env("PUBLIC_PEM", default_public_pem)
