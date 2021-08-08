defmodule LoyaltyApi.Loyalty do
  @moduledoc """
  The Loyalty context.
  """

  import Ecto.Query, warn: false
  alias LoyaltyApi.Repo

  alias LoyaltyApi.Loyalty.Points
  alias LoyaltyApi.Loyalty.Transaction
  alias LoyaltyApi.Accounts.Customer

  @valid_code ~r/^[a-zA-Z0-9]+$/
  defp blockchain, do: Application.get_env(:loyalty_api, :blockchain_api, Blockchain)

  @doc """
  Redeems `Points` by a `Customer` given it's code.

  Points can be redeemed given both the code and the points, it can only happen once and before their expiration date.
  If succfully redeemed they are credited to the Customer's account and marked as so.

  It returns the redeemed Points or a validation error.

  ## Examples

      iex> redeem_points(customer, code)
      {:ok, %Points{}}

  """
  @spec redeem_points(Customer.t(), String.t()) :: {:ok, Points.t()} | {:error, atom()}
  def redeem_points(customer, code) when is_binary(code) do
    with :ok <- validate_code(code),
         points <- Repo.get_by(Points, code: code),
         :ok <- validate_points(points),
         {:ok, transaction_hash} <-
           blockchain().run_transaction(:credit, customer.id, points.amount),
         {:ok, %{points: points, transaction: transaction}} <-
           save_transaction(points, transaction_hash) do
      {:ok, {points, transaction.hash}}
    end
  end

  def redeem_points(_user, _code), do: {:error, :code_not_valid}

  defp validate_code(code) do
    if String.match?(code, @valid_code) and String.length(code) == 9 do
      :ok
    else
      {:error, :code_not_valid}
    end
  end

  defp validate_points(points) do
    cond do
      is_nil(points) ->
        {:error, :not_found}

      points.redeemed ->
        {:error, :already_used}

      Date.compare(points.expiration_date, DateTime.utc_now()) == :lt ->
        {:error, :date_expired}

      true ->
        :ok
    end
  end

  # Even though I'm using a DB transaction here the name is more in the context of the entity `Transaction`.
  defp save_transaction(%Points{} = points, {blockchain_data, hash}) do
    transaction = %Transaction{
      customer_id: blockchain_data.user_uid,
      hash: hash,
      operation: :redeem_points,
      details: Map.put(blockchain_data, :code, points.code)
    }

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:transaction, Transaction.changeset(transaction, %{}))
    |> Ecto.Multi.update(:points, Points.changeset(points, %{redeemed: true}))
    |> Repo.transaction()
  end
end
