defmodule GbfRaidBot.Raid do

  alias ExTwitter.Model.Tweet

  @gbf_source ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>)

  @raid_regex_en ~r/((?s).*)([A-Z0-9]{8}) :Battle ID\nI need backup!\n(.+)\n?(.*)/
  @raid_regex_jp ~r/((?s).*)([A-Z0-9]{8}) :参戦ID\n参加者募集！\n(.+)\n?(.*)/

  def build_raid_stream do
    ExTwitter.stream_filter(track: build_raid_query())
  end

  defp build_raid_query do
    Stream.take_every(15..150, 5)
    |> Stream.map(&("Lv#{&1}"))
    |> Enum.into(["I need backup!Battle ID:"])
    |> Enum.join(",")
  end

  def parse_raid_tweet(%Tweet{source: source}) when source != @gbf_source, do: nil
  def parse_raid_tweet(%Tweet{text: text}) do
    case Regex.run(@raid_regex_en, text) do
      [_text, message, battle_id, boss_name, url] ->
        %{message: message, battle_id: battle_id, boss_name: boss_name, url: url}
      nil ->
        case Regex.run(@raid_regex_jp, text) do
          [_text, message, battle_id, boss_name, url] ->
            %{message: message, battle_id: battle_id, boss_name: boss_name, url: url}
          nil -> nil
        end
    end
  end

  def valid_raid?(%{boss_name: boss_name, url: ""}), do: valid_boss_name?(boss_name)
  def valid_raid?(%{boss_name: boss_name, url: "https://" <> _url_part}), do: valid_boss_name?(boss_name)
  def valid_raid?(_), do: false

  defp valid_boss_name?(boss_name) do
    !String.contains?(boss_name, "http")
  end
end
