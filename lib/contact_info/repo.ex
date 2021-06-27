defmodule ContactInfo.Repo do
  use Ecto.Repo,
    otp_app: :contact_info,
    adapter: Ecto.Adapters.Postgres
end
