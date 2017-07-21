defmodule GbfRaidBot.Task do
  alias GbfRaidBot.Raid
  alias GbfRaidBot.Repo
  alias GbfRaidBot.Dispatcher
  alias GbfRaidBot.Bot

  require Logger

  def process_raids do
    stream = Raid.build_raid_stream()
    |> Stream.map(&Raid.parse_raid_tweet/1)
    |> Stream.filter(&Raid.valid_raid?/1)

    for raid <- stream do
      Repo.add_boss_name!(raid.boss_name)

      if Repo.send_notification? and Repo.target_boss?(raid.boss_name) do
        Bot.send_raid_message(raid)
      end
    end
  end

  def pull_updates(offset \\ -1) do
    case Nadia.get_updates(offset: offset) do
      {:ok, updates} when length(updates) > 0 ->
        Dispatcher.dispatch_updates(updates)
        :timer.sleep(200)
        pull_updates(List.last(updates).update_id + 1)
      _ ->
        :timer.sleep(500)
        pull_updates(offset)
    end
  rescue
    exception in Poison.SyntaxError ->
      Logger.error "#{exception}"
      :timer.sleep(3000)
      pull_updates(offset)
  end
end
