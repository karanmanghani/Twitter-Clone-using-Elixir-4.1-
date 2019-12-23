defmodule Server do
  use GenServer
    
  def start_link() do
    {:ok, pid} =  GenServer.start_link(__MODULE__, :ok)
    :ets.insert(:services, {"serverpid" , pid})
  end

  def createaccounts() do
      userstable = :ets.new(:users_table, [:set, :public, :named_table])
  end

  def init(state) do    
    {:ok, state}
  end
end