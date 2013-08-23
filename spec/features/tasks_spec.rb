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
      page.evaluate_script('window.lastAlertMsg = "";')
      page.evaluate_script('window.alert = function(msg) { window.lastAlertMsg = msg; };')
      click_button 'Create Task'
      page.document.should have_selector("body.ajax-completed")
      last_alert_message = page.evaluate_script('window.lastAlertMsg')
      expect(last_alert_message).to have_content('Title')
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
        page.evaluate_script('window.confirm = function() { return true; }')
        within("li#L#{@first.id}") do
          click_link("(remove)")
        end
        expect(page).not_to have_content("First task")
      end
      
      it "Does not complete a completed task" do
        # Some other user completes the task
        @first = TaskInteractors::CompleteTask.new(@first.id).run
        page.evaluate_script('window.lastAlertMsg = "";')
        page.evaluate_script('window.location.reload = function() {};')
        page.evaluate_script('window.alert = function(msg) { window.lastAlertMsg = msg; };')
        check("t#{@first.id}")
        page.document.should have_selector("body.ajax-completed")
        last_alert_message = page.evaluate_script('window.lastAlertMsg')
        expect(last_alert_message).to have_content('already completed')
        # page.save_screenshot('screenshot-comp.png')
      end
      
      it "Does not crash when trying to edit a deleted task" do
        @first = TaskInteractors::DeleteTask.new(@first.id).run
        page.evaluate_script('window.lastAlertMsg = "";')
        page.evaluate_script('window.location.reload = function() {};')
        page.evaluate_script('window.alert = function(msg) { window.lastAlertMsg = msg; };')
        within("li#L#{@first.id}") do
          click_link('Edit')
        end
        page.document.should have_selector("body.ajax-completed")
        last_alert_message = page.evaluate_script('window.lastAlertMsg')
        expect(last_alert_message).to have_content('find Task')
        # page.save_screenshot('screenshot-del.png')
      end
      
      # it "Repositions a task" do
      #   drag_to find("li#L#{@second.id} span"), find("li#L#{@first.id}")
      #   order = all('li').map {|each| each.text}
      # end
    end
  end
end
