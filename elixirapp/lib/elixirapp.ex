defmodule Elixirapp.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Elixirapp.FluentdLogger, name: FluentdLogger},
      {Plug.Cowboy, scheme: :http, plug: Elixirapp.HttpServer, options: [port: 8080]}
    ]
    opts = [strategy: :one_for_one, name: Elixirapp.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
