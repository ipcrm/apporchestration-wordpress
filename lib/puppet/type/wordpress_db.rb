Puppet::Type.newtype :wordpress_db, :is_capability => true do
  newparam :name, :is_namevar => true
  newparam :host
  newparam :port
  newparam :user
  newparam :pass
  newparam :db_name
end
