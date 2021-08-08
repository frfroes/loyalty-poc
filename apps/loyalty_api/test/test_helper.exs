ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(LoyaltyApi.Repo, :manual)

# define mocks
Mox.defmock(BlockchainMock, for: Blockchain.API)
Application.put_env(:loyalty_api, :blockchain_api, BlockchainMock)
