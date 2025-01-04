class WorkspacesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workspace, only: [:show, :update, :destroy, :add_team_member]
  
    # GET /workspaces
    def index
      @workspaces = current_user.workspaces
      render json: @workspaces
    end
  
    # POST /workspaces
    def create
    unless current_user
        return render json: { error: 'Unauthorized' }, status: :unauthorized
    end
      api_key = SecureRandom.hex(16)
      @workspace = Workspace.new(workspace_params.merge(api_key: api_key))
      @workspace.users << current_user
  
      if @workspace.save
        render json: @workspace, status: :created
      else
        render json: @workspace.errors, status: :unprocessable_entity
      end
        
      
    end
  
    # GET /workspaces/:id
    def show
      puts @workspace.inspect
      puts "-----------------------------------"
      render json: @workspace
    end
  
    # PATCH/PUT /workspaces/:id
    def update
      if @workspace.update(workspace_params)
        render json: @workspace
      else
        render json: @workspace.errors, status: :unprocessable_entity
      end
    end
  
    # DELETE /workspaces/:id
    def destroy
      @workspace.destroy
      render json: { message: 'Workspace deleted successfully' }, status: :ok
    end
  
    # POST /workspaces/:id/add_team_member
    def add_team_member
      user = User.find_by(email: params[:email])
      if user
        @workspace.users << user unless @workspace.users.include?(user)
        render json: { message: 'Team member added successfully' }, status: :ok
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  
    private
  
    def set_workspace
      @workspace = current_user.workspaces.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Workspace not found' }, status: :not_found
    end
  
    def workspace_params
      params.require(:workspace).permit(:name, :url)
    end
  end
  