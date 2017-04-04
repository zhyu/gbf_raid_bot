defmodule GbfRaidBot.Dispatcher do
  def dispatch_updates(updates) do
    updates
    |> Enum.each(&Task.Supervisor.start_child(GbfRaidBot.TaskSupervisor, GbfRaidBot.Bot, :handle_message, [&1.message]))
  end
end
