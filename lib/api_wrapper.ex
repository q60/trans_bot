defmodule APIWrapper do
  @moduledoc """
  Wrapper for VK API methods
  """

  alias BalalaikaBear, as: VK
  require Logger

  @doc """
  Wrapper for messages.send
  """
  @spec send_message(integer(), any(),
          message: String.t(),
          attachment: String.t(),
          sticker_id: String.t()
        ) :: :ok
  def send_message(peer_id, token, options \\ []) do
    defaults = [
      message: "",
      attachment: "",
      sticker_id: ""
    ]

    options = Keyword.merge(defaults, options)

    result =
      VK.Messages.send(%{
        peer_id: peer_id,
        random_id: Enum.random(0..(2 ** 64)),
        message: options[:message],
        attachment: options[:attachment],
        sticker_id: options[:sticker_id],
        access_token: token
      })

    case result do
      {:ok, _} ->
        Logger.info("Successfully sent message to #{peer_id}")

      {_, error} ->
        Logger.error("Message was not sent: #{inspect(error)}")
    end
  end
end
