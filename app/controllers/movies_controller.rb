# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings                # instance variable that holds all possible ratings
    sort_by = params[:sort_by] || session[:sort_by] # the variable will be defined by session if params are empty
    @filtering = params[:ratings] || session[:ratings] || {}  # the instance variable will be defined by session is params are empty
                                                              # or will be a empty hash if session is empty as well

    # the default is all the check boxes marked (if it's the first time that the user is visiting the site)                                                          
    if !params.has_key?(:ratings) && !session.has_key?(:ratings)
      @filtering = @all_ratings    
    end

    # if params and session are different, session will be defined by params
    # flash will hold the information so it's not lost
    # redirect will lead to the page with the right values
    if params[:sort_by] != session[:sort_by]
      session[:sort_by] = params[:sort_by]
      flash.keep
      redirect_to :sort_by => params[:sort_by], :ratings => @filtering and return
    end

    # if params and session are different, session will be defined by params
    # flash will hold the information so it's not lost
    # redirect will lead to the page with the right values
    if params[:ratings] != session[:ratings]
      session[:ratings] = params[:ratings]
      flash.keep
      redirect_to :sort_by => params[:sort_by], :ratings => @filtering and return
    end

    # it will see if the parameters are title or release_date, it will decide how the list will be sortes
    # hilite is a class that highlight the text, and here will be used to show how the text is being sorted
    if sort_by == "title"
      @title_header = "hilite"
    else
      @release_date_header = "hilite"
    end

    # if @filtering is equal to @all_ratings it's the first time the user entered the site, so @filtering is not a hash
    # if it's different, then @filtering is a hash, so use the method keys
    # the method where is used to find all the movies with the chosen ratings in @filtering
    # and the method order will sort the movies using by title or date, depending in what is stored in sort_by
    if @filtering != @all_ratings
      @movies = Movie.where(rating: @filtering.keys).order(sort_by)
    else
      @movies = Movie.where(rating: @filtering).order(sort_by)
    end
    
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end