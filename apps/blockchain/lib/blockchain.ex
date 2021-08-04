defmodule Blockchain do
  @moduledoc """
  This module simulates the inputs and outputs of a blockchain and a little bit of its behaviour.

  This is **is not** a blockchain at all, it simply credits and or debits funds to a particular user and
  returns a transaction and a hash to simulate the outup of a blockchain.
  """
  alias Blockchain.Repo
  alias Blockchain.Balance

  @behaviour Blockchain.API

  defguard is_valid_amount(value) when is_integer(value) and value > 0

  @doc """
  Runs either a credit or a debit transaction to the a users balance.

  If it's a `:credit` operation and the user's balance doesn't exits, the balance it's created and credited the
  funds.

  ## Examples

      iex> Blockchain.run_transaction(:credit, user_uid, 42)
      {:ok, {
        %{amount: 42, operation: :credit, timestamp: 1628110636373, user_uid: "416e9f58-ac04-4e27-8385-860d439dba02"},
        "b35c66deeaf9bd98388c2d911c193842"
      }}

  """
  def run_transaction(:credit, user_uid, amount) when is_valid_amount(amount) do
    case credit_funds(user_uid, amount) do
      {:ok, %Balance{}} ->
        {:ok, transaction_hash(:credit, user_uid, amount)}

      error ->
        error
    end
  end

  def run_transaction(:debit, user_uid, amount) when is_valid_amount(amount) do
    case debit_funds(user_uid, amount) do
      {:ok, %Balance{}} ->
        {:ok, transaction_hash(:debit, user_uid, amount)}

      error ->
        error
    end
  end

  def run_transaction(_operation, _user_uid, _amount), do: {:error, :invalid_args}

  defp credit_funds(user_uid, amount) do
    %Balance{user_uid: user_uid, funds: amount}
    |> Repo.insert(on_conflict: [inc: [funds: amount]], conflict_target: :user_uid)
  rescue
    _ -> {:error, :invalid_user_uid}
  end

  defp debit_funds(user_uid, amount) do
    case Repo.get_by(Balance, user_uid: user_uid) do
      nil ->
        {:error, :user_not_found}

      balance ->
        if balance.funds - amount < 0 do
          {:error, :not_enough_funds}
        else
          credit_funds(user_uid, amount * -1)
        end
    end
  rescue
    _ -> {:error, :invalid_user_uid}
  end

  defp transaction_hash(operation, user_uid, amount) do
    transaction = %{
      operation: operation,
      user_uid: user_uid,
      amount: amount,
      timestamp: :os.system_time(:millisecond)
    }

    hash =
      :crypto.hash(:md5, inspect(transaction))
      |> Base.encode16(case: :lower)

    {transaction, hash}
  end

  @doc """
  Gets funds of a uses balance by it's uid
  """
  def get_user_balance(user_uid) do
    case Repo.get_by(Balance, user_uid: user_uid) do
      nil -> {:error, :user_not_found}
      %{funds: funds} -> {:ok, {user_uid, funds}}
    end
  rescue
    _ -> {:error, :invalid_user_uid}
  end
end
