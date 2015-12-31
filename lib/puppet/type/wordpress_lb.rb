Puppet::Type.newtype :wordpress_lb, :is_capability => true do
  newparam :name, :is_namevar => true
  newparam :host
  newparam :port
  newparam :ip
end
