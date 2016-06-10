# FIXME:
#
# Production container environments won't yield the correct view
# template path for a cell. This is not the case when running the
# application locally regardless of environment type. If we explictly set
# the complete path for the views it works in all environments/platforms.
#
# Find out why!

Cell::ViewModel.class_eval { self.view_paths = ["#{::Rails.root}/app/cells"] }
