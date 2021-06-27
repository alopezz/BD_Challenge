defmodule ContactInfoWeb.JwtAuthPlug do
  import Plug.Conn
  alias ContactInfoWeb.JwtAuthToken

  def init(opts), do: opts

  def call(conn, _opts) do
    decoded = conn
    |> bearers_from_header
    |> Enum.map(&JwtAuthToken.decode/1)
    |> Enum.find(fn
      {:ok, _} -> true
      _ -> false
    end)

    case decoded do
      nil -> forbidden(conn) 
      claims -> success(conn, claims)
    end
  end

  defp success(conn, claims) do
    assign(conn, :claims, claims)
  end

  defp forbidden(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.put_view(ContactInfoWeb.ErrorView)
    |> Phoenix.Controller.render("401.html")
    |> halt
  end


  # Return a list with the bearer tokens in the headers.
  defp bearers_from_header(conn) do
    Enum.reduce(conn.req_headers, [], fn header, acc ->
      case header do
	{"authorization", value} ->
	  case String.split(value) do
	    ["Bearer", token] -> [token | acc]
	    _ -> acc
	  end
	_ -> acc
      end
    end)
  end
  
end
