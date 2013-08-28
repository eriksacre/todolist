class ActivitiesController < ApplicationController
  def index
    @activities = e ActivitiesViewModel.new
  end
end
