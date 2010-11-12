DataFieldType.create(:name => 'Text Input') unless DataFieldType.find_by_name('Text Input')
DataFieldType.create(:name => 'Textarea') unless DataFieldType.find_by_name('Textarea')

# Create the filters for data fields.
Filter.create(:name => 'Textile') unless filter = Filter.find_by_name('Textile')
Filter.create(:name => 'Markdown') unless filter = Filter.find_by_name('Markdown')

# Create the administrative user.
unless User.find_by_login('admin')
  admin_user = User.create( :login => 'admin', 
                            :email => 'info@jewelicms.com', 
                            :name => 'Administrator', 
                            :password => 'jeweli', 
                            :password_confirmation => 'jeweli')
end