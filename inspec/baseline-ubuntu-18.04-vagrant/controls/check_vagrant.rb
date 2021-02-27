# copyright: 2021, Urs Voegele

title "check vagrant"

# check vagrant command
control "vagrant-1.0" do                           # A unique ID for this control
  impact 1.0                                       # The criticality, if this control fails.
  title "check if vagrant command exists"          # A human-readable title
  desc "check vagrant command"
  describe command('vagrant version') do
    its('exit_status') { should eq 0 }
  end
end
