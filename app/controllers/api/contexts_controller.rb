class Api::ContextsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :update_notes]

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

  def update_notes
    context = Context.find(params[:id])
    notes = params[:notes]
    context.notes = notes
    context.save
    head :ok, content_type: 'text/html'
  end

  def show
    context = Context.includes(:context_indicators).find(params[:id])
    render json: context.as_json(include: :context_indicators)
  end

  def create
    indicators = params[:context].delete("context_indicators_attributes")
    context = Context.create(params.require(:context).permit!)
    context.context_indicators_attributes = indicators
    binding.pry
    context.compute_indicators
    head :ok, content_type: 'text/html'
  end
end
