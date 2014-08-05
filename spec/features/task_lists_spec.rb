require 'rails_helper'
require 'capybara/rails'

feature 'Task lists' do
  before :each do
    create_user email: "user@example.com"
    TaskList.create!(name: "Work List")
    TaskList.create!(name: "Household Chores")

    visit signin_path
    click_on "Login"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "password"
    click_on "Login"
  end

  scenario 'User can view task lists' do
    expect(page).to have_content("Work List")
    expect(page).to have_content("Household Chores")
  end

  scenario 'User see an about page' do
    visit signin_path
    click_on "about"
    expect(page).to have_content("Lorem ipsum")
  end

  scenario 'user can sign in and click an "+ Add Task List" link to see the add tasks form' do
    expect(page).to have_link("Add Task List")

    click_link "Add Task List"
    expect(page).to have_content("Add a task list")
  end

  scenario 'user can create a new task and see it appear on the signed-in root' do
    click_link "Add Task List"
    fill_in "task_list_name", with: "test task list"
    click_button "Create Task list"
    expect(page).to have_content "test task list"
    expect(page).to have_content "Task List was created successfully!"
  end

  scenario 'when a user enters a blank task they get the proper error message' do
    click_link "Add Task List"
    click_button "Create Task list"
    expect(page).to have_content "Your task list could not be created"
  end

  scenario 'Edit patches a task_list and cannot take blanks' do
    first('.task-list').click_link('Edit')
    expect(page).to have_content "Household Chores"
    fill_in "task_list_name", with: "sitting around"
    click_button "Update Task list"
    expect(page).to have_content "sitting around"
  end

  scenario 'user can add a task via "new task" link' do
    first('.task-list').click_link('+ Add Task')
    expect(page).to have_content "Due Date"
  end

end