defmodule TransBot do
  @moduledoc """
  TransBot is a bot for testing VK API module.
  """

  alias BalalaikaBear.Longpoll.GroupLongpoll, as: Longpoll
  alias BalalaikaBear, as: VK
  alias RolePlay, as: RP
  require Logger

  @token System.get_env("TRANSBOT_TOKEN")
  @group_id System.get_env("TRANSBOT_ID")

  @spec main(any) :: any
  def main(_args) do
    # Start longpoll
    parent = self()

    pid =
      spawn(
        Longpoll,
        :init,
        [parent, %{group_id: @group_id, access_token: @token, v: 5.131}]
      )

    Logger.info("Spawned longpoll #{inspect(pid)} from parent #{inspect(parent)}")
    Logger.info("Started longpoll loop")
    loop()
  end

  # Main longpoll loop
  defp loop() do
    receive do
      {:ok, response} ->
        IO.inspect(response)
        [update | _] = response["updates"]
        Logger.info("Got new event of type \"#{update["type"]}\"")
        process_event(update["type"], update["object"])

      _ ->
        nil
    end

    loop()
  end

  # Works with incoming events depending on event type.
  # Works with incoming messages.
  defp process_event("message_new", event) do
    message = event["message"]
    from_id = message["from_id"]
    peer_id = message["peer_id"]

    Logger.info("Event: \"#{message["text"]}\" from #{from_id} in #{peer_id}")
    process_message(from_id, peer_id, message)
  end

  # Works with other events
  defp process_event(_, _) do
  end

  # Works with message events.
  # If message from chat
  defp process_message(from_id, peer_id, message) when from_id != peer_id do
    text = message["text"] |> String.downcase()
    reply = message["reply_message"]

    case text do
      "!трап" ->
        Logger.info("Sending random trap picture")
        Commands.random_trap(peer_id, @token, @group_id)

      _ ->
        if is_map(reply) and Enum.member?(RP.rp_actions(), text) and reply["from_id"] > 0 do
          Logger.info("Doing a RP action")
          RP.rp_action(text, message, @token, @group_id)
        end
    end
  end

  # If message from messenger
  defp process_message(_from_id, peer_id, _message) do
    result =
      VK.Messages.send(%{
        peer_id: peer_id,
        random_id: Enum.random(0..(2 ** 64)),
        message: "личька",
        access_token: @token
      })

    case result do
      {:ok, message_id} ->
        Logger.info("Successfully sent message to #{peer_id} with id #{message_id}")

      {_, error} ->
        Logger.error("Message was not sent: #{inspect(error)}")
    end
  end
end
