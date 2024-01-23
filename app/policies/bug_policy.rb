# frozen_string_literal: true

class BugPolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    user.qa?
  end

  def create?
    @user.qa?
  end

  def show?
    @user.developer? && (@user.projects.ids.include? @record.project_id)
  end

  def edit?
    user.qa?
  end

  def assign_to_dev?
    user.developer?
  end

  def start_working?
    user.developer? && record.assigned_to.present? && record.assigned_to == user.id
  end

  def mark_complete?
    start_working?
  end

  def assigned_bugs
    user.developer?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
