defmodule LoyaltyApi.Loyalty do
  @moduledoc """
  The Loyalty context.
  """

  import Ecto.Query, warn: false
  alias LoyaltyApi.Repo

  alias LoyaltyApi.Loyalty.Points
  alias LoyaltyApi.Accounts.Customer

  @valid_code ~r/^[a-zA-Z0-9]+$/

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
         :ok <- credit_points(customer, points),
         {:ok, points} <- set_as_redeemed(points) do
      {:ok, points}
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

  defp credit_points(%Customer{} = _customer, %Points{} = _points) do
    # Will credito points to user throught the blockchain
    :ok
  end

  defp set_as_redeemed(%Points{} = points) do
    points
    |> Points.changeset(%{redeemed: true})
    |> Repo.update()
  end
end
