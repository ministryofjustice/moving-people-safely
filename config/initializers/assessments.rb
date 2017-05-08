hash = YAML.load_file(File.join(Rails.root, 'config', 'assessments_schema.yml'))

ASSESSMENTS_SCHEMA = hash['assessment']
