class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy, :complete]
  
  def index
    @tasks = case params[:filter]
             when 'complete'
               Task.complete
             when 'pending'
               Task.pending
             else
               Task.all
             end
    
    render json: @tasks
  end
  
  def show
    render json: @task
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end
  
  def create
    @task = Task.new(task_params)
    
    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end
  
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @task.destroy
    head :no_content
  end
  
  def complete
    @task.update(completed: !@task.completed)
    render json: @task
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Task not found" }, status: :not_found
  end
  
  def task_params
    params.require(:task).permit(:title, :description, :completed)
  end
end