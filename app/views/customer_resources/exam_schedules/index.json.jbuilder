json.array! @exams do |exam|
  json.extract! exam, :id, :name, :start_at, :booked_count
end
