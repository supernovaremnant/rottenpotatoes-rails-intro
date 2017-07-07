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
    
    @all_ratings = Movie::RATINGS 
    if session[:ratings].nil? 
      if !params[:ratings].nil?
        session[:ratings] = params[:ratings]
        @filter_base = params[:ratings]
      end
    else 
      if params[:ratings].nil?
        @filter_base = session[:ratings]
      else
        # update session and var given the parameters
        if session[:ratings] != params[:ratings]
          session[:ratings] = params[:ratings]
        end
        @filter_base = session[:ratings]
      end
    end
    
    @checked_list = Array.new( @all_ratings.size, true)
      
    if @filter_base.present?
      @query = Array.new 
      @all_ratings.each_with_index do |r, idx|
        if @filter_base["#{r}"].eql? "1"
          @query.push("#{r}")
          @checked_list[idx] = true
        else
          @checked_list[idx] = false
        end
      end
      @movies = Movie.where( :rating => @query )
    else 
      @movies = Movie.all
    end 
    
    @title = ""
    @date = ""
    
    if session[:sort_base].nil? 
      if !params[:sort_base].nil?
        session[:sort_base] = params[:sort_base]
        @sort_base = params[:sort_base]
      end
    else 
      if params[:sort_base].nil?
        @sort_base = session[:sort_base]
      else
        # update session and var given the parameters
        if session[:sort_base] != params[:sort_base] 
          session[:sort_base] = params[:sort_base]
        end
        @sort_base = session[:sort_base]
      end
    end
    
    if @sort_base == "title" 
      @movies = @movies.order(:title)
      @title = "hilite"
    elsif @sort_base == "date" 
      @movies = @movies.order(:release_date)
      @date = "hilite"
    else 
      # no sorting 
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
