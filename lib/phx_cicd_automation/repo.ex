defmodule PhxCicdAutomation.Repo do
  use Ecto.Repo,
    otp_app: :phx_cicd_automation,
    adapter: Ecto.Adapters.Postgres
end
