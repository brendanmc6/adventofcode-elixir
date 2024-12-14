defmodule Mix.Tasks.Solve.Test do
  import Mix.Tasks.Solve
  use ExUnit.Case

  describe "valid_args/2 macro" do
    test "validates day and puzzle are exactly 2 characters and binaries" do
      assert valid_args("01", "02") == true
      assert valid_args("AA", "BB") == true

      refute valid_args("1", "02") == true
      refute valid_args("01", "2") == true
      refute valid_args("001", "02") == true
      refute valid_args("01", "002") == true
      refute valid_args(1, "02") == true
      refute valid_args("01", 2) == true
    end
  end

  # Hardcode solutions so that we can confidently refactor without breaking prior implementations
  describe "solutions" do
    test "Day01_P01" do
      assert solve("01", "01") == 1_223_326
    end

    test "Day01_P02" do
      assert solve("01", "02") == 21_070_419
    end

    test "Day02_P01" do
      assert solve("02", "01") == 510
    end

    test "Day02_P02" do
      assert solve("02", "02") == 553
    end

    test "Day03_P01" do
      assert solve("03", "01") == 189_527_826
    end

    test "Day03_P02" do
      assert solve("03", "02") == 63_013_756
    end
  end
end
