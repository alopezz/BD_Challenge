defmodule ContactInfoWeb.ContactInfoController do
  use ContactInfoWeb, :controller

  alias ContactInfo.{Repo, Contact}
  import ContactInfo.ContactEntries

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"case_id" => case_id}) do
    case fetch_entry(case_id) do
      nil ->
	conn
	|> put_flash(:error, "Case #{case_id} not found.")
	|> redirect_home
      contact_info ->
	case_data = for {key, text} <- fields() do
	    {key, %{field_name: text, value: Map.get(contact_info, key)}}
	  end
	render(conn, "case.html", case_data: case_data)
    end
  end

  def new(conn, _params) do
    render(conn, "new_case.html", fields: fields())
  end

  def create(conn, %{"contact_info" => contact_info}) do
    upsert(conn, create_entry(contact_info), &("Successfully created contact info for #{&1}."))
  end

  def update(conn, %{"case_id" => case_id, "contact_info" => updated_contact_info}) do
    upsert(conn, update_entry(case_id, updated_contact_info), &("Successfully updated contact info for #{&1}."))
  end

  defp upsert(conn, rv, success_msg_gen) do
    case rv do
      {:ok, case_id} ->
	conn
	|> put_flash(:info, success_msg_gen.(case_id))
      {:error, msg} ->
	conn
	|> put_flash(:error, msg)
    end
    |> redirect(to: current_path(conn))

  end

  def delete(conn, %{"case_id" => case_id}) do
    delete_entry(case_id)
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def search(conn, %{"form_info" => %{"case_id" => case_id}}) do
    redirect(conn, to: Routes.contact_info_path(conn, :show, case_id))
  end

  defp redirect_home(conn) do
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

end
