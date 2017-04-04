defmodule GbfRaidBot.Task do
  alias GbfRaidBot.Raid
  alias GbfRaidBot.Repo

  def process_raids do
    stream = Raid.build_raid_stream()
    |> Stream.map(&Raid.parse_raid_tweet/1)
    |> Stream.filter(&Raid.valid_raid?/1)

    for raid <- stream do
      Repo.store_boss_name(raid.boss_name)
    end
  end
end
