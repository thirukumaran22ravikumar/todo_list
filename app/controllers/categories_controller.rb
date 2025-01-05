class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workspace
    before_action :authenticate_workspace!
    # GET /workspaces/:workspace_id/categories
    def index
      @categories = @workspace.categories
      render json: @categories
    end
  
    # POST /workspaces/:workspace_id/categories
    def create
      @category = @workspace.categories.new(category_params)
  
      if @category.save
        render json: @category, status: :created
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end
  
    # PUT /workspaces/:workspace_id/categories/:id
    def update
      @category = @workspace.categories.find(params[:id])
  
      if @category.update(category_params)
        render json: @category
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /workspaces/:workspace_id/categories/:id
    def destroy
      @category = @workspace.categories.find(params[:id])
      @category.destroy
      render json: { message: 'Category deleted successfully' }, status: :ok
    end
  
    private
    def authenticate_workspace!
      # Extract workspace_id from URL
      url_workspace_id = params[:workspace_id]
      p url_workspace_id.to_s+"-------------------url_workspace_id"
      # Extract the x-workspace header
      header_workspace_api_key = request.headers['x-workspace']
  
      if header_workspace_api_key.blank?
        render json: { error: 'Missing x-workspace header' }, status: :unauthorized and return
      end
  
      # Find the workspace by ID from URL
      workspace = Workspace.find_by(id: url_workspace_id)

      # Verify the API key matches the workspace from the URL
      if workspace.api_key != header_workspace_api_key
        render json: { error: 'Workspace mismatch: API key does not match workspace ID' }, status: :unauthorized and return
      end
  
      # Ensure the user belongs to the workspace
      unless workspace.users.exists?(id: current_user.id)
        render json: { error: 'User does not belong to this workspace' }, status: :forbidden and return
      end
  
      # Set the workspace for use in the action
      @current_workspace = workspace
    end
    def set_workspace
      @workspace = current_user.workspaces.find(params[:workspace_id])
      p @workspace
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Workspace not found' }, status: :not_found
    end
  
    def category_params
      params.require(:category).permit(:name)
    end
  end
  