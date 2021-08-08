defmodule LoyaltyApi.Loyalty.Points do
  use LoyaltyApi.EctoSchema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          amount: integer(),
          code: String.t(),
          expiration_date: DateTime.t(),
          redeemed: boolean()
        }

  schema "points" do
    field(:amount, :integer)
    field(:code, :string)
    field(:expiration_date, :utc_datetime)
    field(:redeemed, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(points, attrs) do
    points
    |> cast(attrs, [:code, :amount, :expiration_date, :redeemed])
    |> validate_required([:code, :amount, :expiration_date, :redeemed])
    |> unique_constraint(:code)
  end
end
