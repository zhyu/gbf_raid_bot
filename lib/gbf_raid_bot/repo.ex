defmodule GbfRaidBot.Repo do
  def add_boss_name!(boss_name) when is_binary(boss_name) do
    Redix.command(:redix, ~w(SADD boss_name) ++ ["#{boss_name}"])
  end

  def list_up_boss_names do
    {:ok, boss_names} = Redix.command(:redix, ~w(SMEMBERS boss_name))
    Enum.sort(boss_names)
  end

  def remove_all_boss_names! do
    Redix.command(:redix, ~w(DEL boss_name))
  end

  def add_target_boss!(boss_name) when is_binary(boss_name) do
    Redix.command(:redix, ~w(SADD target_boss) ++ ["#{boss_name}"])
  end

  def list_up_target_bosses do
    {:ok, boss_names} = Redix.command(:redix, ~w(SMEMBERS target_boss))
    Enum.sort(boss_names)
  end

  def target_boss?(boss_name) when is_binary(boss_name) do
    case Redix.command(:redix, ~w(SISMEMBER target_boss) ++ ["#{boss_name}"]) do
      {:ok, 1} -> true
      _ -> false
    end
  end

  def remove_target_boss!(boss_name) when is_binary(boss_name) do
    Redix.command(:redix, ~w(SREM target_boss) ++ ["#{boss_name}"])
  end

  def remove_all_target_bosses! do
    Redix.command(:redix, ~w(DEL target_boss))
  end

  def turn_on_notification! do
    Redix.command(:redix, ~w(SET notification on))
  end

  def turn_off_notification! do
    Redix.command(:redix, ~w(SET notification off))
  end

  def send_notification? do
    case Redix.command(:redix, ~w(GET notification)) do
      {:ok, "on"} -> true
      _ -> false
    end
  end

  def start_adding_target_boss! do
    Redix.command(:redix, ~w(SET adding_target_boss true))
  end

  def end_adding_target_boss! do
    Redix.command(:redix, ~w(SET adding_target_boss false))
  end

  def adding_target_boss? do
    case Redix.command(:redix, ~w(GET adding_target_boss)) do
      {:ok, "true"} -> true
      _ -> false
    end
  end

  def start_removing_target_boss! do
    Redix.command(:redix, ~w(SET removing_target_boss true))
  end

  def end_removing_target_boss! do
    Redix.command(:redix, ~w(SET removing_target_boss false))
  end

  def removing_target_boss? do
    case Redix.command(:redix, ~w(GET removing_target_boss)) do
      {:ok, "true"} -> true
      _ -> false
    end
  end

  def record_last_command!(command) when is_binary(command) do
    Redix.command(:redix, ~w(SET last_command) ++ ["#{command}"])
  end

  def get_last_command do
    case Redix.command(:redix, ~w(GET last_command)) do
      {:ok, last_command} -> last_command
      _ -> nil
    end
  end
end
