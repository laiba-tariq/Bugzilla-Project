# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy]
  before_action :authorize_project, except: %i[index create]
  before_action :authenticate_user!

  def index
    @projects = policy_scope(Project)
    @project = Project.new
  end

  def show; end

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

  def edit; end

  def update
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

  private

  def set_project
    @project = Project.find(params[:id])
    authorize_project
  end

  def project_params
    params.require(:project).permit(:name, :description, :add_user_form, :remove_user_form, id: [])
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
