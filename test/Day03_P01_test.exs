defmodule Day03_P01.Test do
  use ExUnit.Case
  import Day03_P01

  test "match_prefix" do
    assert match_prefix("123,456)")
    assert match_prefix("427,266)#")
    assert match_prefix("398,319)#!$>don't()")
    refute match_prefix(",319)")
    refute match_prefix("!123,456)")
    refute match_prefix("(123,456)")
  end

  test "extract_integers" do
    assert extract_integers("123,456)123") == {123, 456}
  end

  test "parse" do
    assert parse("mul(427,266)#mul(287,390)mul(398,319)#!$>don't()mul(613,600)from()@!\n") == [
             "",
             "427,266)#",
             "287,390)",
             "398,319)#!$>don't()",
             "613,600)from()@!"
           ]
  end
end
