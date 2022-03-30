require "rails_helper"

describe "complete_profile.rake" do
  it "Enqueue a job" do
    expect {
      Rake::Task["notify_for_profile_completion:update"].invoke
    }.to have_enqueued_job(BxBlockDesktopnotifications::NotifyToCompleteProfileJob)
  end
end
