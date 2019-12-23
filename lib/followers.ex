defmodule Follower do

	def createf() do
    _followerstab = :ets.new(:followers, [:set, :public, :named_table])
    {:ok, pid} = GenServer.start_link(__MODULE__,[], name: :followers)
    :ets.insert(:services, {"followerspid" , pid})
  end

  def init(state) do    
   {:ok, state}
 end

 def handle_cast({:addfollowers, numusers}, state) do
   Enum.map(1..numusers, fn x ->
    username = "user#{x}"
    followers = Enum.take_random(List.delete(Enum.to_list(1..numusers), x), Enum.random(1..numusers))
    Enum.each(followers, fn y -> 
      nf = "user#{y}"
      if(Project.checkifactive(nf)) do
        Client.add_follower(username, nf)
	            	# IO.inspect " #{nf} started following  #{username}"
	            	updatef(username,nf)
              end
            end) 
  end)
   {:noreply, state}
 end

 def updatef(username, newfollower) do
  [{_, followers }] = :ets.lookup(:followers, username)
  followers = followers ++ [newfollower]
  :ets.insert(:followers, {username, followers})

  :ok
      #update following table
      #[{_, followinglist}] = :ets.lookup(:following, newfollower)
      #followinglist = followinglist ++ [username] # started following username
      #:ets.insert(:following, {newfollower, followinglist})
    end

  end