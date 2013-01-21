require 'spec_helper'

describe SemanticVersioning::Version do

  def v(i); SemanticVersioning::Version.new(i); end

  let(:ver) { v('1.2.3-pre.1+build.2') }

  describe 'accepts only properly formatted strings' do
    specify do
      lambda { v('1.0.0-beta.1') }.should_not raise_error
      lambda { v('1.0.0.0') }.should raise_error(SemanticVersioning::ParsingError)
    end
  end

  describe 'instance methods' do
    specify { ver.major.should == 1 }
    specify { ver.minor.should == 2 }
    specify { ver.patch.should == 3 }
    specify { ver.pre.should   == 'pre.1' }
    specify { ver.build.should == 'build.2' }
  end

  describe 'segments' do
    specify do
      ver.segments.all? { |s| s.is_a?(SemanticVersioning::Segment) }.should be_true
    end
  end

  describe 'comparisons from semver.org' do
    specify { v('1.0.0-alpha').should           be < v('1.0.0-alpha.1') }
    specify { v('1.0.0-alpha.1').should         be < v('1.0.0-beta.2') }
    specify { v('1.0.0-beta.2').should          be < v('1.0.0-beta.11') }
    specify { v('1.0.0-beta.11').should         be < v('1.0.0-rc.1') }
    specify { v('1.0.0-rc.1').should            be < v('1.0.0-rc.1+build.1') }
    specify { v('1.0.0-rc.1+build.1').should    be < v('1.0.0') }
    specify { v('1.0.0').should                 be < v('1.0.0+0.3.7') }
    specify { v('1.0.0+0.3.7').should           be < v('1.3.7+build') }
    specify { v('1.3.7+build').should           be < v('1.3.7+build.2.b8f12d7') }
    specify { v('1.3.7+build.2.b8f12d7').should be < v('1.3.7+build.11.e0f985a') }
  end

  describe 'more comparisons' do
    specify { v('1.0.0').should be > v('1.0.0-rc.1+build.1') }
    specify { v('1.0.0-alpha').should == v('1.0.0-alpha') }
  end

end