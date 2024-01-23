# app/controllers/project_users_controller.rb
class UserProjectsController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @user_project = UserProject.new
    @remaining_users = User.where.not(id: @project.users.pluck(:id))

  end

  def create
    @user_project = @project.user_projects.build(user_project_params)

    respond_to do |format|
      if @user_project.save
        format.html { redirect_to @projects, notice: 'User added to project.' }
        format.js
      else
        format.html { render :new }
        format.js { render :error }
      end
    end
  end

  def destroy
    @user_project = @project.user_projects.find(params[:id])
    @user_project.destroy

    respond_to do |format|
      format.html { redirect_to @project, notice: 'User removed from project.' }
      format.js
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
