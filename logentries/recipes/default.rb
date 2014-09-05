cookbook_file '/etc/ssl/certs/logentries.all.crt' do
  source 'logentries.all.crt'
  owner 'root'
  group 'root'
  mode 0644
end

node[:deploy].each do |application, deploy|
  template "/etc/rsyslog.d/#{application}_logentries.conf" do
    source 'logentries.conf.erb'
    owner 'root'
    group 'root'
    mode 0755
    variables(
      :token => deploy[:logentries][:token]
    )
  end
end

bash 'install-rsyslog-gnutls' do
  user 'root'
  code 'yum -y install rsyslog-gnutls'
end

bash 'rsyslog-restart' do
  user 'root'
  code 'service rsyslog restart'
end