class Api::IndicatorsController < ApplicationController

  def index
    render json: Indicator.all
  end
end
