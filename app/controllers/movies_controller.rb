class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.order(params[:sort_by])
    @all_ratings =  Movie.get_ratings() #["G","PG","PG-13","R"]
    selected_ratings = params[:ratings] 
    selected_sort = params[:sort_by]
    
    #@ratings_test = selected_ratings
 
    if selected_ratings == nil
      selected_ratings = session[:ratings]
    end
     
    if selected_ratings != nil
      session[:ratings] = params[:ratings]
      selected_ratings = selected_ratings.keys
      @movies = Movie.with_ratings(selected_ratings)
    else
      @movies = Movie.all
    end
    
    if selected_sort != nil
      session[:sort_by] = selected_sort
    else
      selected_sort = session[:sort_by]
    end
    
    @movies = @movies.order(selected_sort)
    
    
    #highlight sorted column
    if selected_sort == "title"
      @title_header = 'hilite'
    elsif selected_sort == 'release_date'
      @release_date_header ='hilite'
    end 
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
