defmodule LoyaltyApiWeb.LoyaltyView do
  use LoyaltyApiWeb, :view

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

  defp serialize_struct(struct) do
    struct |> Map.from_struct() |> Map.drop([:__meta__])
  end
end
