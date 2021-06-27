defmodule ContactInfo.ContactEntries do

  alias ContactInfo.{Repo, Contact}

  @fields [
    case_id: "Case ID",
    title: "Title",
    first_name: "First Name",
    last_name: "Last Name",
    mobile_phone_number: "Mobile Phone Number",
    address: "Address"
  ]

  @doc """
  Returns the contact info for a given case id.
  """
  def fetch_entry(case_id) do
    import Ecto.Query
    Repo.one(from c in Contact, where: c.case_id == ^case_id)
  end

  @doc """
  Creates a new entry.
  """
  def create_entry(contact_info) do
    Repo.insert(
      struct(%Contact{},
	for {key, val} <- contact_info, into: %{} do
	    {String.to_atom(key), val}
	end)
    )
  end

  @doc """
  Updates an existing entry.
  """
  def update_entry(case_id, new_contact_info) do
    contact_info = fetch_entry(case_id)
    Repo.update(Contact.changeset(contact_info, new_contact_info))
  end

  @doc """
  Deletes an entry.
  """
  def delete_entry(case_id) do
    Repo.delete(fetch_entry(case_id))
  end

  @doc """
  Returns a keyword list associating field keys to readable names
  """
  def fields() do
    @fields
  end

end
