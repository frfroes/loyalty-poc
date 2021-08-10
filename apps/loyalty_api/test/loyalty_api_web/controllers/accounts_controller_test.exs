defmodule LoyaltyApiWeb.AccountsControllerTest do
  use LoyaltyApiWeb.ConnCase

  import LoyaltyApi.Factory
  alias LoyaltyApi.Accounts
  alias LoyaltyApi.Repo

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "POST /accouts/customer" do
    test "renders created payload when is succefull", %{conn: conn} do
      brand = insert!(:brand)

      payload = """
        {
          "email": "fr.froes3@gmail.com",
          "name": "filipe",
          "language": "en",
          "phone_number": "+356 5567",
          "brand_id": "#{brand.id}"
        }
      """

      path = Routes.accounts_path(conn, :create_customer, Jason.decode!(payload))
      conn = post(conn, path, nil)

      assert %{
               "data" => %{
                 "customer" => %{
                   "brand_id" => _,
                   "email" => _,
                   "id" => user_id,
                   "language" => "en",
                   "name" => _,
                   "phone_number" => _
                 }
               },
               "message" => "Customer registred"
             } = json_response(conn, 200)

      assert %Accounts.Customer{} = Repo.get(Accounts.Customer, user_id)
    end

    test "renders error paylod when payload is invalid", %{conn: conn} do
      payload = """
        {
          "email": "invalid email",
          "name": "filipe",
          "language": "en",
          "phone_number": "+356 5567"
        }
      """

      path = Routes.accounts_path(conn, :create_customer, Jason.decode!(payload))
      conn = post(conn, path, nil)

      assert %{
               "errors" => %{
                 "brand_id" => ["can't be blank"],
                 "email" => ["has invalid format"]
               }
             } = json_response(conn, 400)
    end
  end
end
