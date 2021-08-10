defmodule LoyaltyApi.Factory do
  @moduledoc """
  Factory utility to easily build structs and insert DB records for testing porpuses.
  """
  alias LoyaltyApi.Repo
  # Factories

  def build(:customer) do
    %LoyaltyApi.Accounts.Customer{
      name: "Customer #{System.unique_integer()}",
      email: "valid_#{System.unique_integer()}@email.com",
      phone_number: "+00 00#{System.unique_integer()}-000",
      language: "en"
    }
  end

  def build(:brand) do
    %LoyaltyApi.Accounts.Brand{
      name: "Brand #{System.unique_integer()}"
    }
  end

  def build(:coupon) do
    %LoyaltyApi.Loyalty.Coupon{
      description: "Super great 20% discount",
      cost: 42
    }
  end

  def build(:coupon_transaction) do
    coupon = insert!(:coupon)

    %LoyaltyApi.Loyalty.Transaction{
      blockchain_details: %{
        "amount" => 65,
        "operation" => "debit",
        "timestamp" => 1_628_538_970_737,
        "user_uid" => "60791adc-1527-487e-a14f-f7343227b4d7"
      },
      hash: "HASH#{coupon.id}",
      operation: :claim_coupon,
      entity_id: coupon.id
    }
  end

  def build(:points_transaction) do
    points = insert!(:points, %{code: "CODE#{System.unique_integer()}"})

    %LoyaltyApi.Loyalty.Transaction{
      blockchain_details: %{
        "amount" => 65,
        "operation" => "credit",
        "timestamp" => 1_628_538_970_737,
        "user_uid" => "60791adc-1527-487e-a14f-f7343227b4d7"
      },
      hash: "HASH#{points.id}",
      operation: :claim_coupon,
      entity_id: points.id
    }
  end

  def build(:points) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    future = %{now | day: now.day + 10}

    %LoyaltyApi.Loyalty.Points{
      amount: System.unique_integer([:positive]),
      code: "CODE12345",
      expiration_date: future,
      redeemed: false
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
