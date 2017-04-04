defmodule GbfRaidBot.Repo do
  def store_boss_name(boss_name) when is_binary(boss_name) do
    Redix.command(:redix, ~w(SADD boss_name) ++ ["#{boss_name}"])
  end

  def list_up_boss_names do
    {:ok, boss_names} = Redix.command(:redix, ~w(SMEMBERS boss_name))
    Enum.sort(boss_names)
  end
end
