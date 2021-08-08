defmodule LoyaltyApi.Loyalty.Coupon do
  use LoyaltyApi.EctoSchema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          cost: integer(),
          description: String.t()
        }

  schema "coupons" do
    field(:cost, :integer)
    field(:description, :string)

    timestamps()
  end

  @doc false
  def changeset(cupons, attrs) do
    cupons
    |> cast(attrs, [:cost, :description])
    |> validate_required([:cost, :description])
  end
end
