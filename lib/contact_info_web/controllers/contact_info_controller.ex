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
	|> put_flash(:error, "Entry for Case ID #{case_id} not found.")
	|> redirect_home
      contact_info ->
	case_data = for {key, text} <- fields() do
	    {key, %{field_name: text, value: Map.get(contact_info, key)}}
	  end
	conn
	|> assign(:change_description, %{op: :read, case_id: case_id})
	|> render("case.html", case_data: case_data)
    end
  end

  def new(conn, _params) do
    render(conn, "new_case.html", fields: fields())
  end

  def create(conn, %{"contact_info" => contact_info}) do
    create_entry(contact_info)
    |> process_return_value(conn, &("Successfully created contact info for #{&1}."))
  end

  def update(conn, %{"case_id" => case_id, "contact_info" => updated_contact_info}) do
    update_entry(case_id, updated_contact_info)
    |> process_return_value(conn, &("Successfully updated contact info for #{&1}."))
  end

  def delete(conn, %{"case_id" => case_id}) do
    delete_entry(case_id)
    |> process_return_value(conn, &("Successfully deleted contact info for #{&1}."),
    redirect_success: Routes.contact_info_path(conn, :index))
  end

  defp process_return_value(rv, conn, success_msg_gen, opts \\ []) do
    case rv do
      {:ok, case_id, change_description} ->
	conn
	|> put_flash(:info, success_msg_gen.(case_id))
	|> assign(:change_description, Map.put(change_description, :case_id, case_id))
	|> redirect(to: Keyword.get(opts, :redirect_success, current_path(conn)))
      {:error, msg} ->
	conn
	|> put_flash(:error, msg)
	|> redirect(to: Keyword.get(opts, :redirect_error, current_path(conn)))
    end

  end
  
  def search(conn, %{"form_info" => %{"case_id" => case_id}}) do
    redirect(conn, to: Routes.contact_info_path(conn, :show, case_id))
  end

  defp redirect_home(conn) do
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

end
