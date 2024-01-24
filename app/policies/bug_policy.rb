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

  def update?
    user.developer?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
