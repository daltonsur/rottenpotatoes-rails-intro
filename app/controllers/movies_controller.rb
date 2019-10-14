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
    redirect = false
    if !params.key?(:ratings) && session.key?(:ratings)
      redirect = true
      params[:ratings] = session[:ratings]
    end
    if !params.key?(:sort) && session.key?(:sort)
      redirect = true
      params[:sort] = session[:sort]
    end
    if redirect
      flash.keep
      redirect_to movies_path(params)
      return
    end
    @all_ratings = Movie.ratings
    if params.key?(:ratings)
      begin
        @ratings = params[:ratings].keys
      rescue
        @ratings = params[:ratings]
      end
    else
      @ratings = @all_ratings
    end
    session[:ratings] = @ratings
    if params.key?(:sort)
      @sort = params[:sort]
    else
      @sort = nil
    end
    session[:sort] = @sort
    puts "#{@ratings} and #{@sort}"
    @movies = Movie.where(rating: @ratings).order(@sort)
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
