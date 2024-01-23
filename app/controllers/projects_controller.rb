# frozen_string_literal: true

class ProjectsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy add_user remove_user]
  before_action :authorize_project, except: %i[index create qa_projects]
  before_action :authenticate_user!
  def index
    @projects = policy_scope(Project)
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end
  def new
    @project = Project.new
    authorize_project
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    @project.created_by = current_user.id
    if @project.save
      @projects = policy_scope(Project)
      update_page
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity
    @project = Project.find(params[:id])
    if project_params[:add_user_form].present?
      selected_user_ids = project_params[:id].reject(&:empty?).map(&:to_i)
      new_user_ids = selected_user_ids - @project.user_ids
      @project.users << User.where(id: new_user_ids)
      @projects = policy_scope(Project)
      update_page
    elsif project_params[:remove_user_form].present?
      selected_user_ids = project_params[:id].reject(&:empty?)
      @project.users.delete(User.where(id: selected_user_ids))
      update_page
    elsif @project.update(project_params.except(:id))
      @projects = policy_scope(Project)
      update_page
    else
      render 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  def add_user
    @developers = User.where(role: User.roles[:developer])
    @qas = User.where(role: User.roles[:qa])
  end

  def remove_user
    @developers = @project.users.where(role: User.roles[:developer])
    @qas = @project.users.where(role: User.roles[:qa])
  end

  # def qa_projects
  #   user_id = current_user.id
  #   @qa_projects = Project.where(id: UserProject.where(user_id: user_id).pluck(:project_id))
  #   render 'qa_projects'
  # end

  private

  def set_project
    @project = Project.find(params[:id])
    authorize_project
  end

  def project_params
    params.require(:project).permit(:name, :description, :add_user_form ,:remove_user_form,id: [])
  end

  def authorize_project
    authorize @project if @project.present?
  end

  def update_page
    render turbo_stream: [
      turbo_stream.replace('second_frame', partial: 'project', locals: { projects: @projects }),
      turbo_stream.remove('project')
    ]
  end
end
