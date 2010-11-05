DataFieldType.create(:name => 'Text Input') unless DataFieldType.find_by_name('Text Input')
DataFieldType.create(:name => 'Textarea') unless DataFieldType.find_by_name('Textarea')

# This should be running in the migration, but it didn't for me, so ... 
Filter.create(:name => 'Textile') unless filter = Filter.find_by_name('Textile')
Filter.create(:name => 'Markdown') unless filter = Filter.find_by_name('Markdown')
Filter.create(:name => 'None') unless filter = Filter.find_by_name('None')

# Create the administrative user.
unless User.find_by_login('admin')
  admin_user = User.create( :login => 'admin', 
                            :email => 'info@jewelicms.com', 
                            :name => 'Administrator', 
                            :password => 'jeweli', 
                            :password_confirmation => 'jeweli')
end