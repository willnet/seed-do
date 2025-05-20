require 'spec_helper'

describe SeedDo::Runner do
  it "should seed data from Ruby and gzipped Ruby files in the given fixtures directory" do
    SeedDo.seed(File.dirname(__FILE__) + '/fixtures')

    SeededModel.find(1).title.should == "Foo"
    SeededModel.find(2).title.should == "Bar"
    SeededModel.find(3).title.should == "Baz"
  end

  it "should seed only the data which matches the filter, if one is given" do
    SeedDo.seed(File.dirname(__FILE__) + '/fixtures', /_2/)

    SeededModel.count.should == 1
    SeededModel.find(2).title.should == "Bar"
  end

  it "should use the SeedDo.fixtures_paths variable to determine where fixtures are" do
    SeedDo.fixture_paths = [File.dirname(__FILE__) + '/fixtures']
    SeedDo.seed
    SeededModel.count.should == 3
  end
end
