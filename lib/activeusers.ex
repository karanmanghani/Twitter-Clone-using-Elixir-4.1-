defmodule Active do

	def createactiveusers() do
    _activeusertable = :ets.new(:active_users, [:set, :public, :named_table])
    {:ok, pid} = GenServer.start_link(__MODULE__,[], name: :active_users)
    :ets.insert(:services, {"activeusers" , pid})
  end

  def init(state) do    
   {:ok, state}
 end


 def handle_cast({:activate, l}, state) do
   Enum.each(l, fn x-> 
    :ets.insert(:active_users, {"user#{x}"})
  end)
   {:noreply, state}
 end

end