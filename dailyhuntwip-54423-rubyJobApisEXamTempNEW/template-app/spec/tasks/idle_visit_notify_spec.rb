require "rails_helper"

describe "idle_visit_notify.rake" do
  it "Enqueue a job" do
    expect {
      Rake::Task["notify_to_idle_user:create"].invoke
    }.to have_enqueued_job(BxBlockDesktopnotifications::NotifyIdleUserJob)
  end
end
