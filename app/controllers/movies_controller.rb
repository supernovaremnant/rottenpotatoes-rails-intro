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
    @sort_base = params[:sort_base]
    @title = ""
    @date = ""
    @all_ratings = Movie::RATINGS 
    if @sort_base == "title" 
      @movies = Movie.order(:title)
      @title = "hilite"
    elsif @sort_base == "date" 
      @movies = Movie.order(:release_date)
      @date = "hilite"
    else 
      @movies = Movie.all
    end
    
    @filter_base = params[:ratings]

    if @filter_base.present?
      @query = Array.new 
      @all_ratings.each do |r|
        if @filter_base["#{r}"].eql? "1"
          @query.push("#{r}")
        end
      end
      
      @movies = Movie.where( :rating => @query )
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
