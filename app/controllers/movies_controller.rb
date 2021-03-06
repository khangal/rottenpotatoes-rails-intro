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
		@all_ratings = Movie.ratings
		
		if params[:ratings].respond_to? 'keys'
			@ratings = params[:ratings].keys 
		else
			@ratings = params[:ratings] || session[:ratings] || @all_ratings
		end
			
    @orderBy = params[:orderBy] || session[:orderBy] || "title"
		
		#save user settings in session
		session[:orderBy] = @orderBy
		session[:ratings] = @ratings

		if (params[:ratings].nil? || params[:orderBy].nil?) && (session[:orderBy] != nil && session[:ratings] != nil)
			redirect_to movies_path(orderBy: session[:orderBy], ratings: session[:ratings])
		end
		# database query
		@movies = Movie.where(rating: @ratings).order(@orderBy + " asc")
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
