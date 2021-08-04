defmodule Blockchain.Balance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "balance" do
    field(:funds, :integer)
    field(:user_uid, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(balance, attrs) do
    balance
    |> cast(attrs, [:user_uid, :funds])
    |> validate_required([:user, :funds])
    |> unique_constraint(:user_uid)
  end
end
