defmodule LoyaltyApi.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string

      timestamps()
    end

  end
end
