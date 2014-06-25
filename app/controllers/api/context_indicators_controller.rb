class Api::ContextIndicatorsController < ApplicationController


  def show
    render json: ContextIndicator.find(params[:id])
  end

end
