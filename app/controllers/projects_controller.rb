# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[edit update destroy show]

  def index
    @pagy, @projects = pagy(policy_scope(Project.order(:id)))
    authorize_project
  end

  def show
    authorize @project
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
      update_page
      flash[:notice] = 'Project was successfully created.'
    else
      flash[:alert] = 'Project creation failed.'
      render :new
    end
  end

  def edit; end

  def update
    byebug
    if @project.update(project_params.except(:id))
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
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
  end

  def project_params
    params.require(:project).permit(:name, :description, :add_user_form, :remove_user_form, id: [])
  end

  def authorize_project
    authorize @projects
  end

  def update_page
    render turbo_stream: [
      turbo_stream.replace('project_frame', partial: 'project', locals: { projects: @projects }),
      turbo_stream.remove('project')
    ]
  end
end
