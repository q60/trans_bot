import Config

config :trans_bot,
  token: System.get_env("TRANSBOT_TOKEN"),
  group_id: System.get_env("TRANSBOT_ID")
