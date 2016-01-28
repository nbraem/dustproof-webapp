namespace :tmp do
  desc "Clear cache and socket files from tmp/ (narrow w/ tmp:cache:clear, tmp:sockets:clear, tmp:capybara:clear, tmp:letter_opener:clear)"
  task clear: ["tmp:cache:clear", "tmp:sockets:clear", "tmp:capybara:clear", "tmp:letter_opener:clear"]

  tmp_dirs = ["tmp/cache",
              "tmp/sockets",
              "tmp/capybara",
              "tmp/letter_opener",
              "tmp/pids",
              "tmp/cache/assets/development",
              "tmp/cache/assets/test",
              "tmp/cache/assets/production"]

  tmp_dirs.each { |d| directory d }

  desc "Creates tmp directories for sessions, cache, sockets, and pids"
  task create: tmp_dirs

  namespace :cache do
    # desc "Clears all files and directories in tmp/cache"
    task :clear do
      FileUtils.rm_rf(Dir["tmp/cache/[^.]*"])
    end
  end

  namespace :sockets do
    # desc "Clears all files in tmp/sockets"
    task :clear do
      FileUtils.rm(Dir["tmp/sockets/[^.]*"])
    end
  end

  namespace :pids do
    # desc "Clears all files in tmp/pids"
    task :clear do
      FileUtils.rm(Dir["tmp/pids/[^.]*"])
    end
  end

  namespace :capybara do
    # desc "Clears all files and directories in tmp/capybara"
    task :clear do
      FileUtils.rm_rf(Dir["tmp/capybara/[^.]*"])
    end
  end

  namespace :letter_opener do
    # desc "Clears all files and directories in tmp/letter_opener"
    task :clear do
      FileUtils.rm_rf(Dir["tmp/letter_opener/[^.]*"])
    end
  end
end
