defmodule LoyaltyApi.Repo.Migrations.CreateCoupons do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add(:cost, :integer)
      add(:description, :string)

      timestamps()
    end
  end
end
