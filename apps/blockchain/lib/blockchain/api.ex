defmodule Blockchain.API do
  @moduledoc """
  This module defines the API behaviour of a blockchain implementation
  """
  @type operation :: :credit | :debit
  @type errors :: :invalid_args | :invalid_user_uid | :user_not_found | :not_enough_funds
  @type transaction_hash :: {map(), binary()}

  @doc """
  Runs a transaction in the blockchain crediting or debiting to an user's funds.
  """
  @callback run_transaction(
              operation :: operation(),
              user_uid :: Ecto.UUID.t(),
              amount :: integer()
            ) ::
              {:ok, transaction_hash()} | {:error, errors()}

  @doc """
  Gets funds of a uses balance by it's uid
  """
  @callback get_user_balance(user_uid :: Ecto.UUID.t()) ::
              {:ok, {Ecto.UUID.t(), integer()}} | {:error, errors()}
end
