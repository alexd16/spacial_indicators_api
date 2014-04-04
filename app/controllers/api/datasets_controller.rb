class Api::DatasetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    render json: Dataset.all
  end

  def show
    dataset = Dataset.find(params[:id])
    render json: dataset
  end

  def data
    dataset = Dataset.find(params[:id])
    render json: dataset.data
  end

  def create
    dataset = Dataset.create(name: params[:name])
    data = process_data(params[:file])
    dataset.insert_data(data)
    head :ok, content_type: 'text/html'
  end

  private 

  def process_data(file)
    SmarterCSV.process(file.path)
  end
end
