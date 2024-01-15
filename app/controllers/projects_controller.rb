# frozen_string_literal: true

class ProjectsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_project, only: %i[edit update destroy add_user remove_user]
  before_action :authorize_project, except: %i[index create qa_projects]

  def index
    @projects = policy_scope(Project)
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    @project.created_by = current_user.id
    if @project.save
      @projects = policy_scope(Project)
      # update
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/PerceivedComplexity
    @project = Project.find(params[:id])
    if params[:project][:add_user_form] == 'true'
      selected_user_ids = project_params[:id].reject(&:empty?).map(&:to_i)
      new_user_ids = selected_user_ids - @project.user_ids
      @project.users << User.where(id: new_user_ids)
      @projects = policy_scope(Project)
    elsif params[:project][:remove_user_form] == 'true'
      selected_user_ids = project_params[:id].reject(&:empty?)
      @project.users.delete(User.where(id: selected_user_ids))
    end

    if @project.update(project_params.except(:id))
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
    @developers = User.where(user_type: User.user_types[:developer])
    @qas = User.where(user_type: User.user_types[:qa])
  end

  def remove_user
    @developers = @project.users.where(user_type: User.user_types[:developer])
    @qas = @project.users.where(user_type: User.user_types[:qa])
  end

  def qa_projects
    user_id = current_user.id
    @qa_projects = Project.where(id: UserProject.where(user_id: user_id).pluck(:project_id))
    render 'qa_projects'
  end


  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:project_name, :project_description, id: [])
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
