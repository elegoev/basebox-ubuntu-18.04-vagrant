# copyright: 2021, Urs Voegele

title "check git"

# check git command
control "git-1.0" do                           # A unique ID for this control
  impact 1.0                                   # The criticality, if this control fails.
  title "check if git command exists"          # A human-readable title
  desc "check git command"
  describe command('git version') do
    its('exit_status') { should eq 0 }
  end
end
