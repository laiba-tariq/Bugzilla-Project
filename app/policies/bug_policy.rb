class BugPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    @user.qa?
  end

  def show?
    @user.developer? && (@user.projects.ids.include? @record.project_id)
  end

  def edit?
    user.developer? # Or whatever condition is required for editing bugs
  end

  def assign_to_dev?
    user.developer?
  end

  def start_working?
    @user.id == @record.assigned_to
  end

  def mark_complete?
    start_working?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
