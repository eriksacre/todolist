# Ensure all exhibits are loaded in dev/test
Exhibit.find_definitions(%w(app/exhibits)) if Rails.env.development? || Rails.env.test?