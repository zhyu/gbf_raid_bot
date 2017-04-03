defmodule GbfRaidBot.Task do
  alias GbfRaidBot.Raid

  def process_raids do
    stream = Raid.build_raid_stream()
    |> Stream.map(&Raid.parse_raid_tweet/1)
    |> Stream.filter(&Raid.valid_raid?/1)

    for raid <- stream do
      IO.puts "#{raid.message} #{raid.boss_name}\n#{raid.battle_id}"
    end
  end
end
