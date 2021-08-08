defmodule LoyaltyApi.Loyalty.Transaction do
  use LoyaltyApi.EctoSchema
  import Ecto.Changeset
  alias LoyaltyApi.Accounts.Customer

  @operation_values [
    :redeem_points
  ]

  schema "transactions" do
    field(:details, :map)
    field(:hash, :string)
    field(:operation, Ecto.Enum, values: @operation_values)

    belongs_to(:customer, Customer, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:hash, :details, :operation, :customer_id])
    |> validate_required([:hash, :details, :operation, :customer_id])
    |> unique_constraint(:hash)
  end
end
