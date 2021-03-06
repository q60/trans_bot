defmodule TransBot do
  @moduledoc """
  TransBot is a bot for testing VK API module.
  """

  alias BalalaikaBear.Longpoll.GroupLongpoll, as: Longpoll
  alias RolePlay, as: RP
  require Logger
  use Macros

  @token Application.fetch_env!(:trans_bot, :token)
  @group_id Application.fetch_env!(:trans_bot, :group_id)
  @start System.os_time(:second)

  @spec main(any) :: any
  def main(_args) do
    # Start longpoll
    parent = self()

    pid =
      spawn(
        Longpoll,
        :init,
        [parent, %{access_token: @token, group_id: @group_id, v: 5.131}]
      )

    Logger.info("Spawned longpoll #{inspect(pid)} from parent #{inspect(parent)}")
    Logger.info("Started longpoll loop")
    loop()
  end

  # Main longpoll loop
  defp loop() do
    receive do
      {:ok, response} ->
        updates = response["updates"]

        unless updates == nil do
          [update | _] = response["updates"]

          Task.start(fn ->
            Logger.info("Got new event of type \"#{update["type"]}\"")
            process_event(update["type"], update["object"])
          end)
        end
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
    [reply | _] =
      if message["fwd_messages"] != [] do
        message["fwd_messages"]
      else
        [message["reply_message"]]
      end

    if is_map(reply) and Enum.member?(RP.rp_actions(), text) and reply["from_id"] > 0 do
      Logger.info("Doing a RP action")

      peer_id = message["peer_id"]
      first_person = message["from_id"]
      second_person = reply["from_id"]

      RP.rp_action(text, peer_id, first_person, second_person, @token, @group_id)
    else
      command ["????????????", "help"] do
        Commands.help(peer_id, @token, :chat)
      end

      command ["??????", "art"] do
        Commands.random_art(peer_id, @token, @group_id)
      end

      command ["????????????", "uptime"] do
        Commands.uptime(peer_id, @start, @token)
      end

      command "????" do
        Commands.greet(peer_id, @token)
      end

      command "shrug" do
        Commands.shrug(peer_id, @token)
      end

      command ["????????", "desu"] do
        Commands.desu(peer_id, @token, @group_id)
      end

      command "v" do
        Commands.version(peer_id, @token)
      end
    end
  end

  # If message from messenger
  defp process_message(_from_id, peer_id, message) do
    text = message["text"] |> String.downcase()

    command ["????????????", "help"] do
      Commands.help(peer_id, @token, :im)
    end

    command ["??????", "art"] do
      Commands.random_art(peer_id, @token, @group_id)
    end

    command ["????????????", "uptime"] do
      Commands.uptime(peer_id, @start, @token)
    end

    command ["????????", "desu"] do
      Commands.desu(peer_id, @token, @group_id)
    end

    command "v" do
      Commands.version(peer_id, @token)
    end
  end
end
