defmodule TransBotTest do
  use ExUnit.Case
  doctest TransBot

  test "greets the world" do
    assert TransBot.hello() == :world
  end
end
