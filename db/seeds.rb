@joker = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
@fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => @joker.id)
@fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => @joker.id)
@robbing_banks = Item.create(:name => "Robbing Banks", :description => "I love money!", :collection_id => @fav_activities.id)
@laughing = Item.create(:name => "Laughing Maniacally", :description => "Who doesn't love laughing? One day I'll make Batman laugh!", :collection_id => @fav_activities.id)
@pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC", :collection_id => @fav_foods.id)
@burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated", :collection_id => @fav_foods.id)
@batman = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
@allies = Collection.create(:name => "Allies", :description => "These are the heroes I work with and trust with my life.", :user_id => @batman.id)
@rogues_gallery = Collection.create(:name => "Rogues Gallery", :description => "A list of all the villains I have fought against. Each entry has their strengths, weaknesses, and personality traits.", :user_id => @batman.id)
@superman = Item.create(:name => "Superman", :description => "The strongest Kryptonian I know", :collection_id => @allies.id)
@wonder_woman = Item.create(:name => "Wonder Woman", :description => "The fierce Amazon princess", :collection_id => @allies.id)
@penguin = Item.create(:name => "Penguin", :description => "Oswald Cobblepot is rich but also a birdbrain. He's really not that threatening compared to all the other villains I have faced.", :collection_id => @rogues_gallery.id)
@bane = Item.create(:name => "Bane", :description => "Bane is one of the toughest enemies I have ever fought. He can become super strong with his weird green serum. However, he becomes really weak after that serum has been in his system for awhile.", :collection_id => @rogues_gallery.id)


