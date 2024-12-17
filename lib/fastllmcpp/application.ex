defmodule Fastllmcpp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FastllmcppWeb.Telemetry,
      Fastllmcpp.Repo,
      {DNSCluster, query: Application.get_env(:fastllmcpp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Fastllmcpp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Fastllmcpp.Finch},
      # Start a worker by calling: Fastllmcpp.Worker.start_link(arg)
      # {Fastllmcpp.Worker, arg},
      # Start to serve requests, typically the last entry
      FastllmcppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fastllmcpp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FastllmcppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
