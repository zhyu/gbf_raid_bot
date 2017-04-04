defmodule GbfRaidBot do
  use Application

  @task_name GbfRaidBot.Task
  @task_supervisor_name GbfRaidBot.TaskSupervisor

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Task.Supervisor, [[name: @task_supervisor_name]]),
      worker(Redix, [[], [name: :redix]]),
      worker(Task, [@task_name, :process_raids, []])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: GbfRaidBot.Supervisor)
  end
end
