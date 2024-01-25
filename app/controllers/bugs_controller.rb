# frozen_string_literal: true

class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bug, only: %i[edit update destroy]
  before_action :authorize_bug, except: %i[index]
  before_action :set_bugs, only: [:show]

  def index
    @bugs = policy_scope(Bug)
    @bugs = Bug.by_project(params[:project_id])

    authorize @bugs
  end

  def show
    @project_id = params[:project_id]
    @bugs = Bug.by_project(params[:project_id])
    authorize @bugs
  end

  def new
    authorize_bug
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build(status: :New)
  end

  def create
    @bug = Bug.new(bug_params)
    if @bug.save
      @projects = policy_scope(Project)
      render turbo_stream: [
        turbo_stream.replace('project_frame', partial: 'projects/project', locals: { projects: @projects }),
        turbo_stream.remove('project')
      ]
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    @bug = Bug.find(params[:id])
    assigned_user_id = current_user.id
    p params[:status]
    bug_updater = BugUpdaterService.new(@bug, params, assigned_user_id)
    turbo_stream_info = bug_updater.execute

    render_turbo_stream(turbo_stream_info) if turbo_stream_info.present?
  end

  def destroy
    @bug.destroy
    redirect_to project_bugs_url, notice: 'Bug was successfully destroyed.'
  end

  private

  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :screenshot, :deadline, :bug_type, :status, :assigned_to,
                                :creater_id, :project_id)
  end

  def render_turbo_stream(info)
    return unless info.is_a?(Hash)

    render turbo_stream: [
      turbo_stream.replace(info[:replace_target], template: info[:template], locals: info[:locals]),
      turbo_stream.remove(info[:remove_target])
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
