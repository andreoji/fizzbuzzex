defmodule Fizzbuzzex.Validators.JsonSchema.Test do
  use Fizzbuzzex.DataCase
  import Ecto.Query, warn: false
  alias Fizzbuzzex.Validators.JsonSchema

  test "validate/1 when schema is valid" do
    assert :ok =
    %{
      "data" => %{
        "attributes" => %{
          "fizzbuzz" => "buzz",
          "number" => 100000000000,
          "state" => true
        },
        "type" => "favourite"
      }
    }
    |> JsonSchema.validate()
  end

  describe "validate/1 when type property is missing" do
    test "return an error" do
      assert {:error, [{"Required property type was not present.", "#/data"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "fizzbuzz" => "buzz",
            "number" => 100000000000,
            "state" => true
          }
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when type property isn't 'favourite'" do
    test "return an error" do
      assert {:error, [{~s(Property type must have the value "favourite".), {"#/data/type", :invalid_type}}]} =
      %{
        "data" => %{
          "type" => "invalid",
          "attributes" => %{
            "fizzbuzz" => "buzz",
            "number" => 100000000000,
            "state" => true
          }
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when fizzbuzz attribute is missing" do
    test "returns the relevant fizzbuzz error tuple" do
      assert {:error, [{"Required property fizzbuzz was not present.", "#/data/attributes"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "number" => 100000000000,
            "state" => true
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when number attribute is missing" do
    test "returns the relevant number error tuple" do
      assert {:error, [{"Required property number was not present.", "#/data/attributes"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "fizzbuzz" => "buzz",
            "state" => true
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when state attribute is missing" do
    test "returns the relevant state error tuple" do
      assert {:error, [{"Required property state was not present.", "#/data/attributes"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "fizzbuzz" => "buzz",
            "number" => 100000000000,
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when fizzbuzz, number and state attributes are all missing" do
    test "returns the relevant number, fizzbuzz, state error tuple" do
      assert {:error, [{"Required properties number, fizzbuzz, state were not present.", "#/data/attributes"}]} =
      %{
        "data" => %{
          "attributes" => %{
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when attributes property is missing" do
    test "returns the relevant attributes error tuple" do
      assert {:error, [{"Required property attributes was not present.", "#/data"}]} =
      %{
        "data" => %{

          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when type and attributes properties are missing" do
    test "returns the relevant type and attributes error tuple" do
      assert {:error, [{"Required properties type, attributes were not present.", "#/data"}]} =
      %{
        "data" => %{
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when the data object is missing" do
    test "returns the relevant data object error tuple" do
      assert {:error, [{"Payload is required to have a data object.", {"#/data", :missing_data_object}}]} =
      %{}
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when fizzbuzz attribute has the wrong type" do
    test "returns the relevant fizzbuzz error tuple" do
      assert {:error, [{"Type mismatch. Expected String but got Integer.",
      "#/data/attributes/fizzbuzz"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "number" => 100000000000,
            "state" => true,
            "fizzbuzz" => 100000000000
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when number attribute has the wrong type" do
    test "returns the relevant number error tuple" do
      assert {:error, [{"Type mismatch. Expected Integer but got String.",
      "#/data/attributes/number"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "number" => "100000000000",
            "fizzbuzz" => "buzz",
            "state" => true
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when state attribute has the wrong type" do
    test "returns the relevant state error tuple" do
      assert {:error, [{"Type mismatch. Expected Boolean but got String.",
      "#/data/attributes/state"}]} =
      %{
        "data" => %{
          "attributes" => %{
            "fizzbuzz" => "buzz",
            "number" => 100000000000,
            "state" => "true"
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when fizzbuzz, number and state attributes are all the wrong type" do
    test "returns the relevant number, fizzbuzz, state error tuple" do
      assert {:error,
      [
        {"Type mismatch. Expected String but got Integer.", "#/data/attributes/fizzbuzz"},
        {"Type mismatch. Expected Integer but got String.", "#/data/attributes/number"},
        {"Type mismatch. Expected Boolean but got String.", "#/data/attributes/state"}
      ]} =
      %{
        "data" => %{
          "attributes" => %{
            "fizzbuzz" => 1,
            "number" => "100000000000",
            "state" => "true"
          },
          "type" => "favourite"
        }
      }
      |> JsonSchema.validate()
    end
  end

  describe "validate/1 when fizzbuzz, number state and type all have the wrong type" do
    test "returns the relevant number, fizzbuzz, state error tuple" do
      assert {:error,
      [
        {"Property type must have the value \"favourite\".", {"#/data/type", :invalid_type}},
        {"Type mismatch. Expected String but got Integer.", "#/data/attributes/fizzbuzz"},
        {"Type mismatch. Expected Integer but got String.", "#/data/attributes/number"},
        {"Type mismatch. Expected Boolean but got String.", "#/data/attributes/state"},
        {"Type mismatch. Expected String but got Integer.", "#/data/type"}
      ]} =
      %{
        "data" => %{
          "attributes" => %{
            "fizzbuzz" => 1,
            "number" => "100000000000",
            "state" => "true"
          },
          "type" => 1
        }
      }
      |> JsonSchema.validate()
    end
  end
end
