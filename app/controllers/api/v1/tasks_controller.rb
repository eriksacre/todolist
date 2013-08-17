module Api
  module V1
    class TasksController < Api::ApiController
      def index
        @tasks = Task.all
      end
      
      def show
        @task = Task.find(params_id)
      end
      
      def create
        @task = ac(:create_task, params[:title])
        render "show", status: :created
      end
      
      def update
        @task = find_business_method(params[:task]) do |method, params|
          method.contains(:title) { ac(:update_task, params_id, params[:title]) }
          method.contains(:position) { ac(:update_task_position, params_id, [:position]) }
          method.contains(:completed) { params[:completed] ? ac(:reopen_task, params_id) : ac(:complete_task, params_id) }
        end
        render "show"
      end
      
      def destroy
        Task.destroy(params_id)
        render nothing: true, status: :no_content
      end
      
      private
        def task_params
          params.require(:task).permit(:title, :completed, :position)
        end
    end
  end
end
