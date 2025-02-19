class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete]
  
  def index
    @tasks = case params[:filter]
             when 'complete'
               Task.complete
             when 'pending'
               Task.pending
             else
               Task.all
             end
  end
  
  def show
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = Task.new(task_params)
    
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render :new
    end
  end
   
  def edit
  end
  
  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully deleted.'
  end
  
  def complete
    @task.update(completed: !@task.completed)
    redirect_to tasks_path, notice: 'Task status updated.'
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:title, :description, :completed)
  end
end