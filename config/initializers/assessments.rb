hash = YAML.load_file(File.join(Rails.root, 'config', 'assessments.yml'))

ASSESSMENTS_SCHEMA = hash['assessment']

hash = YAML.load_file(File.join(Rails.root, 'config', 'assessments_schema.yml'))

NEW_ASSESSMENTS_SCHEMA = hash['assessment']
