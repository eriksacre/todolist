require 'spec_helper'

feature "Tasks" do
  describe "Blank tasks page", js: true do
    before :each do
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in 'email', with: @user.email
      fill_in 'password', with: 'secret'
      click_button 'Log In'
      expect(page).to have_content("Logged in")
    end
    
    it "Shows 'to do' and 'completed'" do
      visit tasks_path
      expect(page).to have_content("To do")
      expect(page).to have_content("Completed")
    end
    
    it "Creates a new task" do
      visit tasks_path
      click_link 'Add task'
      fill_in 'task[title]', with: 'My first task'
      click_button 'Create Task'
      expect(page).to have_css('ul#incomplete-tasks li')
      expect(page).to have_content("My first task")
    end
    
    it "Does not create a task with invalid title" do
      visit tasks_path
      click_link 'Add task'
      fill_in 'task[title]', with: ''
      catch_alert do
        click_button 'Create Task'
        wait_for_ajax
      end
      expect(@last_alert_message).to have_content('Title')
    end
    
    context "Completed tasks" do
      def produce_completed_tasks(quantity)
        1.upto(quantity) do |n|
          task = TaskInteractors::CreateTask.new("Task #{n}").run
          TaskInteractors::CompleteTask.new(task.id).run
        end
      end
      
      it "Does not show 'more' when there are 2 completed items" do
        produce_completed_tasks(2)
        visit tasks_path
        expect(page).not_to have_content('Show more')
      end
      
      it "Has a 'more' link when there are 4 completed items" do
        produce_completed_tasks(4)
        visit tasks_path
        expect(page).to have_content('Show more')
        expect(page).not_to have_content('Task 1')
      end
      
      it "Shows all tasks when clicking 'more'" do
        produce_completed_tasks(4)
        visit tasks_path
        click_link('Show more')
        expect(page).to have_content('Task 1')
        expect(page).not_to have_content('Show more')
      end
    end
    
    describe "Page with some tasks", js: true do
      before :each do
        @first = TaskInteractors::CreateTask.new("First task").run
        @second = TaskInteractors::CreateTask.new("Second task").run
        @third = TaskInteractors::CreateTask.new("Third task").run
        TaskInteractors::CompleteTask.new(@third.id).run
        visit tasks_path
      end
      
      it "Edits a task" do
        within("li#L#{@first.id}") do
          click_link('Edit')
          expect(page).to have_content('Title')
          fill_in 'task[title]', with: 'Modified task'
          click_button 'Update Task'
          expect(page).to have_content('Modified task')
          expect(page).not_to have_content('Title')
        end
      end
      
      it "Cancels the edit of a task" do
        within("li#L#{@first.id}") do
          click_link('Edit')
          expect(page).to have_content('Cancel')
          click_link('Cancel')
          expect(page).to have_content('First task')
          expect(page).not_to have_content('Title')
        end
      end
      
      it "Edits a task with an invalid value" do
        within("li#L#{@first.id}") do
          click_link('Edit')
          expect(page).to have_content('Title')
          fill_in 'task[title]', with: ''
          click_button 'Update Task'
          expect(page).to have_content("Title can't be blank")
        end
      end
      
      it "Completes a task" do
        check("t#{@first.id}")
        expect(page).to have_css("ul#complete-tasks li#L#{@first.id}")
        expect(page).not_to have_css("ul#incomplete-tasks li#L#{@third.id}")
      end
      
      it "Reopens a task" do
        uncheck("t#{@third.id}")
        expect(page).not_to have_css("ul#complete-tasks li#L#{@first.id}")
        expect(page).to have_css("ul#incomplete-tasks li#L#{@third.id}")
      end
      
      it "Deletes a task" do
        positive_confirmation
        within("li#L#{@first.id}") do
          click_link("(remove)")
        end
        expect(page).not_to have_content("First task")
      end
      
      it "Does not complete a completed task" do
        # Some other user completes the task
        @first = TaskInteractors::CompleteTask.new(@first.id).run
        catch_alert do
          check("t#{@first.id}")
          wait_for_ajax
        end
        expect(@last_alert_message).to have_content('already completed')
      end
      
      it "Does not crash when trying to edit a deleted task" do
        @first = TaskInteractors::DeleteTask.new(@first.id).run
        catch_alert do
          within("li#L#{@first.id}") do
            click_link('Edit')
          end
          wait_for_ajax
        end
        expect(@last_alert_message).to have_content('find Task')
      end
      
      it "Does not crash when trying to edit a completed task" do
        @first = TaskInteractors::CompleteTask.new(@first.id).run
        catch_alert do
          within("li#L#{@first.id}") do
            click_link('Edit')
          end
          wait_for_ajax
        end
        expect(@last_alert_message).to have_content('Cannot modify completed task')
      end
      
      it "Does not crash when trying to update a completed task" do
        within("li#L#{@first.id}") do
          click_link('Edit')
        end
        expect(page).to have_content('Title')
        
        @first = TaskInteractors::CompleteTask.new(@first.id).run
        catch_alert do
          fill_in 'task[title]', with: 'Modified text'
          click_button 'Update Task'
          wait_for_ajax
        end
        expect(@last_alert_message).to have_content('Cannot modify completed task')
      end
      
      it "Repositions a task" do
        # As I do not have a good solution to test drag & drop, we will
        # start from the code that is fired by the dnd event
        page.evaluate_script('window.list.changePosition($("#L2"), 0)')
        wait_for_ajax
        @first.reload
        expect(@first.position).to eq(1)
      end
    end
  end
end
