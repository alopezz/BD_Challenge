defmodule ContactInfoWeb.LogPlug do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, &log_changes/1)
  end

  def log_changes(conn) do
    user_id = case Map.get(conn.assigns, :claims) do
		nil -> "Unknown"
		{:ok, claims} -> claims["sub"]["id"]
	      end

    change_description = case Map.get(conn.assigns, :change_description) do
			   %{op: :create, case_id: case_id, changes: changes} ->
			     "created #{case_id} with fields #{field_names(changes)}"
			   %{op: :update, case_id: case_id, changes: changes} ->
			     "updated #{case_id}, affecting fields #{field_names(changes)}"
			   %{op: :read, case_id: case_id} ->
			     "read #{case_id}"
			   %{op: :delete, case_id: case_id} ->
			     "deleted #{case_id}"
			   _ -> nil
			 end

    # This could be replaced by calls to an external service sending the same
    # information.
    if change_description do
      Logger.info("User with ID #{user_id} #{change_description}")
    end

    conn
  end

  defp field_names(changes) do
    Map.keys(changes)
    |> Enum.join(", ")
  end

end
