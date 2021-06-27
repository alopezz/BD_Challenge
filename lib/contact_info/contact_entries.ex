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
    changeset = Contact.changeset(%Contact{},
      for {key, val} <- contact_info, into: %{} do
	{String.to_atom(key), val}
      end)
    apply_upsert_changeset(changeset, &Repo.insert/1, :create)
  end

  @doc """
  Updates an existing entry.
  """
  def update_entry(case_id, new_contact_info) do
    contact_info = fetch_entry(case_id)
    changeset = Contact.changeset(contact_info, new_contact_info)
    apply_upsert_changeset(changeset, &Repo.update/1, :update)
  end

  defp apply_upsert_changeset(changeset, func, op) do
    case func.(changeset) do
      {:ok, created} -> {:ok, created.case_id, %{op: op, changes: changeset.changes}}
      {:error, ch} ->
	msg = case Keyword.get(ch.errors, :case_id) do
		nil -> "Unknown error"
		{err_msg, _} -> "Case ID #{err_msg}"
	      end
	{:error, msg}
    end
  end

  @doc """
  Deletes an entry.
  """
  def delete_entry(case_id) do
    case fetch_entry(case_id) do
      nil -> {:error, "Case ID #{case_id} doesn't exist"}
      contact_info ->
	Repo.delete(contact_info)
	{:ok, case_id, %{op: :delete}}
    end
  end

  @doc """
  Returns a keyword list associating field keys to readable names
  """
  def fields() do
    @fields
  end

end
