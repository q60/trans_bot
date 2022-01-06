defmodule TransBot do
  @moduledoc """
  TransBot is a bot for testing VK API module.
  """

  alias BalalaikaBear.Longpoll.GroupLongpoll, as: Longpoll
  alias RolePlay, as: RP
  require Logger

  @token System.get_env("TRANSBOT_TOKEN")
  @group_id System.get_env("TRANSBOT_ID")
  @start System.os_time()

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

    if is_map(reply) and Enum.member?(RP.rp_actions(), text) and reply["from_id"] > 0 do
      Logger.info("Doing a RP action")
      RP.rp_action(text, message, @token, @group_id)
    else
      case text do
        "!трап" ->
          Logger.info("Sending random trap picture")
          Commands.random_trap(peer_id, @token, @group_id)

        "!аптайм" ->
          Logger.info("Sending bot uptime")
          Commands.uptime(peer_id, @start, @token)

        "!ку" ->
          Logger.info("Sending greeting sticker")
          Commands.greet(peer_id, @token)

        _ ->
          nil
      end
    end
  end

  # If message from messenger
  defp process_message(_from_id, peer_id, _message) do
    APIWrapper.send_message(
      peer_id,
      @token,
      message: "личька"
    )
  end
end
