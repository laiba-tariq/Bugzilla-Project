# app/services/bug_updater_service.rb
class BugUpdaterService
  def initialize(bug, params)
    @bug = bug
    @params = params
  end

  def update_status
    case @params[:status]
    when 'Started'
      update_started_status
    when 'Feature', 'Bug'
      update_bug_type
      update_page
    else
      false
    end
  end

  private

  def update_started_status
    @bug.update_attribute(:status, 'Started')
  end

  def update_bug_type
    @bug.update_attributes(bug_type: @params[:status], status: bug_status_for_type(@params[:status]))
  end

  def bug_status_for_type(bug_type)
    byebug
    bug_type == 'Feature' ? 'Completed' : 'Resolved'
  end

  def update_page
    @bugs = Bug.where(project_id: @params[:project_id])
    render_turbo_stream
  end

  def render_turbo_stream
    TurboStreamRenderer.new('second_frame', template: 'bugs/index', locals: { bug: @bugs })
                       .replace('second_frame')
                       .remove('project')
  end
end
