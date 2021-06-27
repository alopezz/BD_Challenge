# ContactInfo

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Auth

The public key for authentication can be set with the environment variable
`PUBLIC_PEM`. This must be set for the `prod` environment.

In the `dev` environment, a default public key is used for authentication if none is
provided. Also, it's possible to disable authentication by setting the `SKIP_AUTH`
variable.
