defmodule Hashtags do

	def createhashtags() do
      _hashtagstable = :ets.new(:hashtags, [:set, :public, :named_table])
      {:ok, pid} = GenServer.start_link(__MODULE__,[], name: :hashtags)
      :ets.insert(:services, {"hashtagspid" , pid})
    end

    def init(state) do    
    	{:ok, state}
  	end

  	def handle_cast({:updatehashtags, hashtagused}, state) do
    	thehashtag = Enum.at(hashtagused,0)
      	[{_, count}] = :ets.lookup(:hashtags, thehashtag)
      	count =  count + 1
      	:ets.insert(:hashtags, {thehashtag, count})
     	# IO.inspect "#{thehashtag} has been mentioned in tweets #{count} times"
    	{:noreply, state}
 	end

end