#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'FastingJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get main target
target = project.targets.first

# Get main group
main_group = project.main_group['FastingJourney']

# Files to add
files_to_add = [
  { path: 'FastingJourney/Models/HydrationEntry.swift', group_path: ['FastingJourney', 'Models'] },
  { path: 'FastingJourney/Models/HealthTip.swift', group_path: ['FastingJourney', 'Models'] },
  { path: 'FastingJourney/Services/MotivationalQuotesProvider.swift', group_path: ['FastingJourney', 'Services'] },
  { path: 'FastingJourney/Views/Settings/NotificationSettingsView.swift', group_path: ['FastingJourney', 'Views', 'Settings'] }
]

files_to_add.each do |file_info|
  file_path = file_info[:path]
  
  # Check if file exists
  unless File.exist?(file_path)
    puts "⚠️  File not found: #{file_path}"
    next
  end
  
  # Navigate to the correct group
  group = project.main_group
  file_info[:group_path].each do |group_name|
    group = group[group_name] || group.new_group(group_name)
  end
  
  # Check if file already exists in project
  existing_file = group.files.find { |f| f.path == File.basename(file_path) }
  if existing_file
    puts "✓ File already in project: #{file_path}"
    next
  end
  
  # Add file reference
  file_ref = group.new_reference(file_path)
  
  # Add to build phase
  target.add_file_references([file_ref])
  
  puts "✓ Added: #{file_path}"
end

# Save project
project.save

puts "\n✅ Project updated successfully!"
