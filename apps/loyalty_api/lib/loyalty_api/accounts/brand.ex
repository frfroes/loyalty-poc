defmodule LoyaltyApi.Accounts.Brand do
  use LoyaltyApi.EctoSchema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          name: String.t()
        }

  schema "brands" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
