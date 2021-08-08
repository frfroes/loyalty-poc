defmodule LoyaltyApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:hash, :string)
      add(:operation, :string)
      add(:details, :map)
      add(:customer_id, references(:customers))

      timestamps()
    end

    create(unique_index(:transactions, [:hash]))
  end
end
