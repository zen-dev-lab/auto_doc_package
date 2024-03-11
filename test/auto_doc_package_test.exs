defmodule AutoDocPackageTest do
  use ExUnit.Case
  doctest AutoDocPackage

  test "greets the world" do
    assert AutoDocPackage.hello() == :world
  end
end
