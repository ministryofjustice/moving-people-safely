hash = YAML.load_file(File.join(Rails.root, 'config', 'assessments.yml'))

ASSESSMENTS_SCHEMA = hash['assessment']
