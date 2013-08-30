class ActivitiesController < ApplicationController
  include SubjectHelper

  def index
    find_subject Task
    @activities = e ActivitiesViewModel.new(@subject)
  end
end
