defmodule LoyaltyApi.Repo.Migrations.AddEntityIdToTransactionsTable do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add(:entity_id, :binary_id)
    end

    rename(table(:transactions), :details, to: :blockchain_details)
  end
end
