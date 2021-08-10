defmodule LoyaltyApiWeb.LoyaltyView do
  use LoyaltyApiWeb, :view
  alias LoyaltyApi.Loyalty.Points
  alias LoyaltyApi.Loyalty.Coupon

  def render("index.json", %{message: message, points: points, hash: hash}) do
    %{
      message: message,
      data: %{
        transacion_hash: hash,
        points: serialize_struct(points)
      }
    }
  end

  def render("index.json", %{message: message, coupon: coupon, hash: hash}) do
    %{
      message: message,
      data: %{
        transacion_hash: hash,
        coupon: serialize_struct(coupon)
      }
    }
  end

  def render("index.json", %{transactions: transactions}) do
    %{
      data: render_many(transactions, LoyaltyApiWeb.LoyaltyView, "transaction.json")
    }
  end

  def render("transaction.json", %{loyalty: transaction}) do
    case transaction do
      %{points: %Points{} = points} ->
        transaction
        |> serialize_struct([:coupon, :customer])
        |> Map.put(:points, serialize_struct(points))

      %{coupon: %Coupon{} = coupon} ->
        transaction
        |> serialize_struct([:points, :customer])
        |> Map.put(:coupon, serialize_struct(coupon))
    end
  end

  defp serialize_struct(struct, keys_to_drop \\ []) do
    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__])
    |> Map.drop(keys_to_drop)
  end
end
