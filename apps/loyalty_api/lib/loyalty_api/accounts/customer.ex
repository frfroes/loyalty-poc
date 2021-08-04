defmodule LoyaltyApi.Accounts.Customer do
  use LoyaltyApi.EctoSchema
  import Ecto.Changeset

  alias LoyaltyApi.Accounts.Brand

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          email: String.t(),
          language: String.t(),
          name: String.t(),
          phone_number: String.t()
        }

  schema "customers" do
    field(:email, :string)
    field(:language, :string)
    field(:name, :string)
    field(:phone_number, :string)

    belongs_to(:brand, Brand, type: :binary_id)

    timestamps()
  end

  @email_regex ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  @phone_number_regex ~r/^(?=.*[0-9])[- +()0-9]+$/

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone_number, :language, :brand_id])
    |> validate_required([:name, :email, :phone_number, :language, :brand_id])
    |> unique_constraint(:email)
    |> validate_format(:email, @email_regex)
    |> validate_format(:phone_number, @phone_number_regex)
  end
end
