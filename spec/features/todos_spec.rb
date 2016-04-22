require 'rails_helper'

feature 'Manage todos on the list', js: true do
  scenario 'We can add a new task' do
    visit root_path
    fill_in 'todo_title', with: 'Get out of bed'
    page.execute_script("$('form#new_todo').submit();")
    expect(page).to have_content('Get out of bed')
  end
end
