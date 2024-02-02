# frozen_string_literal: true

class ProjectsController < ApplicationController
  include ExceptionHandlerConcern
  include RenderProject

  before_action :authenticate_user!
  before_action :project, only: %i[edit update destroy show]

  def index
    @pagy, @projects = pagy(policy_scope(Project.order(:id)))
    authorize_project
  end

  def show
    if @project
      authorize @project
      render :show
    else
      flash[:alert] = 'Record not found.'
      redirect_to projects_path
    end
  end

  def new
    @project = Project.new
    authorize @project

    return if current_user.manager?

    flash[:alert] = "You don't have permission to perform this action."
    redirect_to root_path
    nil
  end

  def create
    @project = Project.new(project_params)
    authorize @project
    @project.created_by = current_user.id
    if @project.save
      @projects = policy_scope(Project)
      render_project
      flash[:notice] = 'Project was successfully created.'
    else
      flash[:alert] = 'Project creation failed.'
      render :new
    end
  end

  def edit; end

  def update
    if @project.update(project_params.except(:id))
      redirect_to project_path(@project), notice: 'Project was successfully updated.'
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@project, partial: 'projects/form', locals: { project: @project })
        end
        format.html { render 'edit' }
      end
    end
  end

  def destroy
    if @project
      @user_project.destroy
      flash[:notice] = 'Project removed succesfully.'
    else
      redirect_to projects_path, notice: 'Project was not successfully destroyed.'
      flash[:alert] = 'project not found.'
    end
  end

  private

  def project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :created_by)
  end

  def authorize_project
    authorize @projects
  end

  # def update_page
  #   render turbo_stream: [
  #     turbo_stream.replace('project_frame', partial: 'project', locals: { projects: @projects }),
  #     turbo_stream.remove('project')
  #   ]
  # end
end
