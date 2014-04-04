class Api::ContextsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    render json: Context.all
  end

  def show
    render json: Context.find(params[:id])
  end

  def create
    context = Context.create(params.require(:context).permit!)
    context.compute_indicators
    head :ok, content_type: 'text/html'
  end
end
