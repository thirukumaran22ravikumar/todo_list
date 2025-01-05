class WorkspacesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_workspace, only: [:show, :update, :destroy, :add_team_member]
    before_action :authenticate_workspace!, only: [:show , :update, :destroy, :add_team_member]
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
  
    def authenticate_workspace!
      # Extract workspace_id from URL
      url_workspace_id = params[:id]
      puts url_workspace_id.to_s+"-----------------------------hjiij"
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
    def workspace_params
      params.require(:workspace).permit(:name, :url)
    end
  end
  