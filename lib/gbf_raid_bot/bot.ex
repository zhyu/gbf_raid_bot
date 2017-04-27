defmodule GbfRaidBot.Bot do
  alias Nadia.Model.Message
  alias Nadia.Model.Chat
  alias GbfRaidBot.Repo

  @admin_id Application.get_env(:gbf_raid_bot, :admin_id)
  @helper_link Application.get_env(:gbf_raid_bot, :helper_link)

  def handle_message(%Message{chat: %Chat{type: "private", id: @admin_id}, text: text}) do
    handle_private_message text
    Repo.record_last_command! text
  end

  def handle_message(_), do: true

  def send_raid_message(%{message: message, battle_id: battle_id, boss_name: boss_name}) do
    Nadia.send_message(@admin_id, "#{boss_name}\n#{message}\n#{@helper_link}?battle_id=#{battle_id}")
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
    Repo.remove_all_boss_names!
    send_done_message()
  end

  defp handle_private_message("/add_target_boss") do
    Repo.start_adding_target_boss!
    Nadia.send_message(@admin_id, "please send target boss name:\n#{@helper_link}boss_name_select.html")
  end

  defp handle_private_message("/remove_target_boss") do
    Repo.start_removing_target_boss!
    Nadia.send_message(@admin_id, "please send target boss name:\n#{@helper_link}boss_name_select.html")
  end

  defp handle_private_message("/remove_all_target_bosses") do
    Repo.remove_all_target_bosses!
    send_done_message()
  end

  defp handle_private_message("/show_target_bosses") do
    case Repo.list_up_target_bosses do
      [] ->
        Nadia.send_message(@admin_id, "None!")
      target_bosses when is_list(target_bosses) ->
        Enum.each(target_bosses, &Nadia.send_message(@admin_id, &1))
      _ -> nil
    end
  end

  defp handle_private_message(text) do
    cond do
      Repo.adding_target_boss? and Repo.get_last_command == "/add_target_boss" ->
        Repo.add_target_boss! text
        Repo.end_adding_target_boss!
        send_done_message()
      Repo.removing_target_boss? and Repo.get_last_command == "/remove_target_boss" ->
        Repo.remove_target_boss! text
        Repo.end_removing_target_boss!
        send_done_message()
      true -> nil
    end
  end

  defp send_done_message, do: Nadia.send_message(@admin_id, "Done!")
end
