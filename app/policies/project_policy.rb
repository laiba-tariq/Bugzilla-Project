# frozen_string_literal: true

class ProjectPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
  attr_reader :user, :project

  def initialize(user, project) # rubocop:disable Lint/MissingSuper
    @user = user
    @project = project
  end

  def index?
    true
  end

  def create?
    @user.usertype.downcase == "manager"
  end

  def show?
    @project.created_by == @user.id if @project.present?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end

  def add_user?
    show?
  end

  def remove_user?
    show?
  end

  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      case @user.usertype.downcase
      when "manager"
        scope.where(created_by: @user.id)
      when "qa"
        scope.all
      when "developer"
        @user.projects
      else
        scope.none
      end
    end
  end
end
