defmodule LoyaltyApi.EctoSchema do
  @moduledoc """
  Setup a custom ecto schema on top on Ecto.Schema.

  In order to seamless work with UUIDs we'll use to easily decorate all schemas. So, when creating a new schema,
  consider using this one instead:

  ```
  defmodule LoyaltyApi.MySchema do
    use LoyaltyApi.EctoSchema
  end
  ```
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
