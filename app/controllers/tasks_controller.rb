class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workspace
    # before_action :authorize_workspace_access
    before_action :set_category, only: [:index, :create]
    before_action :set_task, only: [:show, :update, :destroy]
    before_action :authorize_task_access, only: [:show, :update, :destroy]
  
    # GET /workspaces/:workspace_id/tasks
    def index
      @tasks = @category ? @category.tasks : @workspace.tasks_through_categories
  
      # Filter by category if `category_id` is provided
      if params[:category_id].present?
        @tasks = @tasks.where(category_id: params[:category_id])
      end
  
      # Sort by priority, due_date, or other fields if `sort_by` is provided
      if params[:sort_by].present?
        @tasks = @tasks.order(params[:sort_by])
      end
  
      render json: @tasks
    end
  
    # GET /workspaces/:workspace_id/tasks/:id
    def show
      render json: @task
    end
  
    # POST /workspaces/:workspace_id/tasks
    def create
        @category = @workspace.categories.find_by(id: task_params[:category_id])
        unless @category
          return render json: { error: 'Category not found in this workspace' }, status: :not_found
        end
      
        @task = @category.tasks.new(task_params)
        @task.assignee = User.find_by(id: params[:assignee_id]) if params[:assignee_id]
      
        if @task.save
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end
      
  
    # PUT /workspaces/:workspace_id/tasks/:id
    def update
      if @task.update(task_params)
        render json: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /workspaces/:workspace_id/tasks/:id
    def destroy
      @task.destroy
      render json: { message: 'Task deleted successfully' }, status: :ok
    end
  
    private
  
    def set_workspace
      @workspace = current_user.workspaces.find(params[:workspace_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Workspace not found' }, status: :not_found
    end
  
    def set_category
      @category = @workspace.categories.find_by(id: params[:category_id]) if params[:category_id].present?
    end
  
    def set_task
      @task = Task.find_by(id: params[:id], category: @workspace.categories)
      render json: { error: 'Task not found' }, status: :not_found unless @task
    end
  
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :priority, :remind_before_at, :completion_status, :assignee_id, :category_id)
    end
  
    # def authorize_workspace_access
    #   unless @workspace.users.include?(current_user)
    #     render json: { error: 'You do not have access to this workspace' }, status: :forbidden
    #   end
    # end
  
    def authorize_task_access
      unless @task.assignee == current_user 
        render json: { error: 'You do not have access to this task' }, status: :forbidden
      end
    end
  end
  