module Api
  module V1
    class TasksController < Api::ApiController
      respond_to :json
      
      def index
        @tasks = Task.all
      end
      
      def show
        @task = Task.find(params[:id])
      end
      
      def create
        # TODO: Test with error-result + use correct template with success
        respond_with ac(:create_task, params[:title])
      end
      
      def update
        respond_with Task.update(params[:id], task_params)
      end
      
      def destroy
        respond_with Task.destroy(params[:id])
      end
      
      private
        def task_params
          params.require(:task).permit(:title, :completed, :position)
        end
    end
  end
end
