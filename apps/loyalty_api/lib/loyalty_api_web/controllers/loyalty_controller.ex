defmodule LoyaltyApiWeb.LoyaltyController do
  use LoyaltyApiWeb, :controller

  alias LoyaltyApiWeb.ErrorHelpers
  alias LoyaltyApi.Loyalty
  alias LoyaltyApi.Repo

  action_fallback(LoyaltyApiWeb.FallbackController)

  def redeem_points(conn, %{"code" => code}) do
    customer = conn.assigns.customer

    case Loyalty.redeem_points(customer, code) do
      {:ok, {points, hash}} ->
        render(conn, "index.json", message: "Points redeemed", points: points, hash: hash)

      {:error, error} ->
        ErrorHelpers.render_error(conn, error)
    end
  end

  def claim_coupon(conn, %{"uid" => uid}) do
    customer = conn.assigns.customer

    with {:ok, coupon} <- find_coupon(uid),
         {:ok, {claimed_coupon, hash}} <- Loyalty.claim_coumpon(customer, coupon) do
      render(conn, "index.json", message: "Coupon claimed", coupon: claimed_coupon, hash: hash)
    else
      {:error, error} ->
        ErrorHelpers.render_error(conn, error)
    end
  end

  def get_transactions(conn, _params) do
    customer = conn.assigns.customer
    transactions = Loyalty.list_transactions_by(%{customer_uid: customer.id})
    render(conn, "index.json", transactions: transactions)
  end

  defp find_coupon(uid) do
    case Repo.get(Loyalty.Coupon, uid) do
      nil -> {:error, :coupon_not_found}
      coupon -> {:ok, coupon}
    end
  rescue
    _ -> {:error, :ivalid_uid}
  end
end
