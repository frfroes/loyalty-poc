defmodule LoyaltyApiWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  @doc """
  Translates an error message.
  """
  def translate_error({msg, opts}) do
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  @doc """
  Renders default error view
  """
  def render_error(conn, %Ecto.Changeset{} = error) do
    conn
    |> Plug.Conn.put_status(:bad_request)
    |> Phoenix.Controller.put_view(LoyaltyApiWeb.ChangesetView)
    |> Phoenix.Controller.render("error.json", changeset: error)
  end

  def render_error(conn, error) do
    conn
    |> Plug.Conn.put_status(:bad_request)
    |> Phoenix.Controller.put_view(LoyaltyApiWeb.ErrorView)
    |> Phoenix.Controller.render("error.json", error: error)
  end
end
