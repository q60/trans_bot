defmodule Commands do
  @moduledoc """
  Bot commands.
  """

  require Logger

  @doc """
  Send random trap picture.
  """
  @spec random_trap(integer(), any(), any()) :: :ok
  def random_trap(peer_id, token, group_id) do
    APIWrapper.send_message(
      peer_id,
      token,
      message: "держи",
      attachment: "photo-#{group_id}_#{Enum.random(457_239_051..457_239_147)}"
    )
  end

  @doc """
  Send bot uptime.
  """
  @spec uptime(integer(), integer(), any()) :: :ok
  def uptime(peer_id, start, token) do
    uptime =
      ~T[00:00:00.000]
      |> Time.add(System.os_time(:second) - start, :second)
      |> Time.truncate(:second)
      |> Time.to_string()
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)
      |> then(fn [h, m, s] ->
        words = [
          h: [true: "hours", false: "hour"][rem(h, 2) == 0],
          m: [true: "minutes", false: "minute"][rem(m, 2) == 0],
          s: [true: "seconds", false: "second"][rem(s, 2) == 0]
        ]

        "#{h} #{words[:h]}, #{m} #{words[:m]}, #{s} #{words[:s]}"
      end)

    APIWrapper.send_message(
      peer_id,
      token,
      message: "#{uptime}"
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
