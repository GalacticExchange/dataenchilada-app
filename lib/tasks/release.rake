namespace :release do
  desc "Add header of now version release to ChangeLog and bump up version"
  task :prepare do
    raise "Use this task in development only" unless Rails.env.development?

    # Fetch remote
    system("git fetch origin")

    # detect merged PR
    old_version = FluentdUI::VERSION
    pr_numbers = `git log v#{old_version}..origin/master --oneline`.scan(/#[0-9]+/)

    if !$?.success? || pr_numbers.empty?
      puts "Detecting PR failed. Please confirm if any PR were merged after the latest release."
      exit(false)
    end

    # Generate new version
    /\.([0-9]+)\z/.match(old_version)
    old_revision = $1
    new_version = old_version.gsub(/\.#{old_revision}\z/, ".#{old_revision.to_i + 1}")

    # Update ChangeLog
    changelog_filename = Rails.root.join('ChangeLog.md')
    changelog = File.read(changelog_filename)

    pr_descriptions = pr_numbers.map do |number|
      "* [] [#{number}](https://github.com/fluent/fluentd-ui/pull/#{number.gsub('#', '')}) "
    end.join("\n")

    new_changelog = <<-HEADER
## Release #{new_version} - #{Time.now.strftime("%Y/%m/%d")}

#{pr_descriptions}

#{changelog.chomp}
HEADER

    File.open(changelog_filename, "w") {|f| f.write(new_changelog)}

    # Update version.rb
    version_filename = Rails.root.join("lib", "fluentd-ui", "version.rb")
    version_class = File.read(version_filename)
    new_version_class = version_class.gsub(/VERSION = \"#{old_version}\"/, "VERSION = \"#{new_version}\"")

    File.open(version_filename, 'w') {|f| f.write(new_version_class)}

    # Update Gemfile.lock
    system("bundle install")

    puts "ChangeLog, version and Gemfile.lock were updated. New version is #{new_version}."
  end
end
