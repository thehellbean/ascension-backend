defmodule Ascension.Repo do
  use Ecto.Repo,
    otp_app: :ascension,
    adapter: Ecto.Adapters.Postgres
end
