defmodule Elixirapp.FluentdLogger do
  use GenServer
  @port Application.get_env(:elixirapp, :logger_port)

  defp send_data(socket, tag, data) do
    {mili, sec, _} = :os.timestamp()
    data = Msgpax.pack!([tag, mili * 1_000_000 + sec, data])
    Socket.Stream.send!(socket, data)
  end

  def start() do
    GenServer.start(Elixirapp.FluentdLogger, [], name: __MODULE__)
  end

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_initial) do
    socket = Socket.TCP.connect!("localhost", @port, packet: 0)
    {:ok, socket}
  end

  @impl true
  def handle_cast({:send, tag, data}, socket) do
    send_data(socket, tag, data)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:udp, _socket, _host, _port, _data}, socket) do
    {:noreply, socket}
  end

  def log(tag, data) do
    GenServer.cast(Elixirapp.FluentdLogger, {:send, tag, data})
  end
end
