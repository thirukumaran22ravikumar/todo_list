class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workspace
  
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
  