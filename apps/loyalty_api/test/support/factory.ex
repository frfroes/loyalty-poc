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

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
