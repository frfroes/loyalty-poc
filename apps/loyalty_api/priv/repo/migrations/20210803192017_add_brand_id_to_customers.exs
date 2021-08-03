defmodule LoyaltyApi.Repo.Migrations.AddBrandIdToCustomers do
  use Ecto.Migration

  def change do
    alter table(:customers) do
      add(:brand_id, references(:brands))
    end
  end
end
