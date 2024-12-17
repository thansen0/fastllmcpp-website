defmodule Fastllmcpp.Repo do
  use Ecto.Repo,
    otp_app: :fastllmcpp,
    adapter: Ecto.Adapters.Postgres
end
