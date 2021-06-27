defmodule ContactInfoWeb.ContactInfoController do
  use ContactInfoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"case_id" => case_id}) do
    case_data = [
      case_id: %{field_name: "Case ID", value: case_id},
      title: %{field_name: "Title", value: "Herr"},
      first_name: %{field_name: "First Name", value: "Mark"},
      last_name: %{field_name: "Last Name", value: "Schmidt"},
      mobile_phone_number: %{field_name: "Mobile Phone Number: ", value: "123456789"},
      address: %{field_name: "Address", value: "Some Street, in some city and some number"}
    ]

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

  def create(conn, _params) do
    IO.inspect(conn.body_params)
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
