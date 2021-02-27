# copyright: 2021, Urs Voegele

title "check virtualbox"

# check virtualbox command
control "virtualbox-1.0" do                    # A unique ID for this control
  impact 1.0                                   # The criticality, if this control fails.
  title "check if virtualbox command exists"   # A human-readable title
  desc "check virtualbox command"
  describe command('vboxmanage --version') do
    its('exit_status') { should eq 0 }
  end
end

# check virtualbox service
control "virtualbox-2.0" do                     # A unique ID for this control
  impact 1.0                                    # The criticality, if this control fails.
  title "check if virtualbox is running"        # A human-readable title
  desc "check virtualbox service"
  describe service('vboxdrv') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

# check virtualbox service
control "virtualbox-3.0" do                     # A unique ID for this control
  impact 1.0                                    # The criticality, if this control fails.
  title "check if virtualbox is running"        # A human-readable title
  desc "check virtualbox service"
  describe service('vboxweb-service') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
