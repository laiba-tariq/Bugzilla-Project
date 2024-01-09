# frozen_string_literal: true

class ProjectsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_project, only: %i[edit update destroy add_user remove_user]
  def index
    @projects = policy_scope(Project)
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.created_by = current_user.id
    puts @project.project_name
    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update  # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    @project = Project.find(params[:id])


    if params[:commit] == 'Add User'
      selected_user_ids = project_params[:id].reject(&:empty?)
      @project.users << User.where(id: selected_user_ids)
    elsif params[:commit] == 'Remove User'
      selected_user_ids = project_params[:id].reject(&:empty?)
      @project.users.delete(User.where(id: selected_user_ids))
    end

    if @project.update(project_params.except(:id))
      redirect_to projects_path, notice: 'Project was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  def add_user
    @developers = User.where('LOWER(usertype) = ?', 'developer'.downcase)
    @qas = User.where('LOWER(usertype) = ?', 'QA'.downcase)
  end

  def remove_user
    @developers = @project.users.where('LOWER(usertype) = ?', 'developer'.downcase)
    @qas = @project.users.where('LOWER(usertype) = ?', 'QA'.downcase)
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_name, :project_description, id: [])
  end
end
