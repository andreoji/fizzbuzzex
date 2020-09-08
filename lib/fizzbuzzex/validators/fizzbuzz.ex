defmodule Fizzbuzzex.Validators.Fizzbuzz do
  alias Fizzbuzzex.Favourites.Favourite
  alias Fizzbuzzex.Favourites.Fizzbuzz
  import Ecto.Changeset

  def validate_fizzbuzz(attrs) do
    fizzbuzz =
      attrs.number
      |> Fizzbuzz.fizzbuzz
    cond do
      fizzbuzz |> to_s == attrs.fizzbuzz  ->
        {:ok, "Fizzbuzz value match"}
      true ->
        changeset = change(%Favourite{})|> add_error(:fizzbuzz, "Fizzbuzz of #{attrs.number} is #{fizzbuzz}, incorrect value of #{attrs.fizzbuzz} given.")
        {:error, changeset}
    end
  end

  def validate_number(attrs) do
    cond do
      attrs.number in Fizzbuzz.min..Fizzbuzz.max  ->
        {:ok, "Fizzbuzz number in range"}
      true ->
        changeset = change(%Favourite{})|> add_error(:number, "Number has to be in range #{Fizzbuzz.min} to #{Fizzbuzz.max}.")
        {:error, changeset}
    end
  end

  def validate_type(attrs) do
    cond do
      attrs.type == "favourite"  ->
        {:ok, "Fizzbuzz type is favourite"}
      true ->
        changeset = change(%Favourite{})|> add_error(:type, ~s(Type has to be the string "favourite".))
        {:error, changeset}
    end
  end

  def validate_data(%{}), do: {:error, change(%Favourite{})|> add_error(:data, "Data is required in payload.")}

  defp to_s(fizzbuzz) when is_integer(fizzbuzz), do: fizzbuzz |> Integer.to_string
  defp to_s(fizzbuzz), do: fizzbuzz
end
