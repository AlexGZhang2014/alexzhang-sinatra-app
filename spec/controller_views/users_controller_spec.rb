require 'spec_helper'
require 'pry'

describe UsersController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to Collect Nation!")
    end
  end
  
  describe "Signup Page" do
    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end
    
    it 'directs the user to the collections index page after signing up' do
      user1 = User.create(:username => "example1", :email => "example1@gmail.com", :password => "example1")
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com",
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include("/collections")
    end
    
    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "jokerking50@gmail.com",
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'does not let a user sign up without an email' do
      params = {
        :username => "The Joker",
        :email => "",
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'does not let a user sign up without a password' do
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
    
    it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
      user1 = User.create(:username => "example1", :email => "example1@gmail.com", :password => "example1")
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com",
        :password => "jokerrules"
      }
      post '/signup', params
      get '/signup'
      expect(last_response.location).to include('/collections')
    end
    
    it 'does not create a new user if another user with the same username already exists' do
      user1 = User.create(:username => "example1", :email => "example1@gmail.com", :password => "example1")
      user2 = User.create(:username => "The Joker", :email => "example2@gmail.com", :password => "example2")
      params = {
        :username => "The Joker",
        :email => "jokerking50@gmail.com",
        :password => "jokerrules"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end
  end
  
  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end
    
    it 'loads the collections index page after login' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      params = {
        :username => "The Joker",
        :password => "jokerrules"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome, ")
    end
    
    it 'does not let the user view the login page if they are already logged in' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      params = {
        :username => "The Joker",
        :password => "jokerrules"
      }
      post '/login', params
      get '/login'
      expect(last_response.location).to include("/collections")
    end
  end
  
  describe "logout" do
    it 'lets a user log out if they are already logged in' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      params = {
        :username => "The Joker",
        :password => "jokerrules"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include('/login')
    end
    
    it 'does not let a user logout if they are not logged in' do
      get '/logout'
      expect(last_response.location).to include('/')
    end
    
    it 'does not load /collections if the user is not logged in' do
      get '/collections'
      expect(last_response.location).to include('/login')
    end
    
    it 'does load /collections if the user is logged in' do
      user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
      visit '/login'
      fill_in(:username, :with => "The Joker")
      fill_in(:password, :with => "jokerrules")
      click_button 'Log In'
      expect(page.current_path).to eq('/collections')
    end
  end
  
  describe 'user show page' do
    context 'logged in' do
      it 'shows all collections for a single user' do
        user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user.id)
        fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => user.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:password, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/users/#{user.slug}"
        
        expect(page.body).to include("Favorite Activities")
        expect(page.body).to include("Favorite Foods")
      end
      
      it 'displays links to the show page for each collection' do
        user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user.id)
        fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => user.id)
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:password, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/users/#{user.slug}"
        expect(page.body).to include('</a>')
        expect(page.body).to include("/collections/#{fav_activities.slug}")
      end
    end
    
    context 'logged out' do
      it 'does not show a user profile page when not logged in' do
        user = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        fav_activities = Collection.create(:name => "Favorite Activities", :description => "These are all the things I enjoy doing the most, even if some of them are illegal. But I'm the Joker, so what did you expect?", :user_id => user.id)
        fav_foods = Collection.create(:name => "Favorite Foods", :description => "These are all of my favorite foods!", :user_id => user.id)
        
        visit "/users/#{user.slug}"
        
        expect(page.current_path).to eq('/login')
      end
    end
  end
  
  describe 'user index page' do
    context 'logged in' do
      it 'shows all users' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:password, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/users"
        
        expect(page.body).to include("The Joker")
        expect(page.body).to include("The Batman")
      end
      
      it 'displays links to the show page for each user' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit '/login'
        fill_in(:username, :with => "The Batman")
        fill_in(:password, :with => "darknightrises")
        click_button 'Log In'
        
        visit "/users"
        
        expect(page.body).to include('</a>')
        expect(page.body).to include("/users/#{user1.slug}")
        expect(page.body).to include("/users/#{user2.slug}")
      end
    end
    
    context 'logged out' do
      it 'does not show the user index page when not logged in' do
        user1 = User.create(:username => "The Joker", :email => "jokerking50@gmail.com", :password => "jokerrules")
        user2 = User.create(:username => "The Batman", :email => "thebatman100@gmail.com", :password => "darknightrises")
        
        visit "/users"
        
        expect(page.current_path).to eq('/login')
      end
    end
  end
  
end