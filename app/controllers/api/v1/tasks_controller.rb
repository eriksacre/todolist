module Api
  module V1
    class TasksController < Api::ApiController
      def index
        @tasks = Task.all
      end
      
      def show
        @task = Task.find(params[:id])
      end
      
      def create
        @task = ac(:create_task, params[:title])
        render "show", status: :created
      end
      
      def update
        # Should we add specific paths to handle complete, reopen and reposition,
        # or should we check the parameters to determine what to do?
        # RESTfull versus convenient
        @task = ac(:update_task, params[:id], params[:title])
        render "show" # We could choose to send 204 here as well
      end
      
      def destroy
        Task.destroy(params[:id])
        render nothing: true, status: :no_content
      end
      
      private
        def task_params
          params.require(:task).permit(:title, :completed, :position)
        end
    end
  end
end
