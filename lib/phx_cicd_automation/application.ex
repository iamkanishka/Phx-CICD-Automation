defmodule PhxCicdAutomation.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhxCicdAutomationWeb.Telemetry,
      PhxCicdAutomation.Repo,
      {DNSCluster, query: Application.get_env(:phx_cicd_automation, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhxCicdAutomation.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhxCicdAutomation.Finch},
      # Start a worker by calling: PhxCicdAutomation.Worker.start_link(arg)
      # {PhxCicdAutomation.Worker, arg},
      # Start to serve requests, typically the last entry
      PhxCicdAutomationWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhxCicdAutomation.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhxCicdAutomationWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
