# copyright: 2021, Urs Voegele

title "check vmware tools"

# check vmware tools command
control "vmware_tools-1.0" do                           # A unique ID for this control
  impact 1.0                                       # The criticality, if this control fails.
  title "check if vmware tools command exists"          # A human-readable title
  desc "check vmware tools command"
  describe command('ovftool --version') do
    its('exit_status') { should eq 0 }
  end
end
