defmodule Commands do
  @moduledoc """
  Misc bot commands.
  """

  alias BalalaikaBear, as: VK
  require Logger

  @doc """
  Send random trap picture.
  """
  @spec random_trap(integer(), any(), any()) :: :ok
  def random_trap(peer_id, token, group_id) do
    result =
      VK.Messages.send(%{
        peer_id: peer_id,
        random_id: Enum.random(0..(2 ** 64)),
        message: "держи",
        attachment: "photo-#{group_id}_#{Enum.random(457_239_051..457_239_147)}",
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
