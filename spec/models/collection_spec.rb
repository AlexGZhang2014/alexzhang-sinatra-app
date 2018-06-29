require 'spec_helper'

describe "Collection" do
  before do
    @user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
    @fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?")
    @fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!")
    @robbing_banks = Item.create(:name => "Robbing Banks", :description => "I love money!")
    @laughing = Item.create(:name => "Laughing Maniacally", :description => "Who doesn't love laughing? One day I'll make Batman laugh!")
    @pizza = Item.create(:name => "Pizza", :description => "Best pizza is in NYC")
    @burger = Item.create(:name => "Burger", :description => "In-N-Out is overrated")
  end
  
  it 'has a name and a description' do
    expect(@fav_activities.name).to eq("Favorite Activities")
    expect(@fav_activities.description).to eq("These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?")
    expect(@fav_foods.name).to eq("Favorite Foods")
    expect(@fav_foods.description).to eq("These are all of my favorite foods!")
  end
  
  it 'belongs to a user' do
    @user.collections << @fav_activities
    @user.collections << @fav_foods
    expect(@user.collections).to include(@fav_activities)
    expect(@user.collections).to include(@fav_foods)
  end
  
  it 'can have many items' do
    @fav_activities.items << @robbing_banks
    @fav_activities.items << @laughing
    expect(@fav_activities.items).to include(@robbing_banks)
    expect(@fav_activities.items).to include(@laughing)
    @fav_foods.items << @pizza
    @fav_foods.items << @burger
    expect(@fav_foods.items).to include(@pizza)
    expect(@fav_foods.items).to include(@burger)
  end
end