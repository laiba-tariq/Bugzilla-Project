# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def index?
    true
  end

  def new?
    @user.manager?
  end

  def create?
    @user.manager?
  end

  def show?
    @project.created_by == @user.id if @project.present?
  end

  alias update? show?
  alias destroy? show?
  alias add_user? show?
  alias remove_user? show?
  class Scope < Scope
    def resolve
      case @user&.role&.to_sym
      when :manager
        scope.where(created_by: @user.id)
      when :qa
        scope.all
      when :developer
        @user.projects
      else
        scope.none
      end
    end
  end
end
