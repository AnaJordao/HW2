# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @all_ratings = Movie.all_ratings
    sort_by = params[:sort_by] || session[:sort_by]
    @filtering = params[:ratings] || session[:ratings] || {}

    if !params.has_key?(:ratings) && !session.has_key?(:ratings)
      @filtering = @all_ratings    
    end

    if params[:sort_by] != session[:sort_by]
      session[:sort_by] = params[:sort_by]
      flash.keep
      redirect_to :sort_by => params[:sort_by], :ratings => @filtering and return
    end

    if params[:ratings] != session[:ratings]
      session[:ratings] = params[:ratings]
      flash.keep
      redirect_to :sort_by => params[:sort_by], :ratings => @filtering and return
    end


    if sort_by == "title"
      @title_header = "hilite"
    else
      @release_date_header = "hilite"
    end

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