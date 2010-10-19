DataFieldType.create(:name => 'Text') unless DataFieldType.find_by_name('Text')
DataFieldType.create(:name => 'Rich Text') unless DataFieldType.find_by_name('Rich Text')

# Create the administrative user.
unless User.find_by_login('admin')
  admin_user = User.create( :login => 'admin', 
                            :email => 'info@jewelycms.com', 
                            :name => 'Administrator', 
                            :password => 'jewely', 
                            :password_confirmation => 'jewely')
end