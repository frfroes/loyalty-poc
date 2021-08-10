defmodule LoyaltyApiWeb.AccountsController do
  use LoyaltyApiWeb, :controller

  alias LoyaltyApiWeb.ErrorHelpers
  alias LoyaltyApi.Accounts

  action_fallback(LoyaltyApiWeb.FallbackController)

  def create_customer(conn, payload) do
    case Accounts.create_customer(payload) do
      {:ok, customer} ->
        render(conn, "index.json", message: "Customer registred", customer: customer)

      {:error, error} ->
        ErrorHelpers.render_error(conn, error)
    end
  end
end
