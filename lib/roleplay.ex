defmodule RolePlay do
  @moduledoc """
  This module provides bot's RP functions.
  """

  alias BalalaikaBear, as: VK
  require Logger

  @doc """
  RolePlay actions list.
  """
  @spec rp_actions :: [<<_::64, _::_*32>>, ...]
  def rp_actions, do: ["обнять", "поцеловать", "лизь", "кусь", "отсосать", "трахнуть"]

  @doc """
  RolePlay action. Sends RP message to recipient.
  """
  @spec rp_action(<<_::64, _::_*32>>, map(), any(), any()) :: :ok
  def rp_action(text, message, token, group_id) do
    firstp = message["from_id"]
    secondp = message["reply_message"]["from_id"]
    peer_id = message["peer_id"]

    [firstp_name, firstp_gender] = person_info(firstp, token)

    [action, name_case] = action_case(text, firstp_gender)

    [secondp_name, secondp_gender] = person_info(secondp, token, name_case)

    action_text = "[id#{firstp}|#{firstp_name}] #{action} [id#{secondp}|#{secondp_name}]"
    Logger.info("Action: #{action_text}")

    APIWrapper.send_message(
      peer_id,
      token,
      message: action_text,
      attachment: action_picture(text, firstp_gender, secondp_gender, group_id)
    )
  end

  defp person_info(id, token, name_case \\ "nom") do
    {:ok, [%{"first_name" => name, "sex" => gender} | _]} =
      VK.Users.get(%{
        user_ids: [id],
        fields: [:sex],
        name_case: name_case,
        access_token: token
      })

    [name, gender]
  end

  defp action_case(text, firstp_gender) do
    [action, name_case] =
      %{
        "обнять" => [%{female: "обняла", male: "обнял"}, "acc"],
        "поцеловать" => [%{female: "поцеловала", male: "поцеловал"}, "acc"],
        "лизь" => [%{female: "лизнула", male: "лизнул"}, "acc"],
        "отсосать" => [%{female: "отсосала", male: "отсосал"}, "dat"],
        "трахнуть" => [%{female: "трахнула", male: "трахнул"}, "acc"],
        "кусь" => [%{female: "сделала кусь", male: "сделал кусь"}, "dat"]
      }[text]

    [
      action[
        case firstp_gender do
          1 -> :female
          2 -> :male
        end
      ],
      name_case
    ]
  end

  defp action_picture(action, firstp, secondp, group_id) do
    case {firstp, secondp} do
      {1, 1} ->
        %{
          "поцеловать" => "photo-#{group_id}_457239031",
          "обнять" => "photo-#{group_id}_457239032",
          "лизь" => "photo-#{group_id}_457239033",
          "кусь" => "photo-#{group_id}_457239034"
        }[action]

      {2, 2} ->
        %{
          "поцеловать" => "photo-#{group_id}_457239039",
          "обнять" => "photo-#{group_id}_457239040",
          "лизь" => "photo-#{group_id}_457239041",
          "кусь" => "photo-#{group_id}_457239042"
        }[action]

      {1, 2} ->
        %{
          "поцеловать" => "photo-#{group_id}_457239043",
          "обнять" => "photo-#{group_id}_457239044",
          "лизь" => "photo-#{group_id}_457239045",
          "кусь" => "photo-#{group_id}_457239046"
        }[action]

      {2, 1} ->
        %{
          "поцеловать" => "photo-#{group_id}_457239047",
          "обнять" => "photo-#{group_id}_457239048",
          "лизь" => "photo-#{group_id}_457239049",
          "кусь" => "photo-#{group_id}_457239050"
        }[action]
    end
  end
end
