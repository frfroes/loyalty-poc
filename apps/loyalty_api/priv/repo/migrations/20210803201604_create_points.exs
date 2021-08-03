defmodule LoyaltyApi.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :code, :string
      add :amount, :integer
      add :expiration_date, :utc_datetime
      add :redeemed, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:points, [:code])
  end
end
