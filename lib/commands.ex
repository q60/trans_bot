defmodule Commands do
  @moduledoc """
  Bot commands.
  """

  require Logger


  @arts 51..181
        |> Enum.to_list()
        |> Kernel.--([53,  55,  57,  77,
                      107, 114, 115, 116,
                      117, 119, 120, 122,
                      123, 124, 127, 129,
                      130, 131, 135, 138,
                      148, 149, 150, 151])
        |> Enum.map(fn id -> id + 457_239_000 end)

  defp get_help_text(which) do
    case which do
      :chat ->
        """
        ℹ Справочная.

        ❕ Основные команды начинаются с префикса "/" либо "!".
        Например: /помощь

        ❕ Ролевые команды пишутся без префикса в ответ на сообщение другого человека.
        Например: обнять

        Основные команды:
        🗒 помощь, help -- Выводит это сообщение.
        🖼 арт, art -- Присылает няшную пикчу.
        🖥 аптайм, uptime -- Аптайм бота.
        💾 v -- Версия Erlang/OTP и Elixir.
        👋 ку -- Приветствует тебя стикером.
        🤷 shrug -- ¯\\_(ツ)_/¯.
        💜 десу, desu -- desu desu desu desu.

        Ролевые команды:
        💛 обнять
        💋 поцеловать
        👅 лизь
        💚 кусь
        🍑 трахнуть
        🍆 отсосать
        """

      :im ->
        """
        ℹ Справочная.

        ❕ Основные команды начинаются с префикса "/" либо "!".
        Например: /помощь

        Основные команды:
        🗒 помощь, help -- Выводит это сообщение.
        🖼 арт, art -- Присылает няшную пикчу.
        🖥 аптайм, uptime -- Аптайм бота.
        💾 v -- Версия Erlang/OTP и Elixir.
        💜 десу, desu -- desu desu desu desu.
        """
    end
  end

  @doc """
  Send help message.
  """
  @spec help(integer(), any(), :chat | :im) :: :ok
  def help(peer_id, token, which) do
    APIWrapper.send_message(
      peer_id,
      token,
      message: get_help_text(which)
    )
  end

  @doc """
  Send random cute picture.
  """
  @spec random_art(integer(), any(), any()) :: :ok
  def random_art(peer_id, token, group_id) do
    APIWrapper.send_message(
      peer_id,
      token,
      message: "держи",
      attachment: "photo-#{group_id}_#{Enum.random(@arts)}"
    )
  end

  @doc """
  Send bot uptime.
  """
  @spec uptime(integer(), integer(), any()) :: :ok
  def uptime(peer_id, start, token) do
<<<<<<< HEAD
    uptime =
      ~T[00:00:00.000]
      |> Time.add(System.os_time(:second) - start, :second)
      |> Time.truncate(:second)
      |> Time.to_string()
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)
      |> then(fn [h, m, s] ->
        words = [
          h: [true: "hours", false: "hour"][h == 0 or h > 1],
          m: [true: "minutes", false: "minute"][m == 0 or m > 1],
          s: [true: "seconds", false: "second"][s == 0 or s > 1]
        ]
=======
    uptime = System.os_time(:second) - start
>>>>>>> 972a6fd9c15d1fb08f2e20c2d54f9fc607be09dd

    %{w: w, d: d, h: h, m: m, s: s} = %{
      w:
        [
          true: div(uptime, 604_800),
          false: nil
        ][uptime >= 604_800],
      d:
        [
          true: div(rem(uptime, 604_800), 86400),
          false: nil
        ][div(rem(uptime, 604_800), 86400) > 0],
      h:
        [
          true: div(rem(uptime, 86400), 3600),
          false: nil
        ][div(rem(uptime, 86400), 3600) > 0],
      m:
        [
          true: div(rem(uptime, 3600), 60),
          false: nil
        ][div(rem(uptime, 3600), 60) > 0],
      s:
        [
          true: rem(uptime, 60),
          false: nil
        ][rem(uptime, 60) > 0]
    }

    uptime_string =
      [
        w && ((w > 1 && "#{w} weeks") || "1 week"),
        d && ((d > 1 && "#{d} days") || "1 day"),
        h && ((h > 1 && "#{h} hours") || "1 hour"),
        m && ((m > 1 && "#{m} minutes") || "1 minute"),
        s && ((s > 1 && "#{s} seconds") || "1 second")
      ]
      |> Enum.join(" ")

    APIWrapper.send_message(
      peer_id,
      token,
      message: uptime_string
    )
  end

  @doc """
  Send random greeting sticker.
  """
  @spec greet(integer(), any()) :: :ok
  def greet(peer_id, token) do
    sticker =
      [
        11_238,
        18_463,
        5937,
        6864,
        60_260,
        7910,
        16_688,
        8102,
        7464,
        4380,
        5526,
        5537,
        5527,
        8481,
        8472
      ]
      |> Enum.random()

    APIWrapper.send_message(
      peer_id,
      token,
      sticker_id: sticker
    )
  end

  @doc """
  Send shrug.
  """
  @spec shrug(integer(), any()) :: :ok
  def shrug(peer_id, token) do
    APIWrapper.send_message(
      peer_id,
      token,
      message: ~S"¯\_(ツ)_/¯"
    )
  end

  @doc """
  Desu desu desu.
  """
  @spec desu(integer(), any(), any()) :: :ok
  def desu(peer_id, token, group_id) do
    desu_desu =
      Enum.random(["desu", "десу"])
      |> List.duplicate(Enum.random(1..5))
      |> Enum.join(" ")

    APIWrapper.send_message(
      peer_id,
      token,
      message: desu_desu,
      attachment: "photo-#{group_id}_457239151"
    )
  end

  @doc """
  Send Elixir and OTP versions.
  """
  @spec version(integer(), any()) :: :ok
  def version(peer_id, token) do
    APIWrapper.send_message(
      peer_id,
      token,
      message: "Erlang/OTP #{System.otp_release()}, Elixir #{System.version()}"
    )
  end
end
