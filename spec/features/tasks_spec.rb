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
    
    describe "Page with some tasks", js: true do
      before :each do
        @first = TaskInteractors::CreateTask.new("First task").run
        @second = TaskInteractors::CreateTask.new("Second task").run
        @third = TaskInteractors::CreateTask.new("Third task").run
        TaskInteractors::CompleteTask.new(@third.id).run
        visit tasks_path
      end
      
      it "Edits a task"
      
      it "Completes a task" do
        check("t#{@first.id}")
        expect(page).to have_css("ul#complete-tasks li#L#{@first.id}")
      end
      
      it "Reopens a task" do
        uncheck("t#{@third.id}")
        expect(page).to have_css("ul#incomplete-tasks li#L#{@third.id}")
      end
      
      it "Deletes a task" do
        within("li#L#{@first.id}") do
          click_link("(remove)")
        end
        page.evaluate_script('window.confirm = function() { return true; }')
        expect(page).not_to have_content("First task")
      end
      
      # it "Repositions a task" do
      #   drag_to find("li#L#{@second.id} span"), find("li#L#{@first.id}")
      #   order = all('li').map {|each| each.text}
      # end
    end
  end
end
