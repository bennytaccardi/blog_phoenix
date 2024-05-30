defmodule BlogPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BlogPhoenixWeb.Telemetry,
      BlogPhoenix.Repo,
      {DNSCluster, query: Application.get_env(:blog_phoenix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BlogPhoenix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BlogPhoenix.Finch},
      # Start a worker by calling: BlogPhoenix.Worker.start_link(arg)
      # {BlogPhoenix.Worker, arg},
      # Start to serve requests, typically the last entry
      BlogPhoenixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlogPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlogPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
