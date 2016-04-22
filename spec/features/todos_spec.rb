require 'rails_helper'

feature 'Manage todos on the list', js: true do
  def create_todo(title)
    visit root_path
    fill_in 'todo_title', with: title
    page.execute_script("$('form#new_todo').submit();")
  end

  scenario 'We can add a new task' do
    title = "Catch a few capybaras"
    create_todo(title)
    expect(page).to have_content('Catch a few capybaras')
  end

  scenario 'todo count change' do
    title = "I can has cheeseburgers"
    create_todo(title)
    expect( page.find(:css, 'span#todo-count').text ).to eq "1"
  end

  scenario 'The completed counter updates when completing tasks' do
    title = 'Get out of bed'
    create_todo(title)

    expect( page.find(:css, 'span#completed-count').text ).to eq "0"
    check "todo-1"

    expect( page.find(:css, 'span#todo-count').text ).to eq "0"
    expect( page.find(:css, 'span#completed-count').text ).to eq "1"
  end


  describe "counts" do
    before :each do 
      title = "Be Batman"
      title2 = "Fuck up Superman"
      title3 = "mouthwash Ironman"
      create_todo(title)
      create_todo(title2)
      create_todo(title3)
    end

    scenario 'creating & checking counts' do
      expect( page.find(:css, 'span#todo-count').text ).to eq "3"
      expect( page.find(:css, 'span#completed-count').text ).to eq "0"
      check "todo-1"
      check "todo-2"
      expect( page.find(:css, 'span#completed-count').text ).to eq "2"
      expect( page.find(:css, 'span#total-count').text ).to eq "3"
    end

    scenario 'creating & checking counts' do
      check "todo-1"
      check "todo-2"
      check "todo-3"
      click_link("clean-up")
      expect( page.find(:css, 'span#total-count').text ).to eq "0"
    end
  end
end
