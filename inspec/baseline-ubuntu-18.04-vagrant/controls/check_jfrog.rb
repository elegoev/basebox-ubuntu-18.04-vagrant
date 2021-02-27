# copyright: 2021, Urs Voegele

title "check jfrog"

# check jfrog command
control "jfrog-1.0" do                         # A unique ID for this control
  impact 1.0                                   # The criticality, if this control fails.
  title "check if jfrog command exists"        # A human-readable title
  desc "check jfrog command"
  describe command('jfrog --version') do
    its('exit_status') { should eq 0 }
  end
end
