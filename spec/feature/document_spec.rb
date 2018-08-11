
feature "Document list" do

  background do
    Document.create!(name: 'MyDoc', description: 'DocDescription')
  end

  scenario "contains a document" do
    visit root_path
    expect(page).to have_content 'MyDoc'
    expect(page).to have_content 'DocDescription'
  end

  scenario "has a link to create new document" do
    visit root_path
    expect(page).to have_xpath("//a[@href='#{new_document_path}']")
  end

  scenario "new document button works" do
    visit root_path
    find(:xpath, "//a[@href='#{new_document_path}']").click()
    expect(page).to have_xpath("//input[@name='document[name]']")
  end

end


feature "New document" do

  scenario "create a new document" do
    visit new_document_path
    fill_in 'document_name', with: 'NewDoc1'
    fill_in 'document_description', with: 'NewDesc1'
    find(:xpath, "//input[@type='submit']").click()
    expect(page).to have_selector("#notice")
    expect(page).to have_content 'NewDoc1'
    expect(page).to have_content 'NewDesc1'
  end

end
