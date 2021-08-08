defmodule LoyaltyApi.LoyaltyTest do
  use LoyaltyApi.DataCase

  import LoyaltyApi.Factory
  import Mox

  alias LoyaltyApi.Loyalty
  alias LoyaltyApi.Loyalty.Points
  alias LoyaltyApi.Loyalty.Coupon
  alias LoyaltyApi.Loyalty.Transaction

  defp mock_transaction_hash(operation, user_uid, amount) do
    transaction = %{
      operation: operation,
      user_uid: user_uid,
      amount: amount,
      timestamp: :os.system_time(:millisecond)
    }

    {transaction, inspect(transaction)}
  end

  describe "redeem_points/1" do
    test "when all is valid point is redeemed" do
      customer = insert!(:customer)
      points = insert!(:points)

      BlockchainMock
      |> expect(:run_transaction, fn operation, user_uid, amount ->
        {:ok, mock_transaction_hash(operation, user_uid, amount)}
      end)

      assert {:ok, {%Points{} = redeemed_points, _hash}} =
               Loyalty.redeem_points(customer, points.code)

      assert redeemed_points.id == points.id
      assert redeemed_points.redeemed
    end

    test "when all is valid transaction is saved" do
      customer = insert!(:customer)
      points = insert!(:points)

      BlockchainMock
      |> expect(:run_transaction, fn operation, user_uid, amount ->
        {:ok, mock_transaction_hash(operation, user_uid, amount)}
      end)

      assert {:ok, {_point, hash}} = Loyalty.redeem_points(customer, points.code)

      assert %Transaction{} = transaction = Repo.get_by(Transaction, hash: hash)

      assert transaction.customer_id == customer.id
      assert transaction.operation == :redeem_points
      assert transaction.entity_id == points.id
      assert transaction.blockchain_details["amount"] == points.amount
      assert transaction.blockchain_details["operation"] == "credit"
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

  describe "claim_coumpon" do
    test "customer claims coumpon when all is valid" do
      customer = insert!(:customer)
      coumpon = insert!(:coupon)

      BlockchainMock
      |> expect(:run_transaction, fn operation, user_uid, amount ->
        {:ok, mock_transaction_hash(operation, user_uid, amount)}
      end)

      assert {:ok, {%Coupon{}, hash}} = Loyalty.claim_coumpon(customer, coumpon)

      assert %Transaction{} = transaction = Repo.get_by(Transaction, hash: hash)

      assert transaction.customer_id == customer.id
      assert transaction.operation == :claim_coupon
      assert transaction.entity_id == coumpon.id
      assert transaction.blockchain_details["amount"] == coumpon.cost
      assert transaction.blockchain_details["operation"] == "debit"
    end

    test "returns error when blockchain does not process transaction" do
      customer = build(:customer)
      coumpon = insert!(:coupon)

      BlockchainMock
      |> expect(:run_transaction, fn _operation, _user_uid, _amount ->
        {:error, :not_enough_funds}
      end)

      assert {:error, :not_enough_funds} = Loyalty.claim_coumpon(customer, coumpon)
    end
  end
end
