defmodule CycleWeb.ClientSecretPlug do
  import Plug.Conn

  def init(_), do: client_secret()

  def call(conn, secret) do
    if get_req_header(conn, "secret") == [secret] do
      conn
    else
      conn
      |> resp(:unauthorized, "invalid client secret")
      |> halt()
    end
  end

  defp client_secret() do
    Application.get_env(:cycle_server, :client_secret)
  end
end
