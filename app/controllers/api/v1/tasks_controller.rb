module Api
  module V1
    class TasksController < Api::ApiController
      def index
        @tasks = TaskList.new
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
          method.for(:title) { ac(:update_task, params_id, params[:title]) }
          method.for(:position) { ac(:update_task_position, params_id, params[:position]) }
          method.for(:completed) { params[:completed] ? ac(:complete_task, params_id) : ac(:reopen_task, params_id) }
        end
        render "show"
      end
      
      def destroy
        Task.destroy(params_id)
        render nothing: true, status: :no_content
      end
    end
  end
end
