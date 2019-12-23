defmodule Mentions do

	def creatementions() do
      _mentionstable = :ets.new(:mentions, [:set, :public, :named_table])
      {:ok, pid} = GenServer.start_link(__MODULE__,[], name: :mentions)
      :ets.insert(:services, {"mentionspid" , pid})
    end

    def init(state) do    
    	{:ok, state}
  	end


  	def handle_cast({:updatementions, tweet, mentioned}, state) do
    	  mentionedp = Enum.at(mentioned,0) |> String.replace_leading("@", "")
      	[{_, mentionedtweets}] = :ets.lookup(:mentions, mentionedp)
      	mentionedtweets = mentionedtweets ++ [tweet]
      	:ets.insert(:mentions, {mentioned, mentionedtweets})
        # IO.inspect "#{mentioned} has been mentioned in tweet: #{mentionedtweets}"
    	{:noreply, state}
 	end
end