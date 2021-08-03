defmodule LoyaltyApi.Accounts do
  @moduledoc """
  The Accounts context.
  This context is responsible for handling the logic and expose the API of everything related to the accounts of the
  users of LoyaltyApi.
  """

  import Ecto.Query, warn: false
  alias LoyaltyApi.Repo

  alias LoyaltyApi.Accounts.Customer

  @doc """
  Gets a single customer.

  Returns `nil` if the Customer does not exist.

  ## Examples

      iex> get_customer!(123)
      %Customer{}

      iex> get_customer(456)
      nil

  """
  def get_customer(id), do: Repo.get(Customer, id)

  @doc """
  Creates a customer.

  ## Examples

      iex> create_customer(%{field: value})
      {:ok, %Customer{}}

      iex> create_customer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end
end
