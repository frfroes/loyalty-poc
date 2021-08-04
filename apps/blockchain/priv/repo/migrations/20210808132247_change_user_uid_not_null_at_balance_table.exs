defmodule Blockchain.Repo.Migrations.ChangeUserUidNotNullAtBalanceTable do
  use Ecto.Migration

  def change do
    alter table(:balance) do
      modify(:user_uid, :uuid, null: false)
    end
  end
end
