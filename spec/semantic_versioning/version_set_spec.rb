require 'spec_helper'

describe SemanticVersioning::VersionSet do

  let(:versions)  { [v('1.0.0'), v('1.0.10'), v('0.10.0')] }
  let(:set_klass) { SemanticVersioning::VersionSet }
  let(:set)       { set_klass.new(versions) }

  specify 'constructor accepts array of strings' do
    set_klass.new(['1.0.0', '0.9.0']).should == set_klass.new([v('1.0.0'), v('0.9.0')])
  end

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
      set.where(:<, '1.0.0').should be_a SemanticVersioning::VersionSet
    end
    specify { set.where(:<,  v('1.0.10')).length.should == 2 }
    specify { set.where(:<=, v('1.0.10')).length.should == 3 }
    specify { set.where(:==, v('1.0.0')).length.should == 1 }
    specify { set.where(:>=, v('1.0.0')).length.should == 2 }
    specify { set.where(:>,  v('0.10.0')).length.should == 2 }
  end

end