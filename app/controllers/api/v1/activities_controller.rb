module Api
  module V1
    class ActivitiesController < Api::ApiController
      include SubjectHelper

      MAX_ACTIVITIES = 50
      
      def index
        find_subject Task
        @activities = Activity.since(since, MAX_ACTIVITIES, @subject)
      end
      
      private
        def since
          begin
            Time.zone.parse(params[:since])
          rescue
            raise ArgumentError.new("Must provice an Iso8601-formatted 'since'-parameter")
          end
        end
    end
  end
end
