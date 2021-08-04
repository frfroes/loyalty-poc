defmodule Blockchain.Repo.Migrations.CreateBalance do
  use Ecto.Migration

  def change do
    create table(:balance) do
      add(:user_uid, :uuid)
      add(:funds, :integer)

      timestamps()
    end

    create(unique_index(:balance, [:user_uid]))
  end
end
