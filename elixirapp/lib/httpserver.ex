defmodule Elixirapp.HttpServer do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    Elixirapp.FluentdLogger.log("fluentd.test.elixir", %{
      "ip" => parse_ip(conn.remote_ip),
      "path" => conn.path_info,
      "host" => conn.host,
      "method" => conn.method,
      "protocol" => conn.scheme
      })
    send_resp(conn, 200, "success")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end


  def parse_ip(ip) do
    Tuple.to_list(ip)
    |> Enum.map(fn octet -> Integer.to_string(octet) end)
    |> Enum.join(".")
  end
end
