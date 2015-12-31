Puppet::Type.newtype :wordpress_http, :is_capability => true do
  newparam :name, :is_namevar => true
  newparam :host
  newparam :port
  newparam :ip
end
