defmodule LoyaltyApiWeb.Plugs.CustomerAuth do
  @moduledoc """
  Plug to authenticate requests coming from the customer.
  """
  @behaviour Plug

  alias LoyaltyApi.Accounts
  alias LoyaltyApiWeb.ErrorHelpers

  import Plug.Conn

  require Logger

  def init(opts), do: opts

  def call(conn, _) do
    case get_current_user(conn) do
      {:ok, customer} ->
        assign(conn, :customer, customer)

      {:error, error} ->
        conn
        |> ErrorHelpers.render_error(error)
        |> halt()
    end
  end

  defp get_current_user(conn) do
    with ["Bearer " <> user_uid] <- get_req_header(conn, "authorization"),
         {:ok, user} <- find_customer_by(user_uid) do
      {:ok, user}
    end
  end

  defp find_customer_by(user_uid) do
    case Accounts.get_customer(user_uid) do
      nil ->
        {:error, "Customer not found"}

      customer ->
        {:ok, customer}
    end
  rescue
    _ -> {:error, "Invalid user token"}
  end
end
