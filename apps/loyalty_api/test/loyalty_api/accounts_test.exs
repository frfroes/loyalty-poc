defmodule LoyaltyApi.AccountsTest do
  use LoyaltyApi.DataCase
  import LoyaltyApi.Factory

  alias LoyaltyApi.Accounts
  alias LoyaltyApi.Accounts.Customer

  describe "get_customer/1" do
    test "returns the customer with given id" do
      customer = insert!(:customer)
      assert Accounts.get_customer(customer.id) == customer
    end

    test "returns nil when user is not found" do
      fake_id = Ecto.UUID.generate()
      assert Accounts.get_customer(fake_id) == nil
    end
  end

  describe "create_customer/1" do
    defp valid_attrs() do
      brand = insert!(:brand)

      %{
        name: "Bruce Dickson",
        email: "bruce.dickson@ironmainden.com",
        phone_number: "+66 666-666",
        language: "en",
        brand_id: brand.id
      }
    end

    test "with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} =
               valid_attrs()
               |> Accounts.create_customer()

      assert customer.name == "Bruce Dickson"
      assert customer.email == "bruce.dickson@ironmainden.com"
      assert customer.phone_number == "+66 666-666"
      assert customer.language == "en"
    end

    test "with missing data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               valid_attrs()
               |> Map.drop([:brand_id])
               |> Accounts.create_customer()

      assert errors_on(changeset) == %{brand_id: ["can't be blank"]}
    end

    test "with invalid email returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               valid_attrs()
               |> Map.put(:email, "crazy mail")
               |> Accounts.create_customer()

      assert errors_on(changeset) == %{email: ["has invalid format"]}
    end

    test "with invalid phone number returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} =
               valid_attrs()
               |> Map.put(:phone_number, "191AABC1232")
               |> Accounts.create_customer()

      assert errors_on(changeset) == %{phone_number: ["has invalid format"]}
    end
  end
end
