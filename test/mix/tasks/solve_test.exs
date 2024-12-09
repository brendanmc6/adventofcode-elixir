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
end
