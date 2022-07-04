defmodule Cycle.Repo do
  use Ecto.Repo,
    otp_app: :cycle_server,
    adapter: Ecto.Adapters.Postgres
end
