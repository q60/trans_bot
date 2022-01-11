defmodule Macros do
  @moduledoc """
  Different bot macros.
  """

  require Logger

  defmacro __using__(_opts) do
    quote do
      import Macros
    end
  end

  defmacro command(commands, do: action) when is_list(commands) do
    for command <- commands do
      quote do
        prefixes = [
          "!" <> unquote(command),
          "/" <> unquote(command),
          "." <> unquote(command)
        ]

        if var!(text) in prefixes do
          Logger.info("Executing /#{unquote(command)} command")
          Task.start(fn -> unquote(action) end)
        end
      end
    end
  end

  defmacro command(command, do: action) do
    quote do
      prefixes = [
        "!" <> unquote(command),
        "/" <> unquote(command),
        "." <> unquote(command)
      ]

      if var!(text) in prefixes do
        Logger.info("Executing /#{unquote(command)} command")
        Task.start(fn -> unquote(action) end)
      end
    end
  end
end
