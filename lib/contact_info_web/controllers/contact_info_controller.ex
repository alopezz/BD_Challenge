defmodule ContactInfoWeb.ContactInfoController do
  use ContactInfoWeb, :controller

  alias ContactInfo.{Repo, Contact}
  import ContactInfo.ContactEntries

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"case_id" => case_id}) do
    contact_info = fetch_entry(case_id)
    case_data = for {key, text} <- fields() do
      {key, %{field_name: text, value: Map.get(contact_info, key)}}
    end
    
    render(conn, "case.html", case_data: case_data)
  end

  def new(conn, _params) do
    render(conn, "new_case.html", fields: fields())
  end

  def create(conn, %{"contact_info" => contact_info}) do
    create_entry(contact_info)
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def update(conn, %{"case_id" => case_id, "contact_info" => updated_contact_info}) do
    update_entry(case_id, updated_contact_info)
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def delete(conn, %{"case_id" => case_id}) do
    delete_entry(case_id)
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def search(conn, %{"form_info" => %{"case_id" => case_id}}) do
    redirect(conn, to: Routes.contact_info_path(conn, :show, case_id))
  end
end
