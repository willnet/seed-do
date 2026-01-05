BulkSeededModel.seed_once(:title) do |s|
  s.title = 'Existing'
  s.login = 'new'
end

BulkSeededModel.seed_once(:title) do |s|
  s.title = 'New'
  s.login = 'created'
end
