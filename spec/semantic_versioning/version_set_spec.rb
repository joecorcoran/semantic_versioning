require 'spec_helper'

describe SemanticVersioning::VersionSet do

  let(:versions) { [v('1.0.0'), v('1.0.10'), v('0.10.0')] }
  let(:set) { SemanticVersioning::VersionSet.new(versions) }

  it 'yields version in correct order' do
    results = set.map{ |v| v }
    results.should == [v('0.10.0'), v('1.0.0'), v('1.0.10')]
  end

  it 'discards duplicates' do
    set << v('1.0.0')
    set.length.should == versions.length
  end

  describe '#where' do
    it 'returns a new VersionSet' do
      set.where(:<, v('1.0.0')).should be_a SemanticVersioning::VersionSet
    end
    it 'allows version to be given as a string' do
      set.where(:<, '1.0.0').first.should be_a SemanticVersioning::Version
    end
    specify { set.where(:<,  v('1.0.10')).length.should == 2 }
    specify { set.where(:<=, v('1.0.10')).length.should == 3 }
    specify { set.where(:==, v('1.0.0')).length.should == 1 }
    specify { set.where(:>=, v('1.0.0')).length.should == 2 }
    specify { set.where(:>,  v('0.10.0')).length.should == 2 }
  end

end