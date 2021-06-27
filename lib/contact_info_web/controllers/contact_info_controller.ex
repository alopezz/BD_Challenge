defmodule ContactInfoWeb.ContactInfoController do
  use ContactInfoWeb, :controller

  alias ContactInfo.{Repo, Contact}

  @fields [
      case_id: "Case ID",
      title: "Title",
      first_name: "First Name",
      last_name: "Last Name",
      mobile_phone_number: "Mobile Phone Number",
      address: "Address"
    ]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"case_id" => case_id}) do
    contact_info = fetch_case_id(case_id)
    case_data = for {key, text} <- @fields do
      {key, %{field_name: text, value: Map.get(contact_info, key)}}
    end
    
    render(conn, "case.html", case_data: case_data)
  end

  def new(conn, _params) do
    render(conn, "new_case.html", fields: @fields)
  end

  def create(conn, %{"contact_info" => contact_info}) do
    Repo.insert(struct(%Contact{},
      for {key, val} <- contact_info, into: %{} do
	{String.to_atom(key), val}
      end
    ))
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def update(conn, %{"case_id" => case_id, "contact_info" => updated_contact_info}) do
    contact_info = fetch_case_id(case_id)
    Repo.update(Contact.changeset(contact_info, updated_contact_info))
    
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def delete(conn, %{"case_id" => case_id}) do
    Repo.delete(fetch_case_id(case_id))
    
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def search(conn, %{"form_info" => %{"case_id" => case_id}}) do
    redirect(conn, to: Routes.contact_info_path(conn, :show, case_id))
  end

  defp fetch_case_id(case_id) do
    import Ecto.Query
    Repo.one(from c in Contact, where: c.case_id == ^case_id)
  end
end
