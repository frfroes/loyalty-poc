defmodule LoyaltyApi.Loyalty.Transaction do
  use LoyaltyApi.EctoSchema
  import Ecto.Changeset
  alias LoyaltyApi.Accounts.Customer

  @type t :: %__MODULE__{
          blockchain_details: map(),
          hash: String.t(),
          operation: :redeem_points | :claim_coupon,
          entity_id: Ecto.UUID.t(),
          points: map(),
          coupon: map(),
          customer_id: Ecto.UUID.t()
        }

  @operation_values [
    :redeem_points,
    :claim_coupon
  ]

  schema "transactions" do
    field(:blockchain_details, :map)
    field(:hash, :string)
    field(:operation, Ecto.Enum, values: @operation_values)
    field(:entity_id, :binary_id)

    field(:points, :map, virtual: true)
    field(:coupon, :map, virtual: true)

    belongs_to(:customer, Customer, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:hash, :blockchain_details, :operation, :customer_id, :entity_id])
    |> validate_required([:hash, :blockchain_details, :operation, :customer_id])
    |> unique_constraint(:hash)
  end
end
