defmodule BlockchainTest do
  use Blockchain.DataCase

  alias Blockchain.Repo
  alias Blockchain.Balance

  describe "run_transaction/3" do
    test "creates balance and adds funds non-existing user" do
      user_uid = Ecto.UUID.generate()
      refute Repo.get_by(Balance, user_uid: user_uid)
      Blockchain.run_transaction(:credit, user_uid, 42)
      assert %Balance{user_uid: ^user_uid} = Repo.get_by(Balance, user_uid: user_uid)
    end

    test "adds funds to existing user" do
      user_uid = Ecto.UUID.generate()

      Repo.insert!(%Balance{
        user_uid: user_uid,
        funds: 21
      })

      Blockchain.run_transaction(:credit, user_uid, 21)
      balance = Repo.get_by(Balance, user_uid: user_uid)

      assert balance.funds == 42
    end

    test "remove funds from existing user" do
      user_uid = Ecto.UUID.generate()

      Repo.insert!(%Balance{
        user_uid: user_uid,
        funds: 84
      })

      Blockchain.run_transaction(:debit, user_uid, 42)
      balance = Repo.get_by(Balance, user_uid: user_uid)

      assert balance.funds == 42
    end

    test "returns transaction and hash on success" do
      user_uid = Ecto.UUID.generate()
      {:ok, {transaction, hash}} = Blockchain.run_transaction(:credit, user_uid, 42)
      assert %{amount: 42, operation: :credit, user_uid: ^user_uid} = transaction
      assert is_binary(hash)
      {:ok, {transaction, _hash}} = Blockchain.run_transaction(:debit, user_uid, 42)
      assert %{amount: 42, operation: :debit, user_uid: ^user_uid} = transaction
    end

    test "returns error on ivalid args" do
      user_uid = Ecto.UUID.generate()
      assert {:error, :invalid_args} = Blockchain.run_transaction(:huehue, user_uid, 42)
      assert {:error, :invalid_args} = Blockchain.run_transaction(:credit, user_uid, -42)
      assert {:error, :invalid_args} = Blockchain.run_transaction(:credit, user_uid, "42")
      assert {:error, :invalid_args} = Blockchain.run_transaction(:credit, user_uid, "42")
      assert {:error, :invalid_user_uid} = Blockchain.run_transaction(:credit, "122", 42)
      assert {:error, :invalid_user_uid} = Blockchain.run_transaction(:debit, "122", 42)
      assert {:error, :invalid_user_uid} = Blockchain.run_transaction(:debit, nil, 42)
    end

    test "returns error when user is not found" do
      user_uid = Ecto.UUID.generate()
      {:error, :user_not_found} = Blockchain.run_transaction(:debit, user_uid, 42)
    end

    test "returns error when user not enough funds" do
      user_uid = Ecto.UUID.generate()

      Repo.insert!(%Balance{
        user_uid: user_uid,
        funds: 12
      })

      assert {:error, :not_enough_funds} = Blockchain.run_transaction(:debit, user_uid, 42)
    end
  end

  describe "get_user_balance/1" do
    test "returns balance data when it's found" do
      user_uid = Ecto.UUID.generate()

      Repo.insert!(%Balance{
        user_uid: user_uid,
        funds: 42
      })

      assert {:ok, {^user_uid, 42}} = Blockchain.get_user_balance(user_uid)
    end

    test "returns error when id invalid or not found" do
      assert {:error, :invalid_user_uid} = Blockchain.get_user_balance("1234")
      user_uid = Ecto.UUID.generate()
      assert {:error, :user_not_found} = Blockchain.get_user_balance(user_uid)
    end
  end
end
