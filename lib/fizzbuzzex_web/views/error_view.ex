defmodule FizzbuzzexWeb.ErrorView do
  use FizzbuzzexWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("error.json", assigns) do
    errors = Enum.map(assigns[:errors], fn {detail, pointer} ->
      %{
        source: %{ pointer: pointer |> pointer},
        title: pointer |> title,
        detail: detail
      }
    end)

    %{errors: errors}
  end

  defp pointer({pointer, _}), do: pointer
  defp pointer(pointer), do: pointer

  defp title({"#/data/attributes/number", :invalid_fizzbuzz}), do: "Invalid fizzbuzz value"
  defp title({"#/data/attributes/number", :not_in_range}), do: "Not in range"
  defp title({"#/data", :missing_data_object}), do: "Missing data"
  defp title("#/data"), do: "Invalid Properties"
  defp title("#/data/attributes"), do: "Invalid Attribute(s)"
  defp title("#/data/attributes/number"), do: "Type mismatch"
  defp title("#/data/attributes/fizzbuzz"), do: "Type mismatch"
  defp title("#/data/attributes/state"), do: "Type mismatch"
  defp title({"#/data/type", :invalid_type}), do: "Type's value incorrect"
  defp title("#/data/type"), do: "Type mismatch"
end
