defmodule GbfRaidBot.Bot do
  alias Nadia.Model.Message
  alias Nadia.Model.Chat
  alias GbfRaidBot.Repo

  @admin_id Application.get_env(:gbf_raid_bot, :admin_id)

  def handle_message(%Message{chat: %Chat{type: "private", id: @admin_id}, text: text}) do
    handle_private_message(text)
  end

  def handle_message(_), do: true

  def send_raid_message(%{message: message, battle_id: battle_id, boss_name: boss_name}) do
    Nadia.send_message(@admin_id, boss_name <> "\n" <> message)
    Nadia.send_message(@admin_id, battle_id)
  end

  defp handle_private_message("/turn_on_notification") do
    Repo.turn_on_notification!
    send_done_message()
  end

  defp handle_private_message("/turn_off_notification") do
    Repo.turn_off_notification!
    send_done_message()
  end

  defp handle_private_message("/show_boss_names") do
    Repo.list_up_boss_names
    |> Enum.each(&Nadia.send_message(@admin_id, &1))
  end

  defp handle_private_message("/remove_all_boss_names") do
    Repo.remove_all_boss_names!()
    send_done_message()
  end

  defp handle_private_message("/add_target_boss " <> boss_name) do
    Repo.add_target_boss! boss_name
    send_done_message()
  end

  defp handle_private_message("/remove_target_boss " <> boss_name) do
    Repo.remove_target_boss! boss_name
    send_done_message()
  end

  defp handle_private_message("/remove_all_target_bosses") do
    Repo.remove_all_target_bosses!()
    send_done_message()
  end

  defp handle_private_message("/show_target_bosses") do
    Repo.list_up_target_bosses
    |> Enum.each(&Nadia.send_message(@admin_id, &1))
  end

  defp handle_private_message(_), do: true

  defp send_done_message, do: Nadia.send_message(@admin_id, "Done!")
end
