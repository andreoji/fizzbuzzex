defmodule Fizzbuzzex.Validators.Fizzbuzz do
  alias Fizzbuzzex.Favourites.Fizzbuzz

  def validate(attrs) do
    []
    |> validate_fizzbuzz(attrs)
    |> validate_number(attrs)
    |> validation_result
  end

  defp validate_fizzbuzz(errors, attrs) do
    fizzbuzz =
      attrs.number
      |> Fizzbuzz.fizzbuzz
    cond do
      fizzbuzz |> to_s == attrs.fizzbuzz -> errors
      true ->
        [{"Fizzbuzz of #{attrs.number} is #{fizzbuzz}, incorrect value of #{attrs.fizzbuzz} given.", {"#/data/attributes/number", :invalid_fizzbuzz}}| errors]
    end
  end

  defp validate_number(errors, attrs) do
    cond do
      attrs.number in Fizzbuzz.min..Fizzbuzz.max -> errors
      true ->
        [{"Number has to be in range #{Fizzbuzz.min} to #{Fizzbuzz.max}.", {"#/data/attributes/number", :not_in_range}}| errors]
    end
  end

  defp to_s(fizzbuzz) when is_integer(fizzbuzz), do: fizzbuzz |> Integer.to_string
  defp to_s(fizzbuzz), do: fizzbuzz

  defp validation_result([]), do: :ok
  defp validation_result(errors), do: {:error, errors}
end
