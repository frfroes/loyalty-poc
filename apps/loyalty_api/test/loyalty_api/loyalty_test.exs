defmodule LoyaltyApi.LoyaltyTest do
  use LoyaltyApi.DataCase
  import LoyaltyApi.Factory

  alias LoyaltyApi.Loyalty
  alias LoyaltyApi.Loyalty.Points

  describe "redeem_points/1" do
    test "when all is valid point is redeemed" do
      customer = build(:customer)
      points = insert!(:points)
      assert {:ok, %Points{} = redeemed_points} = Loyalty.redeem_points(customer, points.code)
      assert redeemed_points.id == points.id
      assert redeemed_points.redeemed
    end

    test "returns error when code is invalid" do
      customer = build(:customer)
      assert {:error, :code_not_valid} = Loyalty.redeem_points(customer, "123")
      assert {:error, :code_not_valid} = Loyalty.redeem_points(customer, "0123456789")
      assert {:error, :code_not_valid} = Loyalty.redeem_points(customer, "*&^#@1234")
      assert {:error, :code_not_valid} = Loyalty.redeem_points(customer, 123_456_789)
    end

    test "returns error when points is invalid" do
      customer = build(:customer)
      assert {:error, :not_found} = Loyalty.redeem_points(customer, "123456789")
      points = insert!(:points, code: "REDEEMED9", redeemed: true)
      assert {:error, :already_used} = Loyalty.redeem_points(customer, points.code)
      points = insert!(:points, code: "EXPIRED89", expiration_date: ~U[1995-08-13 21:57:30Z])
      assert {:error, :date_expired} = Loyalty.redeem_points(customer, points.code)
    end
  end
end
