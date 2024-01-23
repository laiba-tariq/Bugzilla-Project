# app/controllers/project_users_controller.rb
class UserProjectsController < ApplicationController
  before_action :set_project

  def new
    @user_project = UserProject.new
    @users = User.where(role: %w[developer qa])
    @remaining_users = @users - @project.users
  end

  def create
    @user_project = @project.user_projects.build(user_project_params)

    respond_to do |format|
      if @user_project.save
        format.html { redirect_to projects_path, notice: 'User added to project.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @user_project = @project.user_projects.find_by(user_id: params[:id])
    @user_project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'User removed from project.' }
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def user_project_params
    params.require(:user_project).permit(:user_id, :project_id)
  end
end
