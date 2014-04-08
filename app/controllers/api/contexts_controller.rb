class Api::ContextsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    ids = JSON.parse(params[:q])["context_ids"] if params[:q]
    contexts = ids ? Context.find(ids) : Context.all
    render json: contexts
  end

  def data
    context = Context.find(params[:id])
    dataset = context.dataset
    render json: dataset.data(context.slice_box.try(:query_predicate))
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
