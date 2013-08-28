require 'spec_helper'

feature "Activities" do
  
  before :each do
    login
  end
  
  scenario "Viewing empty activities page" do
    visit activities_path
    expect(page).to have_content("There are no activities yet")
  end
  
  scenario "Page can be reached from tasks page" do
    visit tasks_path
    click_link 'Activities'
    expect(page).to have_content("Activity feed")
  end
  
  scenario "Activities page should have link to tasks" do
    visit activities_path
    click_link 'Return to tasks'
    expect(page).to have_content('Add task')
  end
  
  scenario "Page having some activities" do
    t1 = TaskInteractors::CreateTask.new(@user, "First task").run
    t2 = TaskInteractors::CreateTask.new(@user, "Second task").run
    t3 = TaskInteractors::CreateTask.new(@user, "Third task").run
    TaskInteractors::UpdateTask.new(@user, t1.id, "First ammended task").run
    TaskInteractors::CompleteTask.new(@user, t2.id).run
    TaskInteractors::UpdateTaskPosition.new(@user, t1.id, 1).run
    TaskInteractors::ReopenTask.new(@user, t2.id).run
    TaskInteractors::DeleteTask.new(@user, t3.id).run
    
    visit activities_path
    expect(page).to have_content('First task')
    expect(page).to have_content('First ammended task')
  end
end