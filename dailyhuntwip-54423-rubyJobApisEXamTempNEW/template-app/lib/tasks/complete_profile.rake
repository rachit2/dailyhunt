namespace :notify_for_profile_completion do
  desc "Please complete Your profile"
  task :update => [:environment] do
    BxBlockDesktopnotifications::NotifyToCompleteProfileJob.perform_later
  end
end