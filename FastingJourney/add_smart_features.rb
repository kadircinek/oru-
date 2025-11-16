#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'FastingJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
services_group = project.main_group['FastingJourney']['Services']
settings_group = project.main_group['FastingJourney']['Views']['Settings']

# Add new service files
['LocationManager.swift', 'WeatherManager.swift', 'CalendarManager.swift'].each do |filename|
  file_path = "FastingJourney/Services/#{filename}"
  file_ref = services_group.new_reference(file_path)
  target.add_file_references([file_ref])
  puts "Added #{filename} to Services"
end

# Add SmartFeaturesView
file_path = "FastingJourney/Views/Settings/SmartFeaturesView.swift"
file_ref = settings_group.new_reference(file_path)
target.add_file_references([file_ref])
puts "Added SmartFeaturesView.swift to Views/Settings"

project.save
puts "Project updated successfully!"
