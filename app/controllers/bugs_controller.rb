# frozen_string_literal: true

class BugsController < ApplicationController # rubocop:disable Style/Documentation
  before_action :set_bug, only: %i[show edit update destroy assign_to_dev]
  before_action :authorize_bug, except: [:index]
  # GET /projects/:project_id/bugs
  def index
    @bugs = policy_scope(Bug)
    @bugs = Bug.where(project_id: params[:project_id])
    # authorize @bugs
  end

  # GET /projects/:project_id/bugs/1
  def show
    authorize @bugs
  end

  # GET /projects/:project_id/bugs/new
  def new
    # @project = Project.find(params[:project_id])
    @project = Bug.find(params[:project_id])
    @bug = Bug.new(bug_status: :New)
    @bug = @project.bugs.build
  end

  # POST /projects/:project_id/bugs
  def create
    @bug = Bug.new(bug_params)
    # @bug.creator_id = params[:created_by]
    # @bug.project_id = params[:project_id]

    # respond_to do |format|
    if @bug.save
      @projects = policy_scope(Project)
      render turbo_stream: [
        turbo_stream.replace('second_frame', partial: 'projects/project', locals: { projects: @projects }),
        turbo_stream.remove('project')
      ]
    else
      format.html { render :new }
      format.json { render json: @bug.errors, status: :unprocessable_entity } # Add this line for JSON format
    end
    # end
  end

  # GET /projects/:project_id/bugs/1/edit
  def edit
    @project = Project.find(params[:project_id])
  end

  # PATCH/PUT /projects/:project_id/bugs/1
  def update
    if @bug.update(bug_params)
      redirect_to project_bug_path(@bug.project, @bug), notice: 'Bug was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/:project_id/bugs/1
  def destroy
    @bug.destroy
    redirect_to project_bugs_url, notice: 'Bug was successfully destroyed.'
  end

  def assign_to_dev
    if @bug.update_attribute(:assigned_to, current_user.id)
      @bugs = Bug.where(project_id: params[:project_id])
      render turbo_stream: [
        turbo_stream.replace('second_frame', template: 'bugs/index', locals: { bug: @bugs }),
        turbo_stream.remove('project')
      ]
    end
  end

  private

  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :screenshot, :deadline, :bug_type, :status, :assigned_to,
                                :creater_id, :project_id)
  end

  def authorize_bug
    if @bug.present?
      authorize @bug
    else
      authorize Bug
    end
  end
end
