module Api
  module V1
    # Only implement the happy path.
    # If the happy path fails, it should raise an exception.
    # Exceptions are caught and handled by the Api::ApiController.
    class TasksController < Api::ApiController
      interactor_namespace :task
      
      def index
        @tasks = TaskList.new
        fresh_when last_modified: Task.maximum(:updated_at)
      end
      
      def show
        @task = Task.find(params_id)
        fresh_when @task
      end
      
      def create
        @task = find_business_method(params[:task]) do |method, params|
          method.for(:title) { ac(:create_task, params[:title]) }
        end
        render "show", status: :created, location: api_v1_task_url(@task)
      end
      
      def update
        # Example of different sets of attributes resulting in different business actions
        # method.for(attr-list) tests whether all of the given attributes are part of the request
        # and no additional attributes are provided.
        # If none of the method.for-blocks runs, an exception will be raised indicating the
        # request was invalid.
        @task = find_business_method(params[:task]) do |method, params|
          method.for(:title) { ac(:update_task, params_id, params[:title]) }
          method.for(:position) { ac(:update_task_position, params_id, params[:position]) }
          method.for(:completed) { params[:completed] ? ac(:complete_task, params_id) : ac(:reopen_task, params_id) }
        end
        render "show"
      end
      
      def destroy
        ac(:delete_task, params_id)
        render nothing: true, status: :no_content
      end
    end
  end
end
