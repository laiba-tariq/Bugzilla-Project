# frozen_string_literal: true

# app/controllers/project_users_controller.rb
class UserProjectsController < ApplicationController
  include ExceptionHandlerConcern

  before_action :project

  def new
    @user_project = UserProject.new
    @users = User.where(role: %w[developer qa])
    @remaining_users = @users.reject(&:manager?) - @project.users
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
    @user_project = @project.user_projects.by_user_id(user_id: params[:id])

    if @user_project
      @user_project.destroy
      flash[:notice] = 'User removed from project.'
    else
      flash[:alert] = 'User project not found.'
    end

    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'User removed from project.' }
    end
  end

  private

  def project
    @project = Project.find(params[:project_id])
  end

  def user_project_params
    params.require(:user_project).permit(:user_id, :project_id)
  end
end
