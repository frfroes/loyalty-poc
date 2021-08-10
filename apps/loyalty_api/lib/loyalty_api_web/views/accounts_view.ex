defmodule LoyaltyApiWeb.AccountsView do
  use LoyaltyApiWeb, :view

  def render("index.json", %{message: message, customer: customer}) do
    %{
      message: message,
      data: %{
        customer: serialize_struct(customer, [:brand])
      }
    }
  end

  defp serialize_struct(struct, assocs_to_drop \\ []) do
    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__])
    |> Map.drop(assocs_to_drop)
  end
end
