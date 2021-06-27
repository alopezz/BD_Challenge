defmodule ContactInfoWeb.ContactInfoController do
  use ContactInfoWeb, :controller

  alias ContactInfo.{Repo, Contact}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"case_id" => case_id}) do
    import Ecto.Query

    contact_info = Repo.one(from c in Contact, where: c.case_id == ^case_id)

    fields = [
      case_id: "Case ID",
      title: "Title",
      first_name: "First Name",
      last_name: "Last Name",
      mobile_phone_number: "Mobile Phone Number",
      address: "Address"
    ]

    case_data = for {key, text} <- fields do
      {key, %{field_name: text, value: Map.get(contact_info, key)}}
    end
    
    render(conn, "case.html", case_data: case_data)
  end

  def new(conn, _params) do
    fields = [
      case_id: "Case ID",
      title: "Title",
      first_name: "First Name",
      last_name: "Last Name",
      mobile_phone_number: "Mobile Phone Number",
      address: "Address"
    ]

    render(conn, "new_case.html", fields: fields)
  end

  def create(conn, %{"contact_info" => contact_info}) do
    Repo.insert(struct(%Contact{},
      for {key, val} <- contact_info, into: %{} do
	{String.to_atom(key), val}
      end
    ))
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def update(conn, %{"case_id" => case_id}) do
    IO.inspect(conn.body_params)
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def delete(conn, %{"case_id" => case_id}) do
    redirect(conn, to: Routes.contact_info_path(conn, :index))
  end

  def search(conn, %{"form_info" => %{"case_id" => case_id}}) do
    redirect(conn, to: Routes.contact_info_path(conn, :show, case_id))
  end
end
