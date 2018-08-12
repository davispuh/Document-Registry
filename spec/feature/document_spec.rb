require 'tempfile'

def create_document_data(extra_name = '')
    { name: "Some#{extra_name} book", description: "Book#{extra_name} description" }
end

def create_document(extra_name = '')
  doc = Document.create!(create_document_data(extra_name))
  Tempfile.open('book') do |book_file|
    doc.files.attach(io: book_file, filename: 'book.pdf')
    doc.files.attach(io: book_file, filename: 'book2.pdf')
  end
  doc
end

feature "Document list" do

  given(:document1) { create_document(1) }
  given(:document2) { create_document(2) }

  background do
    document1
    document2
  end

  scenario "contains documents" do
    visit root_path
    expect(page).to have_content document1.name
    expect(page).to have_content document1.description
    expect(page).to have_content document2.name
    expect(page).to have_content document2.description
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

def test_document_upload
  fill_in 'document_name', with: test_document[:name]
  fill_in 'document_description', with: test_document[:description]

  Tempfile.open('file1') do |file1|
      Tempfile.open('file2') do |file2|
        attach_file('document_files', [file1.path, file2.path])
        find(:xpath, "//input[@type='submit']").click()
        expect(page).to have_selector '#notice'
        expect(page).to have_content test_document[:name]
        expect(page).to have_content test_document[:description]
        expect(page).to have_content File.basename(file1.path)
        expect(page).to have_content File.basename(file2.path)
      end
  end
end

feature "New document" do

  given(:test_document) { create_document_data('test') }

  scenario "create a new document" do
    visit new_document_path

    test_document_upload
  end

end

feature "Document detailed view" do

  given(:document) { create_document }
  given(:document2) { create_document(2) }

  scenario "contains document details" do
    visit document_path(document)
    expect(page).to have_content document.name
    expect(page).to have_content document.description
    expect(page).to have_content document.files.first.filename
    expect(page).to have_content document.files.last.filename
  end

  scenario "can edit document" do
    visit document_path(document)
    find(:xpath, "//a[@href='#{edit_document_path(document)}']").click()
    expect(page).to have_xpath("//input[@name='document[name]'][@value='#{document.name}']")
  end

  scenario "can delete document", js: true do
      document
      document2

      visit documents_path
      expect(page).to have_content document.name
      expect(page).to have_content document2.name

      visit document_path(document)
      expect(page).to have_content document.name
      expect(page).to have_no_content document2.name

      page.accept_alert do
          find(:xpath, "//a[@data-method='delete']").click()
      end

      expect(page).to have_content document2.name
      expect(page).to have_no_content document.name
  end

end

feature "Edit document" do
  given(:document) { create_document }
  given(:test_document) { create_document_data('test') }

  scenario "can edit document and add file" do
    visit edit_document_path(document)

    expect(page).to have_xpath("//input[@name='document[name]'][@value='#{document.name}']")

    filename = document.files.first.filename
    expect(page).to have_content filename

    test_document_upload

    expect(page).to have_no_content document.name
    expect(page).to have_content test_document[:name]
    expect(page).to have_content filename
  end

  scenario "can delete file" do
    visit edit_document_path(document)
    filename = document.files.first.filename

    expect(page).to have_link filename

    find("a", :text => filename).find(:xpath, "./../a[starts-with(@href, '#{document_path(document)}')]").click()

    expect(page).to have_no_link filename
  end
end
