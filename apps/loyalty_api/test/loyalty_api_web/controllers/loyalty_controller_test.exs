defmodule LoyaltyApiWeb.LoyaltyControllerTest do
  use LoyaltyApiWeb.ConnCase

  import LoyaltyApi.Factory
  import Mox

  defp mock_transaction_hash(operation, user_uid, amount) do
    transaction = %{
      operation: operation,
      user_uid: user_uid,
      amount: amount,
      timestamp: :os.system_time(:millisecond)
    }

    {transaction, inspect(transaction)}
  end

  setup %{conn: conn} do
    customer = insert!(:customer)

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{customer.id}")

    {:ok, conn: conn}
  end

  describe "POST /points/redeem/:code" do
    test "renders redeemed payload when is succefull", %{conn: conn} do
      BlockchainMock
      |> expect(:run_transaction, fn operation, user_uid, amount ->
        {:ok, mock_transaction_hash(operation, user_uid, amount)}
      end)

      points = insert!(:points)
      path = Routes.loyalty_path(conn, :redeem_points, points.code)
      conn = post(conn, path, nil)

      assert %{
               "data" => %{
                 "points" => %{
                   "amount" => _,
                   "code" => _,
                   "expiration_date" => _,
                   "id" => points_id,
                   "redeemed" => true
                 },
                 "transacion_hash" => transacion_hash
               },
               "message" => "Points redeemed"
             } = json_response(conn, 200)

      assert points.id == points_id
      assert is_binary(transacion_hash)
    end

    test "renders error paylod when something is invalid", %{conn: conn} do
      points = insert!(:points, %{redeemed: true})
      path = Routes.loyalty_path(conn, :redeem_points, points.code)
      conn = post(conn, path, nil)

      assert %{"error" => "Already used"} = json_response(conn, 400)
    end
  end

  describe "POST /coupon/claim/:uid" do
    test "renders claimed payload when is succefull", %{conn: conn} do
      BlockchainMock
      |> expect(:run_transaction, fn operation, user_uid, amount ->
        {:ok, mock_transaction_hash(operation, user_uid, amount)}
      end)

      coupon = insert!(:coupon)
      path = Routes.loyalty_path(conn, :claim_coupon, coupon.id)
      conn = post(conn, path, nil)

      assert %{
               "data" => %{
                 "coupon" => %{
                   "cost" => _,
                   "description" => _,
                   "id" => coupon_id
                 },
                 "transacion_hash" => transacion_hash
               },
               "message" => "Coupon claimed"
             } = json_response(conn, 200)

      assert coupon.id == coupon_id
      assert is_binary(transacion_hash)
    end

    test "renders error paylod when something is invalid", %{conn: conn} do
      BlockchainMock
      |> expect(:run_transaction, fn _operation, _user_uid, _amount ->
        {:error, :not_enough_funds}
      end)

      coupon = insert!(:coupon)
      path = Routes.loyalty_path(conn, :claim_coupon, coupon.id)
      conn = post(conn, path, nil)

      assert %{"error" => "Not enough funds"} = json_response(conn, 400)
    end
  end

  describe "GET /transactions" do
    test "renders claimed payload when is succefull", %{conn: conn} do
      customer = insert!(:customer)
      insert!(:points_transaction, %{customer_id: customer.id})
      insert!(:coupon_transaction, %{customer_id: customer.id})

      path = Routes.loyalty_path(conn, :get_transactions)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{customer.id}")
        |> get(path, nil)

      assert %{
               "data" => [
                 %{
                   "blockchain_details" => _,
                   "customer_id" => _,
                   "entity_id" => _,
                   "hash" => _,
                   "id" => _,
                   "inserted_at" => _,
                   "operation" => _,
                   "points" => %{
                     "amount" => _,
                     "code" => _,
                     "expiration_date" => _,
                     "id" => _
                   }
                 },
                 %{
                   "blockchain_details" => _,
                   "coupon" => %{
                     "cost" => _,
                     "description" => _,
                     "id" => _
                   },
                   "customer_id" => _,
                   "entity_id" => _,
                   "hash" => _,
                   "id" => _,
                   "inserted_at" => _,
                   "operation" => _,
                   "updated_at" => _
                 }
               ]
             } = json_response(conn, 200)
    end
  end
end
