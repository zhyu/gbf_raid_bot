defmodule GbfRaidBot.Repo do
  def store_boss_name(boss_name) when is_binary(boss_name) do
    Redix.command(:redix, ~w(SADD boss_name) ++ ["#{boss_name}"])
  end

  def list_up_boss_names do
    {:ok, boss_names} = Redix.command(:redix, ~w(SMEMBERS boss_name))
    Enum.sort(boss_names)
  end

  def store_target_boss(boss_name) when is_binary(boss_name) do
    Redix.command(:redix, ~w(SADD target_boss) ++ ["#{boss_name}"])
  end

  def list_up_target_bosses do
    {:ok, boss_names} = Redix.command(:redix, ~w(SMEMBERS target_boss))
    Enum.sort(boss_names)
  end

  def target_boss?(boss_name) do
    case Redix.command(:redix, ~w(SISMEMBER target_boss) ++ ["#{boss_name}"]) do
      {:ok, 1} -> true
      _ -> false
    end
  end
end
