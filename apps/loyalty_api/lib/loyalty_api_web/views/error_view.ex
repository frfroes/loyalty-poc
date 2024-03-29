defmodule LoyaltyApiWeb.ErrorView do
  use LoyaltyApiWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def render("error.json", %{error: error}) when is_atom(error) do
    %{error: to_readable_error(error)}
  end

  def render("error.json", %{error: error}) when is_binary(error) do
    %{
      error: error
    }
  end

  def render("error.json", %{error: error}) do
    %{
      error: inspect(error)
    }
  end

  defp to_readable_error(error) when is_atom(error) do
    error
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.capitalize()
  end
end
