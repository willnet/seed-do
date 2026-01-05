require 'spec_helper'

describe 'Bulk Insertion' do
  it 'uses upsert_all when bulk option is true' do
    expect(BulkSeededModel).to receive(:upsert_all).with(
      contain_exactly(
        hash_including('title' => 'Bulk 1', 'login' => 'bulk1'),
        hash_including('title' => 'Bulk 2', 'login' => 'bulk2')
      ),
      hash_including(unique_by: [:title])
    ).and_call_original

    SeedDo.seed("#{File.dirname(__FILE__)}/fixtures", /bulk_insert/, bulk: true)

    expect(BulkSeededModel.count).to eq(2)
    item1 = BulkSeededModel.find_by(title: 'Bulk 1')
    expect(item1.login).to eq 'bulk1'
    item2 = BulkSeededModel.find_by(title: 'Bulk 2')
    expect(item2.login).to eq 'bulk2'
  end

  it 'uses upsert_all with skip option for seed_once in bulk mode' do
    # Pre-create record
    BulkSeededModel.create!(title: 'Existing', login: 'original')

    expect(BulkSeededModel).to receive(:upsert_all).with(
      contain_exactly(
        hash_including('title' => 'Existing', 'login' => 'new'),
        hash_including('title' => 'New', 'login' => 'created')
      ),
      hash_including(unique_by: [:title], on_duplicate: :skip)
    ).and_call_original

    SeedDo.seed("#{File.dirname(__FILE__)}/fixtures", /bulk_seed_once/, bulk: true)

    expect(BulkSeededModel.count).to eq(2)
    existing = BulkSeededModel.find_by(title: 'Existing')
    expect(existing.login).to eq 'original' # Should NOT change
    new_rec = BulkSeededModel.find_by(title: 'New')
    expect(new_rec.login).to eq 'created'
  end
end
