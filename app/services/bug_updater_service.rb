# frozen_string_literal: true

class BugUpdaterService
  def initialize(bug, params, assigned_user_id)
    @bug = bug
    @params = params
    @assigned_user_id = assigned_user_id
    p @assigned_user_id
  end

  def execute
    if @bug.status == 'New' && !@bug.assigned_to.nil?
      p 'here1'
      update_started_status
    elsif @bug.status == 'Started' && !@bug.assigned_to.nil?
      p 'here2'
      update_bug_status_completed
    else
      p 'here3'

      update_assigned_user
    end
    render_turbo_stream('project', 'bugs/index', { bugs: @bugs }, 'project')
  end

  private

  def update_started_status
    @bug.update_attribute(:status, 'Started')
  end

  def update_bug_status_completed
    if @bug.update_attribute(:bug_type, 'Feature')
      @bug.update_attribute(:status, 'Completed')
    elsif @bug.update_attribute(:bug_type, 'Bug')
      @bug.update_attribute(:status, 'Resolved')
    end
  end

  def update_assigned_user
    @bug.update_attribute(:assigned_to, @assigned_user_id) if @assigned_user_id
  end

  def render_turbo_stream(replace_target, template, locals, remove_target)
    {
      replace_target: replace_target,
      template: template,
      locals: locals,
      remove_target: remove_target
    }
  end
end
