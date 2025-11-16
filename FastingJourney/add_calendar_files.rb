#!/usr/bin/env ruby
require 'xcodeproj'

project_path = 'FastingJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.first
models_group = project.main_group.find_subpath('FastingJourney/Models')
viewmodels_group = project.main_group.find_subpath('FastingJourney/ViewModels')
history_group = project.main_group.find_subpath('FastingJourney/Views/History')

# Add Calendar files
calendar_data = models_group.new_file('CalendarData.swift')
calendar_vm = viewmodels_group.new_file('CalendarViewModel.swift')
calendar_view = history_group.new_file('CalendarView.swift')

target.add_file_references([calendar_data, calendar_vm, calendar_view])

project.save
puts "Calendar files added successfully!"
