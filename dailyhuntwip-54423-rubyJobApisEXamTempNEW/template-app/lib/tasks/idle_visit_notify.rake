namespace :notify_to_idle_user do
  desc "send notification to idle user"
  task :create => [:environment] do
    BxBlockDesktopnotifications::NotifyIdleUserJob.perform_later
  end
end