defmodule CycleWeb.ClientSecretPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(_) do
  end

  def call(conn, _) do
    secret = client_secret()

    if get_req_header(conn, "secret") == [secret] do
      conn
    else
      conn
      |> json(%{error: "invalid client secret"})
      |> put_status(:unauthorized)
      |> halt()
    end
  end

  defp client_secret() do
    Application.get_env(:cycle_server, :client_secret)
  end
end
