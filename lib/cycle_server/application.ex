defmodule Cycle.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Cycle.Repo,
      # Start the Telemetry supervisor
      CycleWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cycle.PubSub},
      {Finch, name: CycleFinch},
      # Start the Endpoint (http/https)
      CycleWeb.Endpoint
      # Start a worker by calling: Cycle.Worker.start_link(arg)
      # {Cycle.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cycle.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CycleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
