# frozen_string_literal: true

class BugsController < ApplicationController # rubocop:disable Style/Documentation,Metrics/ClassLength
  before_action :authenticate_user!
  before_action :set_bug, only: %i[edit update destroy assign_to_dev start_working mark_complete]
  before_action :authorize_bug, except: %i[index assigned_bugs]
  before_action :set_bugs, only: [:show]
  # GET /projects/:project_id/bugs
  def index
    @bugs = policy_scope(Bug)
    @bugs = Bug.get_project(params[:project_id])

    authorize @bugs
  end

  # GET /projects/:project_id/bugs/1
  def show
    @project_id = params[:project_id]
    @bugs = Bug.get_project(params[:project_id])
    authorize @bugs
  end

  # GET /projects/:project_id/bugs/new
  def new
    authorize_bug
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build(bug_status: :New)
  end

  # POST /projects/:project_id/bugs
  def create # rubocop:disable Metrics/MethodLength
    @bug = Bug.new(bug_params)
    if @bug.save
      @projects = policy_scope(Project)
      render turbo_stream: [
        turbo_stream.replace('second_frame', partial: 'projects/project', locals: { projects: @projects }),
        turbo_stream.remove('project')
      ]
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /projects/:project_id/bugs/1/edit
  def edit
    @bug = Bug.find(params[:id])
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
        turbo_stream.replace('project', template: 'bugs/index', locals: { bug: @bugs }),
        turbo_stream.remove('project')
      ]
    else
      redirect_to @bugs, notice: 'Not Assigned'
    end
  end

  def assigned_bugs
    @bugs = Bug.where(id: params[:bug_ids], project_id: params[:project_id])
    @projects = policy_scope(Project)
    render turbo_stream: [
      turbo_stream.update('second_frame', template: 'bugs/assigned_bugs', locals: { bugs: @bugs, projects: @projects }),
      turbo_stream.remove('project')
    ]
    # render 'assigned_bugs'
  end

  def start_working
    authorize_bug
    if @bug.update_attribute(:bug_status, 'Started')
      @bugs = Bug.where(project_id: params[:project_id])

      render turbo_stream: [
        turbo_stream.replace('second_frame', template: 'bugs/index', locals: { bug: @bugs }),
        turbo_stream.remove('project')
      ]
    else
      redirect_to @bugs, notice: 'Not Started'
    end
  end

  def mark_complete
    authorize_bug
    if @bug.update_attribute(:bug_type, 'Feature')
      @bug.update_attribute(:bug_status, 'Completed')
      update_page
    elsif @bug.update_attribute(:bug_type, 'Bug')
      @bug.update_attribute(:bug_status, 'Resolved')
      update_page
    end
  end

  private

  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :screenshot, :deadline, :bug_type, :status, :assigned_to,
                                :creater_id, :project_id, :bugs)
  end

  def update_page
    @bugs = Bug.where(project_id: params[:project_id])
    render turbo_stream: [
      turbo_stream.replace('second_frame', template: 'bugs/index', locals: { bug: @bugs }),
      turbo_stream.remove('project')
    ]
  end


  def authorize_bug
    if @bug.present?
      authorize @bug
    else
      authorize Bug
    end
  end
end
